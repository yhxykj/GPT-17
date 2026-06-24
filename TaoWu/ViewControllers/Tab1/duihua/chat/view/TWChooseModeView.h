//
//  TWChooseModeView.h
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWChooseModeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tw_jichu_image;
@property (weak, nonatomic) IBOutlet UIImageView *tw_gaoji_image;

- (void)tw_showView;

- (void)tw_hiddenView;

@end

NS_ASSUME_NONNULL_END
