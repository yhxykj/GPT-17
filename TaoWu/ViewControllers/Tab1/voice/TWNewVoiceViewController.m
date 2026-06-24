//
//  TWNewVoiceViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/7.
//

#import "TWNewVoiceViewController.h"
#import "TWVoiceHandleView.h"
#import "TWVoiceRecordedATView.h"

#import <Speech/Speech.h>

@interface TWNewVoiceViewController ()<SFSpeechRecognizerDelegate,TWVoiceRecordedATViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tw_points_label;

@property (weak, nonatomic) IBOutlet UIView *tw_show_view;
@property (weak, nonatomic) IBOutlet UIImageView *tw_image;
@property (weak, nonatomic) IBOutlet UIImageView *tw_image2;
@property (weak, nonatomic) IBOutlet UIImageView *tw_image3;
@property (weak, nonatomic) IBOutlet UIImageView *tw_image4;
@property (weak, nonatomic) IBOutlet UILabel *tw_number_label;
@property (weak, nonatomic) IBOutlet UIView *tw_number_view;

//@property (weak, nonatomic) IBOutlet UIButton *tw_bofa_button;

@property (nonatomic, strong) TWSpeechRecognizer *shareRecognizer;
@property (nonatomic, strong) dispatch_source_t tw_timer;
@property (nonatomic, strong) TWVoiceHandleView *handleView;
@property (nonatomic, strong) TWPonitsView *tw_pointsView;
@property (nonatomic, strong) TWVoiceRecordedATView *recordedATView;
@property (nonatomic, strong) TWVipCardView *cardView;
@property (nonatomic, strong) TWGiveStarsView *tw_starView;

@property (nonatomic, copy) NSString *tw_questionStr;
@property (nonatomic, copy) NSString *socket_message;

@property (nonatomic, strong) NSMutableArray *tw_voices_array;
@property (nonatomic, assign) BOOL tw_status;

@end

@implementation TWNewVoiceViewController

//- (void)dealloc {
//    [TWSocketManager releaseInstance];
//    [self tw_endRecord];
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self tw_endRecord];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SOCKET tw_close];
    [TWSpeechSynthesisManager.sharedManager tw_stopPlayerVoice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tw_number_label.text = [NSString stringWithFormat:@"新用户免费次数：%ld",GlobalVC.numberTimes];
    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1) {
        self.tw_number_view.hidden = YES;
    }
    
    self.tw_status = YES;
    self.tw_voices_array = [NSMutableArray array];
    
    NSArray *voices_array = [SAVE_UDF objectForKey:@"voice"];
    if (voices_array.count > 0) {
        [self.tw_voices_array addObjectsFromArray:voices_array];
    }
    
    
    self.tw_points_label.text = [NSString stringWithFormat:@"%ld",GlobalVC.points_total];
    
    [self.tw_image.layer addSublayer:[GlobalVC tw_gradientLayer:self.tw_image.bounds withStartColor:UIColorFromRGB(0x2DD3D1) withEndColor:UIColorFromRGB(0x28D270) withStartPoint:CGPointMake(0.08, 0.11) withEndPoint:CGPointMake(0.93, 0.88)]];
    [self.tw_image2.layer addSublayer:[GlobalVC tw_gradientLayer:self.tw_image.bounds withStartColor:UIColorFromRGB(0x2DD3D1) withEndColor:UIColorFromRGB(0x28D270) withStartPoint:CGPointMake(0.08, 0.11) withEndPoint:CGPointMake(0.93, 0.88)]];
    [self.tw_image3.layer addSublayer:[GlobalVC tw_gradientLayer:self.tw_image.bounds withStartColor:UIColorFromRGB(0x2DD3D1) withEndColor:UIColorFromRGB(0x28D270) withStartPoint:CGPointMake(0.08, 0.11) withEndPoint:CGPointMake(0.93, 0.88)]];
    [self.tw_image4.layer addSublayer:[GlobalVC tw_gradientLayer:self.tw_image.bounds withStartColor:UIColorFromRGB(0x2DD3D1) withEndColor:UIColorFromRGB(0x28D270) withStartPoint:CGPointMake(0.08, 0.11) withEndPoint:CGPointMake(0.93, 0.88)]];

    self.handleView = [[TWVoiceHandleView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-200)/2-66, kScreenWidth, 200)];
    [self.view addSubview:self.handleView];
    [self.handleView setHidden:YES];
    self.handleView.sd_layout.leftSpaceToView(self.view, 0).widthIs(kScreenWidth).heightIs(200).topSpaceToView(self.view, (kScreenHeight-200)/2-66);

    self.recordedATView = [[TWVoiceRecordedATView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-200)/2-66, kScreenWidth, 200)];
    self.recordedATView.delegate = self;
    [self.view addSubview:self.recordedATView];
    
    [self.recordedATView setHidden:YES];
    
    
    self.recordedATView.sd_layout.leftSpaceToView(self.view, 0).widthIs(kScreenWidth).heightIs(200).topSpaceToView(self.view, (kScreenHeight-200)/2-66);
    
    self.shareRecognizer = [[TWSpeechRecognizer alloc] init];
    
    WS(weakSelf)
    self.shareRecognizer.recognizerCompleteBlock = ^(NSString * _Nonnull content) {
        [weakSelf tw_endRecord];
        weakSelf.tw_questionStr = content;
        [weakSelf tw_sendScoket];
    };
    
    self.shareRecognizer.recognizerFailBlock = ^{
        [weakSelf.tw_show_view setHidden:NO];
//        [SVProgressHUD showErrorWithStatus:@"语音识别失败！请重新进入改界面"];
        [weakSelf _judeUserStatus];
    };
    
    self.tw_pointsView = [[TWPonitsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_pointsView];
    self.tw_pointsView.alpha = 0.0;
    self.tw_pointsView.sd_layout.leftSpaceToView(self.view, 0).widthIs(kScreenWidth).heightIs(kScreenHeight).topSpaceToView(self.view, 0);
    
    self.tw_starView = [[TWGiveStarsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_starView];
    self.tw_starView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
//    self.tw_bofa_button.selected = NO;
    
    [TWSpeechSynthesisManager.sharedManager setVoiceSpeedplayDoneBlock:^{
        [weakSelf tw_bofaEnd];
    }];
    
    
#pragma mark - 会员卡片 -
    
    self.cardView = [[TWVipCardView alloc] init];
    [self.view addSubview:self.cardView];
    self.cardView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.cardView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    [self _judeUserStatus];
}


// 判断是否可以录音
- (void)_judeUserStatus {
    
//    if (self == nil) {
//        return;
//    }
//
    if ([GlobalVC tw_whetherCanUsedFree] == NO) {
        [self.cardView tw_showVipCardView];
        self.tw_status = false;
        return;
    }
//
//    if (GlobalVC.points_total < 5) {
//        [self.tw_pointsView _showImageView];
//        self.tw_show_view.hidden = NO;
//        return;
//    }
//
    [self tw_startRecord];
}


- (IBAction)tw_backButtonAction:(id)sender {
    [self tw_endRecord];
    [SOCKET tw_close];
    [self.recordedATView tw_stopRecorder];
    [TWSpeechSynthesisManager.sharedManager tw_stopPlayerVoice];
    self.shareRecognizer.recognizerFailBlock = nil;
    self.shareRecognizer.recognizerCompleteBlock = nil;
    TWSpeechSynthesisManager.sharedManager.voiceSpeedplayDoneBlock = nil;
    WS(weakSelf)
    self.shareRecognizer.recognizerStopBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.shareRecognizer tw_stopSpeechRecognition];
    
}


