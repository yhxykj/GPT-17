//
//  TWSpeechSynthesisManager.m
//  TaoWu
//
//  Created by JJK on 2023/12/6.
//

#import "TWSpeechSynthesisManager.h"
#import <AdSupport/ASIdentifierManager.h>

@interface TWSpeechSynthesisManager () <NlsPlayerDelegate,NeoNuiTtsDelegate>

@end

@implementation TWSpeechSynthesisManager

static int loop_in = 0;
static BOOL loop_flag = NO;

static BOOL continuous_playback_flag = NO;
static BOOL SegmentFinishPlaying = NO;

static dispatch_queue_t work_queue;

+ (instancetype)sharedManager {
    
    static TWSpeechSynthesisManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TWSpeechSynthesisManager alloc] init];
    });
    
    return instance;
    
}

/**
 初始化
 */
- (void)initNuiTts {
    
    NSString *token = [SAVE_UDF objectForKey:@"aliyunToken"];
    
    if ([GlobalVC IsNullString:token]) {
        [GlobalVC tw_getAliyunToken];
        return;
    }
    
    [self tw_stopPlayerVoice];
    
    if (self.tw_utils == nil) {
        self.tw_utils = [[NuiSdkUtils alloc] init];
        work_queue = dispatch_queue_create("NuiTtsController", DISPATCH_QUEUE_CONCURRENT);
    }
    
    if (self.tw_voicePlayer == nil) {
        self.tw_voicePlayer = [[NLSPlayAudio alloc] init];
        self.tw_voicePlayer.delegate = self;
    }
    
    if (self.tw_nui == nil) {
        self.tw_nui = [NeoNuiTts get_instance];
        self.tw_nui.delegate = self;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *initParam = [self configuringAudioParameters];
        
        int retcode = [self.tw_nui nui_tts_initialize:[initParam UTF8String] logLevel:LOG_LEVEL_VERBOSE saveLog:YES];
        if (retcode != 0) {
             TLog(@"init failed.retcode:%d", retcode);
             return;
         }
    #ifdef DEBUG_TTS_DATA_SAVE
        NSString *sp = self.createDir;
        const char* savePath = [sp UTF8String];

        if (fp == nullptr) {
            NSString *debug_file = [NSString stringWithFormat:@"%@/tts_dump.pcm", sp];
            fp = fopen([debug_file UTF8String], "w");
        }
    #endif
    });
    
}

/**
 配置语音合成的参数
 */
