//
//  TabOneViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TabOneViewController.h"
#import "TWVoiceViewController.h"
#import "TWDHViewController.h"

@interface TabOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *title_view;
@property (weak, nonatomic) IBOutlet UIScrollView *superScrollView;
@property (weak, nonatomic) IBOutlet UIButton *tw_dh_status_button;

@property (nonatomic, strong) TWVoiceViewController *voiceVC;
@property (nonatomic, strong) TWMainViewController *dhVC;

@property (nonatomic, strong) TWChooseModeView *modeView;

@end

@implementation TabOneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.superScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
    self.superScrollView.bounces = NO;
    self.superScrollView.scrollEnabled = NO;
    
    self.dhVC = [[TWMainViewController alloc] init];
    self.dhVC.isdefault = YES;
    [self.superScrollView addSubview:self.dhVC.view];

    self.voiceVC = [[TWVoiceViewController alloc] init];
    [self.superScrollView addSubview:self.voiceVC.view];

    [self addChildViewController:self.dhVC];
    [self addChildViewController:self.voiceVC];

    self.dhVC.view.sd_layout.leftSpaceToView(self.superScrollView, 0).topSpaceToView(self.superScrollView, 0).widthIs(kScreenWidth).bottomSpaceToView(self.superScrollView, 0);
    self.voiceVC.view.sd_layout.leftSpaceToView(self.superScrollView, kScreenWidth).topSpaceToView(self.superScrollView, 0).widthIs(kScreenWidth).bottomSpaceToView(self.superScrollView, 0);
    
    self.modeView = [[TWChooseModeView alloc] init];
    [TWGlobalVC.shared.keywindow addSubview:self.modeView];
    self.modeView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    if ([GlobalVC IsNullString:[SAVE_UDF objectForKey:@"user_token"]]) {
        [self tw_loginAction];
    }
    else {
        [GlobalVC tw_getUserInfo];
    }
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectStatus) name:@"updatesTheStatusOfTheSelectedMode" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tw_loginAction) name:@"loginAccountNotificationName" object:nil];
    
    
    if ([[NSUserDefaults.standardUserDefaults objectForKey:@"vipStatus"] intValue] != 1) {
        if ([GlobalVC IsNullString:[SAVE_UDF objectForKey:@"user_token"]] == false) {
            [GlobalVC twAction_enterVIPViewController];
        }
    }
    
    
}

- (void)updateSelectStatus {
    [self.tw_dh_status_button setImage:GlobalVC.isMode?SetImage(@"dh_gaoji_s"):SetImage(@"dh_jichu_s") forState:UIControlStateNormal];
}

- (IBAction)vc_enterVip:(id)sender {
    
    [GlobalVC twAction_enterVIPViewController];
    
}

- (IBAction)tw_chooseMode:(id)sender {
    [self.modeView tw_showView];
}

- (IBAction)tw_chooseTypeAction:(UIButton *)sender {
    
    for (UIView *obj in self.title_view.subviews) {
        UIButton *button = (UIButton *)obj;
        [button setTitleColor:UIColorFromRGB(0x8A8A8A) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        if (button == sender) {
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
        }
    }
    
    if (sender.tag == 302) {
        [self.superScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (sender.tag == 303) {
        [self.superScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
    else {
        [self.superScrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:YES];
    }
}

- (void)tw_loginAction {
    NSString *account = [GlobalVC tw_systemDeviceID];
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    [param setValue:account forKey:@"accountNumber"];
    [param setValue:SystemType forKey:@"type"];
    
    [SVProgressHUD show];
    
    [HttpClient postUrl:@"/app/sms/login" param:param success:^(id  _Nonnull json) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [SAVE_UDF setValue:json[@"data"][@"token"] forKey:@"user_token"];
        
        [GlobalVC tw_getUserInfo];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



@end
