//
//  TWVoiceHandleView.m
//  TaoWu
//
//  Created by JJK on 2023/12/8.
//

#import "TWVoiceHandleView.h"

@interface TWVoiceHandleView ()
@property (nonatomic, assign) BOOL tw_status;
@property (nonatomic, strong) NSTimer *tw_timer;
@end

@implementation TWVoiceHandleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWVoiceHandleView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        
        self.tw_gifImg.image = [GlobalVC tw_loadingGifImage];
    }
    return self;
}
//
//- (void)tw_createHandleTimer {
//    self.tw_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(tw_startAnimation) userInfo:nil repeats:YES];
//}
//
//- (void)tw_startAnimation {
//    WS(weakSelf)
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        // 在动画块中进行颜色的交换
//        if (weakSelf.tw_status) {
//            weakSelf.tw_status = NO;
//            [weakSelf.tw_handle_image1 setImage:SetImage(@"dh_handle_round_green")];
//            [weakSelf.tw_handle_image2 setImage:SetImage(@"dh_handle_round_white")];
//            [weakSelf.tw_handle_image3 setImage:SetImage(@"dh_handle_round_green")];
//            [weakSelf.tw_handle_image4 setImage:SetImage(@"dh_handle_round_white")];
//        }
//        else {
//            [weakSelf.tw_handle_image4 setImage:SetImage(@"dh_handle_round_green")];
//            [weakSelf.tw_handle_image3 setImage:SetImage(@"dh_handle_round_white")];
//            [weakSelf.tw_handle_image2 setImage:SetImage(@"dh_handle_round_green")];
//            [weakSelf.tw_handle_image1 setImage:SetImage(@"dh_handle_round_white")];
//            weakSelf.tw_status = YES;
//        }
//        } completion:^(BOOL finished) {
//           
//        }];
//}
//
//- (void)tw_stopAnimation {
//    [self.tw_timer invalidate];
//    self.tw_timer = nil;
//}

@end
