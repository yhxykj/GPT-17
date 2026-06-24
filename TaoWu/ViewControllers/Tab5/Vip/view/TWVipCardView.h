//
//  TWVipCardView.h
//  TaoWu
//
//  Created by JJK on 2023/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWVipCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)tw_showVipCardView;

@property (weak, nonatomic) IBOutlet UIView *tw_gaoji_view;
@property (weak, nonatomic) IBOutlet UIView *tw_normal_view;

@end

NS_ASSUME_NONNULL_END
