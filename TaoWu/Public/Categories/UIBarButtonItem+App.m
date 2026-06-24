//
//  UIBarButtonItem+App.m
//  WatchVideo
//
//  Created by JJK on 2023/11/1.
//

#import "UIBarButtonItem+App.h"

@implementation UIBarButtonItem (App)
+ (instancetype)app_navigationBackItemAction:(void(^)(id sender))backActionBlock {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [button setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 28)];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (backActionBlock) {
                backActionBlock(sender);
            }
        }];
        [button setBackgroundColor:UIColor.clearColor];
        [button sizeToFit];
        button;
    })];
    return item;
}

@end
