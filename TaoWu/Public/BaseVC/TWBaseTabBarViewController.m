//
//  TWBaseTabBarViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWBaseTabBarViewController.h"
#import "TabOneViewController.h"
#import "TabTwoViewController.h"
#import "TabThirdViewController.h"
#import "TabFourViewController.h"
#import "TabFiveViewController.h"


@implementation UIViewController(AppTabBar)

- (void)tabBar_setItemTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self.tabBarItem.title = title;
    self.tabBarItem.image = image;
    self.tabBarItem.selectedImage = selectedImage;
    
    NSDictionary *selectedAttributes = @{
        NSForegroundColorAttributeName:UIColorFromRGB(0x34332E)
    };
    [self.tabBarItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
}

- (void)setupAllChildViewControllers:(UIViewController *)childVC
                           withTitle:(NSString *)title
                 withNormalImageName:(NSString *)normal
                 withSelectImageName:(NSString *)select {
    
    [self tabBar_setItemTitle:title
                        image:[[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                selectedImage:[[UIImage imageNamed:select] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end


@interface TWBaseTabBarViewController ()

@end

@implementation TWBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self setupAllChildViewControllers];
}

- (void)setupAllChildViewControllers {
    
    UINavigationController *nav1 = [TWBaseNavViewController.alloc initWithRootViewController:TabOneViewController.new];
    [nav1 setupAllChildViewControllers:nav1 withTitle:@"对话" withNormalImageName:@"tab_dh" withSelectImageName:@"tab_dh_s"];
   
    UINavigationController *nav2 = [TWBaseNavViewController.alloc initWithRootViewController:TabTwoViewController.new];
    [nav2 setupAllChildViewControllers:nav2 withTitle:@"创作" withNormalImageName:@"tab_cz" withSelectImageName:@"tab_cz_s"];
    
    UINavigationController *nav3 = [TWBaseNavViewController.alloc initWithRootViewController:TabThirdViewController.new];
    [nav3 setupAllChildViewControllers:nav3 withTitle:@"助理" withNormalImageName:@"tab_zl" withSelectImageName:@"tab_zl_s"];
    
    UINavigationController *nav4 = [TWBaseNavViewController.alloc initWithRootViewController:TabFourViewController.new];
    [nav4 setupAllChildViewControllers:nav4 withTitle:@"绘画" withNormalImageName:@"tab_hh" withSelectImageName:@"tab_hh_s"];
    
    UINavigationController *nav5 = [TWBaseNavViewController.alloc initWithRootViewController:TabFiveViewController.new];
    [nav5 setupAllChildViewControllers:nav5 withTitle:@"我的" withNormalImageName:@"tab_wd" withSelectImageName:@"tab_wd_s"];
    
    [self setViewControllers:@[nav1,nav2,nav3,nav4,nav5] animated:NO];
    
}


@end
