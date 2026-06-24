//
//  UIBarButtonItem+App.h
//  WatchVideo
//
//  Created by JJK on 2023/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (App)
+ (instancetype)app_navigationBackItemAction:(void(^)(id sender))backActionBlock;
@end

NS_ASSUME_NONNULL_END
