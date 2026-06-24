//
//  TWVoiceRecordedATView.m
//  TaoWu
//
//  Created by JJK on 2023/12/8.
//

#import "TWVoiceRecordedATView.h"
#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TWVoiceRecordedATView ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, assign) CGFloat newSize;

@property (nonatomic, strong) NSMutableArray *levels;
@property (nonatomic, strong) AVAudioPlayer *player;

//@property (nonatomic, strong) NSTimer *tw_timer;
//@property (nonatomic, strong) NSTimer *yy_timer;
@property (nonatomic, assign) BOOL isStatus; //判断是否录音正常

@end

@implementation TWVoiceRecordedATView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWVoiceRecordedATView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        [self tw_create];
        self.newSize = 1;
        self.levels = [NSMutableArray array];
        
        for(int i = 0 ; i < 4 ; i++){
            [self.levels addObject:@(74)];
        }
        
//        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_updatedbSize:) name:@"soundSizeNotificationName" object:nil];
        
    }
    return self;
}

- (void)tw_create {

    [self initAudioRecorder];
}

- (void)initAudioRecorder {
  
  //----------------AVAudioRecorder----------------
  // 录音会话设置
  NSError *errorSession = nil;
  AVAudioSession * audioSession = [AVAudioSession sharedInstance]; // 得到AVAudioSession单例对象
  [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &errorSession];// 设置类别,表示该应用同时支持播放和录音
  [audioSession setActive:YES error: &errorSession];// 启动音频会话管理,此时会阻断后台音乐的播放.
  
  // 设置成扬声器播放
  UInt32 doChangeDefault = 1;
  AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
  
  // 创建录音配置信息的字典
  NSDictionary *setting = @{
                            AVFormatIDKey : @(kAudioFormatAppleIMA4),// 音频格式
                            AVSampleRateKey : @44100.0f,// 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
                            AVNumberOfChannelsKey : @1,// 音频通道数 1 或 2
                            AVEncoderBitDepthHintKey : @16,// 线性音频的位深度 8、16、24、32
                            AVEncoderAudioQualityKey : @(AVAudioQualityHigh)// 录音的质量
                            };
  
  
  // 1.创建存放录音文件的地址（音频流写入文件的本地文件URL）
    self.tw_outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"record.caf"];
//    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
  NSURL *url = [NSURL URLWithString:self.tw_outputPath];
  
  // 2.初始化 AVAudioRecorder 对象
  NSError *error;
  self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
  
  if (self.audioRecorder) {
    
    self.audioRecorder.delegate = self;// 3.设置代理
    self.audioRecorder.meteringEnabled = YES;
    
    // 4.设置录音时长，超过这个时间后，会暂停 单位是 秒
    //    [self.audioRecorder recordForDuration:10];
    
    // 5.创建一个音频文件，并准备系统进行录制
    [self.audioRecorder prepareToRecord];
  } else {
    NSLog(@"Error: %@", [error localizedDescription]);
  }
    
}


- (void)tw_recordVoice {
    [self.audioRecorder record];
    [self startAnimation];
}

- (void)startAnimation {
//    self.tw_status_label.text = @"正在聆听...";
    
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder updateMeters];
        
        // 获取录音通道1的音量值
        float power = [self.audioRecorder averagePowerForChannel:0];
        
        float amplitude = powf(10.0, power / 20.0);
        NSLog(@"音频功率：%.2f", amplitude);
        
        
        if (power < 1.0) {
            power = 1.0;
        }

        CGFloat imageHeight = amplitude * 100 + 74;
        
        // 继续循环执行动画
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.082];
        
        
        [self.levels removeObjectAtIndex:3];
        [self.levels insertObject:@(imageHeight) atIndex:0];
        
//        [self tw_updateImageHight];
        
        [self tw_updateImageHight:amplitude];
    }
}

