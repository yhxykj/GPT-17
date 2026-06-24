//
//  TWSelectAvatarViewController.h
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWSelectAvatarViewController : UIViewController

@property (nonatomic, strong) void(^selectAvatarBlock)(NSString *avatar);

@end

NS_ASSUME_NONNULL_END
