//
//  TWShowAllStypeView.h
//  TaoWu
//
//  Created by JJK on 2023/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWShowAllStypeView : UIView

- (void)_showAllStypeView;

@property (nonatomic, strong) void(^addStypeSuccessBlock) (NSString *style);

@end

NS_ASSUME_NONNULL_END
