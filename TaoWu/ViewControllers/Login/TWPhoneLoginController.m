//
//  TWPhoneLoginController.m
//  TaoWu
//
//  Created by JJK on 2024/3/4.
//

#import "TWPhoneLoginController.h"
#import "TabOneViewController.h"

@interface TWPhoneLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *tw_phone_text;
@property (weak, nonatomic) IBOutlet UITextField *tw_code_text;
@property (weak, nonatomic) IBOutlet UIButton *code_button;
@property (weak, nonatomic) IBOutlet UIButton *login_button;

@property (nonatomic, strong) NSTimer *tw_timer;
@property (nonatomic, assign) NSInteger total_num;

@end

@implementation TWPhoneLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.total_num = 60;
    [self.login_button setEnabled:NO];
    [self.login_button setImage:SetImage(@"phoneloginbtn_n") forState:UIControlStateNormal];
    
    [self.tw_phone_text addTarget:self action:@selector(tw_phoneTextChange) forControlEvents:UIControlEventEditingChanged];
    [self.tw_code_text addTarget:self action:@selector(tw_phoneTextChange) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)tw_getCodeAction:(id)sender {
    if ([GlobalVC IsNullString:self.tw_phone_text.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空！"];
        return;
    }
    if (self.total_num == 60) {
        [self tw_initTimer];
    }
    [SVProgressHUD show];
    [self tw_getLoginVerityCode];
}

- (IBAction)tw_loginAction:(id)sender {
    if ([GlobalVC IsNullString:self.tw_code_text.text]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空！"];
        return;
    }
    if ([GlobalVC IsNullString:self.tw_phone_text.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空！"];
        return;
    }
    
    [SVProgressHUD show];
    [self tw_accountLoginAction];
}

- (void)tw_phoneTextChange {
    if (self.tw_code_text.text.length == 4 && self.tw_phone_text.text.length == 11) {
        [self.login_button setEnabled:YES];
        [self.login_button setImage:SetImage(@"phoneloginbtn_s") forState:UIControlStateNormal];
    }
    else {
        [self.login_button setEnabled:NO];
        [self.login_button setImage:SetImage(@"phoneloginbtn_n") forState:UIControlStateNormal];
    }
}

// 验证码
- (void)tw_getLoginVerityCode {
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    [object setObject:self.tw_phone_text.text forKey:@"phonenumber"];
    [HttpClient postUrl:@"/app/sms/getcode" param:object success:^(id  _Nonnull json) {
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功！"];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"验证码发送失败！"];
    }];
}

// 登录
- (void)tw_accountLoginAction {
    NSString *account = [GlobalVC  tw_systemDeviceID];
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    [object setObject:self.tw_code_text.text forKey:@"smsCode"];
    [object setObject:self.tw_phone_text.text forKey:@"phonenumber"];
    [object setObject:account forKey:@"accountNumber"];
    [object setObject:SystemType forKey:@"type"];
    
    [HttpClient postUrl:@"/app/sms/smsCode/login" param:object success:^(id  _Nonnull json) {
        NSInteger code = [[object objectForKey:@"code"] intValue];
        if (code == 200) {
            [SAVE_UDF setValue:json[@"data"][@"token"] forKey:@"user_token"];
            
            [GlobalVC tw_getUserInfo];
            
            for (UIViewController *obj in self.navigationController.viewControllers) {
                if ([obj isKindOfClass:[TabOneViewController class]]) {
                    
                    TabOneViewController *vc = (TabOneViewController *)obj;
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
            }
            
            
            
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)tw_initTimer {
    self.tw_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    self.total_num = 60;
    [self.tw_timer invalidate];
    self.tw_timer = nil;
}

- (void)updateTimer {
    if (self.total_num == 0) {
        [self stopTimer];
        [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
        NSLog(@"倒计时完成");
    } else {
        self.total_num--;
        [self.code_button setTitle:[NSString stringWithFormat:@"%lds",(long)self.total_num] forState:UIControlStateNormal];
        NSLog(@"剩余时间：%ld", (long)self.total_num);
    }
}


@end
