//
//  TWVipCardView.m
//  TaoWu
//
//  Created by JJK on 2023/12/12.
//

#import "TWVipCardView.h"

@implementation TWVipCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWVipCardView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        self.alpha = 0.0;
    }
    return self;
}

- (IBAction)tw_enterVipAction:(id)sender {
    [self tw_dissmissVipCardView];
    
    [GlobalVC.base_nav pushViewController:TWVipViewController.new animated:YES];
}

- (IBAction)tw_closeButtonAction:(id)sender {
    [self tw_dissmissVipCardView];
    
}

- (void)tw_showVipCardView {
    
    if (GlobalVC.isMode) {
        [self.tw_normal_view setHidden:YES];
        [self.tw_gaoji_view setHidden:NO];
    }else {
        [self.tw_normal_view setHidden:NO];
        [self.tw_gaoji_view setHidden:YES];
    }
    
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0;
    }];
}

- (void)tw_dissmissVipCardView {
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0.0;
    }];
}

@end
