//
//  TWDHViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWDHViewController.h"

@interface TWDHViewController ()

@end

@implementation TWDHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)vc_chatMain:(id)sender {
    
    TWMainViewController *mainVC = [[TWMainViewController alloc] init];
    mainVC.isdefault = YES;
    [self.navigationController pushViewController:mainVC animated:YES];
    
}

- (IBAction)tw_choosedefaultQuestionAction:(UIButton *)sender {
//    TWMainViewController *mainVC = [[TWMainViewController alloc] init];
//    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