- (NSString *)configuringAudioParameters {
//    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    NSString *bundlePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"]] resourcePath];
    NSString *id_string = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *debug_path = [self.tw_utils createDir];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString *token = [SAVE_UDF objectForKey:@"aliyunToken"];
    
    [param setObject:@"FwsOLV8DKcHopkcl" forKey:@"app_key"];
    [param setObject:token forKey:@"token"];
    [param setObject:bundlePath forKey:@"workspace"]; // 必填, 且需要有读写权限
    [param setObject:debug_path forKey:@"debug_path"];
    [param setObject:id_string forKey:@"device_id"]; // 必填, 推荐填入具有唯一性的id, 方便定位问题
    [param setObject:@"wss://nls-gateway.cn-shanghai.aliyuncs.com:443/ws/v1" forKey:@"url"]; // 默认
    [param setObject:@"2" forKey:@"mode_type"]; // 必填  // 设置成在线语音合成模式, 这个设置很重要, 遗漏会导致无法运行

    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

/**
 播放音频内容
 */
- (void)tw_playerVoice:(NSString *)content {
    if (!self.tw_nui) {
        TLog(@"tts not init");
        return;
    }
    
    [self updatePlayParam:content];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

    dispatch_async(work_queue, ^{
        // 如果上个任务没有合成完毕，手动取消，开始合成新的任务
        [self.tw_nui nui_tts_cancel:NULL];

        [self.tw_nui nui_tts_play:"1" taskId:"" text:[content UTF8String]];
    });
    
    
}


/**
 更新播放时的参数
 */
- (void)updatePlayParam:(NSString *)content {
    
    if ([[SAVE_UDF objectForKey:@"font_name"] length] > 0) {
        NSString *font_name = [SAVE_UDF objectForKey:@"font_name"];
        [self.tw_nui nui_tts_set_param:"font_name" value:[font_name UTF8String]]; /// 设置语言类型
    }else {
        [self.tw_nui nui_tts_set_param:"font_name" value:[@"zhimiao_emo" UTF8String]]; /// 设置语言类型
    }
    
    
    int chars = 0;
    [self.tw_nui nui_tts_set_param:"mode_type" value:"2"]; // 必填

    chars = [self.tw_nui nui_tts_get_num_of_chars: [content UTF8String]];
    if (chars > 300) {
        [self.tw_nui nui_tts_set_param:"tts_version" value:"1"];
    } else {
        [self.tw_nui nui_tts_set_param:"tts_version" value:"0"];//d53560e5349348a2aa8623ce93371737
    }
        

    // 详细参数可见: https://help.aliyun.com/document_detail/173642.html
    
    NSString *speed_level = [SAVE_UDF objectForKey:@"speed_level"];
    
    if ([speed_level floatValue] > 0.5) {
        [self.tw_nui nui_tts_set_param:"speed_level" value:[speed_level UTF8String]]; /// 设置语速
    }else {
        [self.tw_nui nui_tts_set_param:"speed_level" value:[@"1.0" UTF8String]]; /// 设置语速
    }
    
//    [self.tw_nui nui_tts_set_param:"pitch_level" value:[@"" UTF8String]]; ///  设置地区语言
    [self.tw_nui nui_tts_set_param:"volume" value:[@"0" UTF8String]]; ///  设置音量大小
    
    [self.tw_nui nui_tts_set_param:"enable_subtitle" value:"1"];
}

#pragma mark - tts callback
- (void)onNuiTtsEventCallback:(NuiSdkTtsEvent)event taskId:(char*)taskid code:(int)code {
    TLog(@"onNuiTtsEventCallback event[%d]", event);
    if (event == TTS_EVENT_START) {
        TLog(@"onNuiTtsEventCallback TTS_EVENT_START");
        loop_in = TTS_EVENT_START;
        // 启动播放器
        [self->_tw_voicePlayer play];
    } else if (event == TTS_EVENT_END || event == TTS_EVENT_CANCEL || event == TTS_EVENT_ERROR) {
        loop_in = event;
        if (event == TTS_EVENT_END) {
            TLog(@"onNuiTtsEventCallback TTS_EVENT_END");
            // 注意这里的event事件是指语音合成完成，而非播放完成，播放完成需要由voicePlayer对象来进行通知
            [self->_tw_voicePlayer drain];
        } else {
            // 取消播报、或者发生异常时终止播放
            [self->_tw_voicePlayer stop];
        }
        if (event == TTS_EVENT_ERROR) {
            const char *errmsg = [self.tw_nui nui_tts_get_param: "error_msg"];
            TLog(@"tts get errmsg:%s", errmsg);
        }
    }
}

- (void)onNuiTtsUserdataCallback:(char*)info infoLen:(int)info_len buffer:(char*)buffer len:(int)len taskId:(char*)task_id {
    TLog(@"onNuiTtsUserdataCallback info ...");
    if (info_len > 0) {
        TLog(@"onNuiTtsUserdataCallback info text %s. index %d.", info, info_len);
    }
    if (len > 0) {
        [_tw_voicePlayer write:(char*)buffer Length:(unsigned int)len];
    }
}

-(void)onNuiTtsVolumeCallback:(int)volume taskId:(char*)task_id {
    ;
}

- (void)tw_stopPlayerVoice {
    [self.tw_voicePlayer stop];
    [self.tw_nui nui_tts_cancel:NULL];
}

- (void)playerDidFinish {
    NSLog(@"播放完成！");
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"voiceSpeedplayDoneNotificationName" object:nil];
    
    if (self.voiceSpeedplayDoneBlock) {
        self.voiceSpeedplayDoneBlock();
    }
    
}

@end
