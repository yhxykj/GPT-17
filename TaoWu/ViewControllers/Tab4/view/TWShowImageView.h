//
//  TWShowImageView.h
//  TaoWu
//
//  Created by JJK on 2023/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWShowImageView : UIView

- (void)_showImageView;

- (void)_hiddenImageView;

@property (weak, nonatomic) IBOutlet UIImageView *tw_bigImage;

@end

NS_ASSUME_NONNULL_END
