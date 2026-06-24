//
//  TWMainHeaderView.h
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWMainHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) void(^sendDefaultQuestionBlock) (NSString *content);

@end

NS_ASSUME_NONNULL_END
