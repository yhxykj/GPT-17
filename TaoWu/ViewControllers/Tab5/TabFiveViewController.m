//
//  TabFiveViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TabFiveViewController.h"
#import "TWShengYViewController.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

@interface TabFiveViewController ()
{
    __weak IBOutlet UILabel *tw_vip_identifier;
    __weak IBOutlet UILabel *tw_account_label;
    __weak IBOutlet UILabel *tw_email_label;
    
}
@end

@implementation TabFiveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = [GlobalVC tw_systemDeviceID];
    NSString *newString = [string stringByReplacingOccurrencesOfString:@"TaoWu_" withString:@""];

    NSLog(@"%@", newString);
    tw_account_label.text = newString;
    
    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1) {
        tw_vip_identifier.text = @"已开通会员";
    }
    
    NSString *originalString = GlobalVC.vipTime;
    if (originalString.length > 9) {
        NSRange range = NSMakeRange(0, 10);
        NSString *substring = [originalString substringWithRange:range];
        if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1) {
            if (GlobalVC.vipLabel == 1) {
                tw_vip_identifier.text = [NSString stringWithFormat:@"已开通:月会员 %@到期",substring];
            }
            else if (GlobalVC.vipLabel == 5) {
                tw_vip_identifier.text = [NSString stringWithFormat:@"已开通:周会员 %@到期",substring];
            }
            else if (GlobalVC.vipLabel == 4) {
                tw_vip_identifier.text = [NSString stringWithFormat:@"已开通:年会员 %@到期",substring];
            }
            else if (GlobalVC.vipLabel == 6) {
                tw_vip_identifier.text = [NSString stringWithFormat:@"已开通:终身会员 %@到期",substring];
            }
        }
    }
    [self getEmailAddress];
}

- (IBAction)tw_fuzhiAccountAction:(id)sender {
    [GlobalVC tw_pasteboard:tw_account_label.text];
}

- (IBAction)tw_enterVipPageAction:(id)sender {
    
    [GlobalVC twAction_enterVIPViewController];
}

- (IBAction)tw_chooseButtonAction:(UIButton *)sender {
    if (sender.tag == 301) {
        TWShengYViewController *syVC = [[TWShengYViewController alloc] init];
        [self.navigationController pushViewController:syVC animated:YES];
    }
    
    else if (sender.tag == 302) {
        TWPrivacyViewController *webVC = [[TWPrivacyViewController alloc] init];
        webVC.web_type = @"隐私协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    else if (sender.tag == 303) {
        TWPrivacyViewController *webVC = [[TWPrivacyViewController alloc] init];
        webVC.web_type = @"用户协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    else if (sender.tag == 304) {
        
        [GlobalVC tw_pasteboard:tw_email_label.text];
        
    }
    
    else if (sender.tag == 305) {
        
        [self _cleanCache];
    }
}

- (void)_cleanCache {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要清除聊天记录吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *user_token = [SAVE_UDF objectForKey:@"user_token"];
        NSString *vipStatus = [SAVE_UDF objectForKey:@"vipStatus"];
        NSString *aliyunToken = [SAVE_UDF objectForKey:@"aliyunToken"];
        NSString *useSum = [SAVE_UDF objectForKey:@"useTimes"];
        
        NSString *appBundle = [[NSBundle mainBundle] bundleIdentifier];
        [SAVE_UDF removePersistentDomainForName:appBundle];
        
        [SAVE_UDF setValue:user_token forKey:@"user_token"];
        [SAVE_UDF setValue:vipStatus forKey:@"vipStatus"];
        [SAVE_UDF setValue:aliyunToken forKey:@"aliyunToken"];
        [SAVE_UDF setValue:useSum forKey:@"useTimes"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadChatRecordsNotificationName" object:nil];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openAppStoreReview {
    
    YWFeedbackKit *fb = [YWFeedbackKit.alloc initWithAppKey:@"334084237" appSecret:@"d8de4c5760974d0baa781c8cc1f4949d"];
    [SVProgressHUD showWithStatus:@"加载反馈中心..."];

    [fb makeFeedbackViewControllerWithCompletionBlock:^(BCFeedbackViewController *viewController, NSError *error) {
        [SVProgressHUD dismiss];
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            nav.navigationBar.tintColor = [UIColor blackColor];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
            viewController.closeBlock = ^(UIViewController *aParentController) {
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            };
        } else {
            NSLog(@"加载失败：%@", error);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"加载失败：%@", error]];
        }
        
        
    }];

}

- (void)getEmailAddress {
    [SVProgressHUD show];
    [HttpClient postUrl:@"/app/email" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
           
      tw_email_label.text = [json objectForKey:@"data"];
        
    } failure:^(NSError * _Nonnull error) {
        
    
    }];
}

@end
