//
//  TabFourViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TabFourViewController.h"
#import "TWPlazaViewController.h"
#import "TWBasicsViewController.h"
#import "TWAdvancedViewController.h"
#import "TWPaintHistoryViewController.h"

@interface TabFourViewController ()

@property (weak, nonatomic) IBOutlet UIView *tw_title_view;
@property (weak, nonatomic) IBOutlet UILabel *tw_jf_label;
@property (weak, nonatomic) IBOutlet UIScrollView *tw_bgScrollView;

@property (nonatomic, strong) TWPlazaViewController *tw_plazaVC;
@property (nonatomic, strong) TWBasicsViewController *tw_basicsVC;
@property (nonatomic, strong) TWAdvancedViewController *tw_advanceVC;

@end

@implementation TabFourViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.tw_jf_label.text = [NSString stringWithFormat:@"%ld",GlobalVC.points_total];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tw_bgScrollView.contentSize = CGSizeMake(kScreenWidth*3, 0);
    self.tw_bgScrollView.bounces = NO;
    self.tw_bgScrollView.scrollEnabled = NO;
    
    self.tw_plazaVC = [[TWPlazaViewController alloc] init];
    [self.tw_bgScrollView addSubview:self.tw_plazaVC.view];

    self.tw_basicsVC = [[TWBasicsViewController alloc] init];
    [self.tw_bgScrollView addSubview:self.tw_basicsVC.view];

    self.tw_advanceVC = [[TWAdvancedViewController alloc] init];
    [self.tw_bgScrollView addSubview:self.tw_advanceVC.view];

    [self addChildViewController:self.tw_plazaVC];
    [self addChildViewController:self.tw_basicsVC];
    [self addChildViewController:self.tw_advanceVC];

    self.tw_plazaVC.view.sd_layout.leftSpaceToView(self.tw_bgScrollView, 0).topSpaceToView(self.tw_bgScrollView, 0).widthIs(kScreenWidth).bottomSpaceToView(self.tw_bgScrollView, 0);
    self.tw_basicsVC.view.sd_layout.leftSpaceToView(self.tw_bgScrollView, kScreenWidth).topSpaceToView(self.tw_bgScrollView, 0).widthIs(kScreenWidth).bottomSpaceToView(self.tw_bgScrollView, 0);
    self.tw_advanceVC.view.sd_layout.leftSpaceToView(self.tw_bgScrollView, kScreenWidth*2).topSpaceToView(self.tw_bgScrollView, 0).widthIs(kScreenWidth).bottomSpaceToView(self.tw_bgScrollView, 0);
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(tw_updatePointsAction) name:@"TWUpdateUserPointsNotificationName" object:nil];
    
    
}

- (void)tw_updatePointsAction {
    [self tw_getUserInfo];
}

- (IBAction)tw_leftButtonAction:(id)sender {
    TWPaintHistoryViewController *paintVC = [[TWPaintHistoryViewController alloc] init];
    [self.navigationController pushViewController:paintVC animated:YES];
}

- (IBAction)tw_chooseTitleAction:(UIButton *)sender {
    for (UIView *obj in self.tw_title_view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button setBackgroundColor:UIColor.clearColor];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
            if (button == sender) {
                [button setTitleColor:UIColorFromRGB(0x3968FF) forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
                [button setBackgroundColor:UIColor.whiteColor];
            }
        }
    }
    
    if (sender.tag == 301) {
        [self.tw_bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (sender.tag == 302) {
        [self.tw_bgScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
    else {
        [self.tw_bgScrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:YES];
    }
}

- (void)tw_getUserInfo {
    
    [HttpClient postUrl:@"/app/user/getCurrentInfo" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
           
        NSDictionary *data = [json objectForKey:@"data"];
        self.tw_jf_label.text = [NSString stringWithFormat:@"%d",[[data objectForKey:@"imgNum"] intValue]];
        GlobalVC.points_total = [[data objectForKey:@"imgNum"] intValue];
        
    } failure:^(NSError * _Nonnull error) {
   
    }];
}


@end