// 播放
- (IBAction)tw_openYyAction:(UIButton *)sender {
    
//    self.tw_bofa_button.selected = !self.tw_bofa_button.selected;
//
//    if (self.tw_bofa_button.selected == YES) {
//        [self.tw_bofa_button setImage:SetImage(@"yy_open") forState:UIControlStateNormal];
//
//        [self tw_bofaAnswer];
//
//        [self.recordedATView tw_stopRecorder];
//    }
//    else {
//        [self.tw_bofa_button setImage:SetImage(@"yy_stop") forState:UIControlStateNormal];
//
//        [self tw_bofaEnd];
//
//        [TWSpeechSynthesisManager.sharedManager tw_stopPlayerVoice];
//    }
}

/**
 开始录音
 */
- (void)tw_startRecord {

    WS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tw_show_view setHidden:YES];
        [weakSelf.recordedATView setHidden:NO];
    });
    
//    [self.tw_show_view setHidden:YES];
//
//    [self.recordedATView setHidden:NO];
    [self.recordedATView tw_recordVoice];
    [self.shareRecognizer initSpeechRecognizer]; /// 初始化语音识别
    [self.shareRecognizer tw_speechAudioBufferRecognitionRequest]; /// 开启语音识别
}

/**
 录音完成
 */

- (void)tw_endRecord {
    
    [self.shareRecognizer tw_stopSpeechRecognition];
//    [self.tw_show_view setHidden:YES];
    
    [self tw_countDownAndEnd];
//    [self.recordedATView setHidden:YES];
    
    WS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tw_show_view setHidden:YES];
        [weakSelf.recordedATView setHidden:YES];
    });
    
    
//    [self.recordedATView tw_stopRecorder];
//    [self.recordedATView tw_stopRecorder];
    
    
}

- (void)tw_countDownAndEnd {
    if (self.tw_timer) {
        dispatch_source_cancel(self.tw_timer);
        self.tw_timer = nil;
        NSLog(@"倒计时结束");
    }
    
}

