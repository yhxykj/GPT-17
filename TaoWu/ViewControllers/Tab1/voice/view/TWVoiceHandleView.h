//
//  TWVoiceHandleView.h
//  TaoWu
//
//  Created by JJK on 2023/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWVoiceHandleView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tw_handle_image1;
@property (weak, nonatomic) IBOutlet UIImageView *tw_handle_image2;
@property (weak, nonatomic) IBOutlet UIImageView *tw_handle_image3;
@property (weak, nonatomic) IBOutlet UIImageView *tw_handle_image4;
@property (weak, nonatomic) IBOutlet UIImageView *tw_gifImg;

- (instancetype)initWithFrame:(CGRect)frame;

//- (void)tw_createHandleTimer;
//
//- (void)tw_stopAnimation;

@end

NS_ASSUME_NONNULL_END
