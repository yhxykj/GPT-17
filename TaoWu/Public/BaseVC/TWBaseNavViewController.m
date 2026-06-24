//
//  TWBaseNavViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWBaseNavViewController.h"
#import "UIBarButtonItem+App.h"

@interface TWBaseNavViewController ()

@end

@implementation TWBaseNavViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.className containsString:@"Content"]) {
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:UIStackView.class]) {
                    UIStackView *stackView = (UIStackView *)obj;
                    stackView.spacing = 0;
                    stackView.distribution = UIStackViewDistributionFillProportionally;
                }
            }];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [GlobalVC setBase_nav:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TWGlobalVC.shared.base_nav = self;
    //1.当前栈顶控制器
    UIViewController *topViewController = self.topViewController;
    //2.隐藏tabBar
    if (topViewController.tabBarController || [topViewController isKindOfClass:[UITabBarController class]]) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    //3.设置返回item
    if (self.viewControllers.count) {
        @weakify(self)
        UINavigationItem *navigationItem = viewController.navigationItem;
        id custom_navigationItem = objc_getAssociatedObject(viewController, @selector(lv_customNavigationItem));
        if (custom_navigationItem) {
            navigationItem = custom_navigationItem;
        }
        navigationItem.leftBarButtonItem = [UIBarButtonItem app_navigationBackItemAction:^(id  _Nonnull sender) {
            @strongify(self)
            [self popViewControllerAnimated:YES];
        }];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}



@end