- (void)tw_sendScoket {
    if ([GlobalVC IsNullString:self.tw_questionStr]) {
        return;
    }
    
    WS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.handleView setHidden:NO];
    });

    
//    [self.tw_bofa_button setHidden:YES];
    
    NSString *identifier = [GlobalVC tw_getCurrentUniqueIdentifier];
    NSString *socket = [NSString stringWithFormat:@"wss://jiaodelong.top/websocket/%@",identifier];
    
    self.socket_message = @"";

    
    [SOCKET tw_open:socket connect:^{

        [weakSelf tw_connentServer:identifier];

        } receive:^(id  _Nonnull message, TWSocketReceiveType type) {

            if ([message isEqualToString:@"DONE"]) {
                
                [weakSelf tw_bofaAnswer];
                
                
                [SOCKET tw_close];
                
                [weakSelf tw_saveVoiceAnswer];
                
                NSLog(@"====content:%@",self.socket_message);
                
                
                NSInteger count = [[SAVE_UDF objectForKey:@"useTimes"] intValue];
                
                if (count == 1) {
                    [UIView animateWithDuration:2.8 animations:^{
                                            
                    } completion:^(BOOL finished) {
                        
                        [weakSelf.tw_starView tw_openTheStarView];
                        
                    }];
                }
            }
            
            else {
                [self tw_reloadTableView:message];
            }

        } failure:^(NSError * _Nonnull error) {

            [SVProgressHUD showErrorWithStatus:@"连接中断"];
            

            [weakSelf.tw_show_view setHidden:NO];
            [weakSelf.handleView setHidden:YES];
        }];
}

// 播放回答的问题
- (void)tw_bofaAnswer {
    
    WS(weakSelf)
    [[TWSpeechSynthesisManager sharedManager] tw_playerVoice:self.socket_message];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.recordedATView.tw_status_label.text = @"正在讲话...";
        [weakSelf.tw_show_view setHidden:YES];
        [weakSelf.handleView setHidden:YES];
      
        [weakSelf.recordedATView setHidden:NO];
        
//        [weakSelf.tw_bofa_button setHidden:NO];
//        weakSelf.tw_bofa_button.selected = YES;
//        [weakSelf.tw_bofa_button setImage:SetImage(@"yy_open") forState:UIControlStateNormal];
    });
    
}

// 播放结束
- (void)tw_bofaEnd {
    WS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.recordedATView.tw_status_label.text = @"正在聆听...";
        [weakSelf.recordedATView setHidden:YES];
        [weakSelf.tw_show_view setHidden:NO];
        
        [weakSelf _judeUserStatus];
//        weakSelf.tw_bofa_button.selected = NO;
//        [weakSelf.tw_bofa_button setImage:SetImage(@"yy_stop") forState:UIControlStateNormal];
    });
}

- (void)tw_reloadTableView:(NSString *)msg {
    
    self.socket_message = [NSString stringWithFormat:@"%@%@",self.socket_message,msg];

}

- (void)tw_saveVoiceAnswer {
    
    if (self.socket_message.length > 0) {
        
        NSDictionary *obj = @{@"identifier":@"Robot",@"message":self.socket_message,@"status":@""};
        
        [self.tw_voices_array addObject:obj];
        
        [SAVE_UDF setValue:self.tw_voices_array forKey:@"voice"];
    }
    
//    GlobalVC.points_total = GlobalVC.points_total - 5;
    
//    NSLog(@"------------ GlobalVC.points_total ----%ld",GlobalVC.points_total);
    
//    self.tw_points_label.text = [NSString stringWithFormat:@"%ld",GlobalVC.points_total];
    
}

- (void)tw_connentServer:(NSString *)identifier {
    
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    [param setValue:self.tw_questionStr forKey:@"prompt"];
    [param setValue:identifier forKey:@"uid"];
    [param setValue:@"1" forKey:@"type"];
    [param setValue:@(1) forKey:@"modelType"];
    [param setObject:@"2" forKey:@"modelId"];
    
    
    NSDictionary *obj = @{@"identifier":@"User",@"message":self.tw_questionStr,@"status":@""};
    
    [self.tw_voices_array addObject:obj];
    
    [SAVE_UDF setValue:self.tw_voices_array forKey:@"voice"];
    
    self.tw_questionStr = @"";
    
    WS(weakSelf)
    [HttpClient postUrl:@"/ai/aiChat" param:param success:^(id  _Nonnull json) {
        
        NSInteger code = [[json objectForKey:@"code"] intValue];
        
        if (code == 500) {
            [weakSelf.tw_pointsView _showImageView];
            weakSelf.handleView.hidden = YES;
            weakSelf.recordedATView.hidden = YES;
            weakSelf.tw_show_view.hidden = NO;
            
            [SOCKET tw_close];
        }
            
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_thisRecordingHasBeenCompleted {
    [self tw_endRecord];
}

@end