- (void)tw_updateImageHight:(CGFloat)amplitude {
    
    
    NSInteger randomIndex = arc4random_uniform((unsigned int)4);
    CGFloat tw_height = amplitude * 120 + 74;
    if ([self.tw_status_label.text isEqualToString:@"正在讲话..."]) {
        tw_height = (amplitude + 0.2)*74 + 74;
    }
    
    
    WS(weakSelf)
    [UIView animateWithDuration:0.234 animations:^{

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

            [weakSelf.tw_record_image_height1 setConstant:74];
            [weakSelf.tw_record_image_height2 setConstant:74];
            [weakSelf.tw_record_image_height3 setConstant:74];
            [weakSelf.tw_record_image_height4 setConstant:74];

            if (randomIndex == 0) {
                [weakSelf.tw_record_image_height1 setConstant:tw_height];
            }
            else if (randomIndex == 1) {
                [weakSelf.tw_record_image_height2 setConstant:tw_height];
            }
            else if (randomIndex == 2) {
                [weakSelf.tw_record_image_height3 setConstant:tw_height];
            }
            else if (randomIndex == 3) {
                [weakSelf.tw_record_image_height4 setConstant:tw_height];
            }
            
            [weakSelf layoutIfNeeded];
            
            dispatch_semaphore_signal(semaphore);
        });

    }completion:^(BOOL finished) {

    }];

    
//    for (int i = 0; i < 4; i++) {
//        CGFloat tw_height = [self.levels[i] floatValue];
//        if (i == 0) {
//            [self.tw_record_image_height1 setConstant:tw_height];
//        }
//        else if (i == 1) {
//            [self.tw_record_image_height2 setConstant:tw_height];
//        }
//        else if (i == 2) {
//            [self.tw_record_image_height3 setConstant:tw_height];
//        }
//        else if (i == 3) {
//            [self.tw_record_image_height4 setConstant:tw_height];
//        }
//    }
}

- (void)tw_stopRecorder {
    [self.audioRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"%@",self.tw_outputPath);
    NSLog(@"--- 录音结束 ---");
}

- (void)dealloc {
//    if (self.yy_timer) {
//        [self.yy_timer invalidate];
//        self.yy_timer = nil;
//    }
}

- (void)_updatedbSize:(NSNotification *)notification {
    
    
    
    NSDictionary *obj = notification.userInfo;
    CGFloat x_height = [[obj objectForKey:@"soundValue"] floatValue] + 0.231;
    
    NSInteger randomIndex = arc4random_uniform((unsigned int)4);
    CGFloat tw_height = x_height*74;
    
    WS(weakSelf)
    [UIView animateWithDuration:0.234 animations:^{

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

            [weakSelf.tw_record_image_height1 setConstant:74];
            [weakSelf.tw_record_image_height2 setConstant:74];
            [weakSelf.tw_record_image_height3 setConstant:74];
            [weakSelf.tw_record_image_height4 setConstant:74];

            if (randomIndex == 0) {
                [weakSelf.tw_record_image_height1 setConstant:tw_height];
            }
            else if (randomIndex == 1) {
                [weakSelf.tw_record_image_height2 setConstant:tw_height];
            }
            else if (randomIndex == 2) {
                [weakSelf.tw_record_image_height3 setConstant:tw_height];
            }
            else if (randomIndex == 3) {
                [weakSelf.tw_record_image_height4 setConstant:tw_height];
            }
            
            [weakSelf layoutIfNeeded];
            
            dispatch_semaphore_signal(semaphore);
        });

    }completion:^(BOOL finished) {

    }];

    NSLog(@"================%f.",tw_height);
}

//- (void)_createYYTimer {
//
//    if (self.yy_timer) {
//        [self.yy_timer invalidate];
//        self.yy_timer = nil;
//    }
//
//    self.yy_timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(endOfRecording) userInfo:nil repeats:YES];
//}
//
//- (void)endOfRecording {
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(_thisRecordingHasBeenCompleted)]) {
//        [self.delegate _thisRecordingHasBeenCompleted];
//
//        if (self.yy_timer) {
//            [self.yy_timer invalidate];
//            self.yy_timer = nil;
//        }
//
//    }
//
//}

@end
