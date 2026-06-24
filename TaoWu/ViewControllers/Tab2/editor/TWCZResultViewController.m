//
//  TWCZResultViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TWCZResultViewController.h"

@interface TWCZResultViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tw_content_textView;
@property (weak, nonatomic) IBOutlet UIButton *tw_cxsc_button;
@property (nonatomic, strong) dispatch_source_t tw_timer;
@property (nonatomic, copy) NSString *socket_message;

@property (nonatomic, strong) TWVipCardView *cardView;
@property (nonatomic, strong) TWGiveStarsView *tw_starView;

@end

@implementation TWCZResultViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tw_countDownAndEnd];
    [SOCKET tw_close];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardView = [[TWVipCardView alloc] init];
    [self.view addSubview:self.cardView];
    self.cardView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.cardView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    self.tw_starView = [[TWGiveStarsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_starView];
    self.tw_starView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    [self tw_connectSocket];
    [SVProgressHUD show];
}

- (void)tw_connectSocket {

    NSString *identifier = [GlobalVC tw_getCurrentUniqueIdentifier];
    NSString *socket = [NSString stringWithFormat:@"wss://jiaodelong.top/websocket/%@",identifier];

    self.socket_message = @"";
    
    [self tw_createTimer];
    
    [self.tw_cxsc_button setEnabled:NO];
    
    WS(weakSelf)
    [SOCKET tw_open:socket connect:^{

        [weakSelf tw_connentServer:identifier];

        } receive:^(id  _Nonnull message, TWSocketReceiveType type) {
            [SVProgressHUD dismiss];
            if ([message isEqualToString:@"DONE"]) {
                
                [weakSelf tw_countDownAndEnd];
                [SOCKET tw_close];
                
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
            [self.tw_cxsc_button setEnabled:YES];
            [SVProgressHUD showErrorWithStatus:@"连接中断"];

        }];
}

- (void)tw_connentServer:(NSString *)identifier {
    
    [GlobalVC tw_connentServer:identifier withContent:self.tw_question withChatType:self.tw_type withLastType:NO];
}

- (void)tw_reloadTableView:(NSString *)msg {
    self.socket_message = [NSString stringWithFormat:@"%@%@",self.socket_message,msg];
    self.tw_content_textView.text = self.socket_message;
    
    NSString *tool = self.tw_content_textView.text;
    NSRange kuaisu = NSMakeRange(tool.length - 1, 1);
    [self.tw_content_textView scrollRangeToVisible:kuaisu];
}

- (void)tw_createTimer {
    
    WS(weakSelf)
    __block NSInteger countdown = 15;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.tw_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.tw_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.tw_timer, ^{
        countdown--;
        if (countdown >= 0) {
            NSLog(@"倒计时：%ld", (long)countdown);
        } else {
            [weakSelf tw_countDownAndEnd];
        }
    });
    dispatch_resume(self.tw_timer);
}

- (void)tw_countDownAndEnd {
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.tw_cxsc_button setEnabled:YES];
    });
    
    if (self.tw_timer) {
        dispatch_source_cancel(self.tw_timer);
        self.tw_timer = nil;
        NSLog(@"倒计时结束");
    }
    
    
}


- (IBAction)tw_fuzhiAction:(id)sender {
    [GlobalVC tw_pasteboard:self.tw_content_textView.text];
}

- (IBAction)tw_cxShengchengAction:(id)sender {
    
    if ([GlobalVC tw_whetherCanUsedFree] == NO) {
        
        [self.cardView tw_showVipCardView];
        return;
        
    }
    
    self.tw_content_textView.text = @"";
    [self tw_connectSocket];
}

@end
