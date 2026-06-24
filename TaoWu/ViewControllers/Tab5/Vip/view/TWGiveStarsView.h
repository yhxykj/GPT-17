//
//  TWGiveStarsView.h
//  TaoWu
//
//  Created by JJK on 2023/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWGiveStarsView : UIView

@property (weak, nonatomic) IBOutlet UIView *tw_starCard_view;
@property (weak, nonatomic) IBOutlet UIView *tw_alert_view;

- (void)tw_openTheStarView;

@end

NS_ASSUME_NONNULL_END
