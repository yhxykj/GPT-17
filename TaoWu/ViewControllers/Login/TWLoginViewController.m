//
//  TWLoginViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWLoginViewController.h"
#import "TWPhoneLoginController.h"
#import "PNSBuildModelUtils.h"

@interface TWLoginViewController ()

@end

@implementation TWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)tw_minePhoneAction:(id)sender {
    TWPhoneLoginController *vc = [[TWPhoneLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSString *account = [GlobalVC tw_systemDeviceID];
//    NSMutableDictionary *param = NSMutableDictionary.dictionary;
//    [param setValue:account forKey:@"accountNumber"];
//    [param setValue:SystemType forKey:@"type"];
//
//    [SVProgressHUD show];
//
//    WS(weakSelf)
//    [HttpClient postUrl:@"/app/sms/login" param:param success:^(id  _Nonnull json) {
//        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//        [SAVE_UDF setValue:json[@"data"][@"token"] forKey:@"user_token"];
//
//        [weakSelf tw_loginSuccess];
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
}

- (IBAction)tw_loginButtonAction:(id)sender {
    [self tw_initQuickLogin];
}

- (void)tw_loginSuccess {
    [GlobalVC tw_getUserInfo];
    TWBaseTabBarViewController *tabBarController = TWBaseTabBarViewController.new;
    [GlobalVC.keywindow setRootViewController:tabBarController];
}

- (void)tw_initQuickLogin {
    TXCustomModel *model = [PNSBuildModelUtils buildModelWithStyle:PNSBuildModelStylePortrait button1Title:@"" target1:self selector1:@selector(_clickAutomaticLogin) button2Title:@"" target2:self selector2:@selector(_clickAutomaticLogin)];
    
    [SVProgressHUD show];
    
    
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [SVProgressHUD dismiss];

        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginClickPrivacyAlertView isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClickContinue isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClose isEqualToString:resultCode]) {
            
            NSLog(@"页面点击事件回调：%@", resultDic);
            
        }else if([PNSCodeLoginControllerClickProtocol isEqualToString:resultCode] ||
                 [PNSCodeLoginPrivacyAlertViewPrivacyContentClick isEqualToString:resultCode]){
            
            NSLog(@"页面点击事件回调：%@", resultDic);

            
        } else if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            
            NSLog(@"页面点击事件回调：%@", resultDic);
            
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
           
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            NSString *token = [resultDic objectForKey:@"token"];
            UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
            if ([token isKindOfClass:NSString.class]) {
                generalPasteboard.string = token;
            }
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
            
            [weakSelf _loginAction:token];
            
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)_clickAutomaticLogin {
    
}

- (void)_loginAction:(NSString *)token {
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    [param setObject:token forKey:@"accessToken"];
    
    [HttpClient postUrl:@"/app/aliyun/oauth" param:param success:^(id  _Nonnull json) {
        NSInteger code = [[json objectForKey:@"code"] intValue];
        if (code == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"user_token"];
            
            [GlobalVC tw_getUserInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];

}


@end
