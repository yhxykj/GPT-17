//
//  TWChooseModeView.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWChooseModeView.h"

@implementation TWChooseModeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWChooseModeView" owner:self options:nil] objectAtIndex:0];
        self.frame=frame;
        
        if (GlobalVC.isMode) {
            self.tw_jichu_image.image = [UIImage imageNamed:@"dh_normal"];
            self.tw_gaoji_image.image = [UIImage imageNamed:@"dh_select"];
        }
        
    }
    return self;
}

- (IBAction)tw_closeAction:(id)sender {
    [self tw_hiddenView];
}

- (IBAction)tw_chooseModeAction:(UIButton *)sender {
    if (sender.tag == 301) {
        self.tw_jichu_image.image = [UIImage imageNamed:@"dh_select"];
        self.tw_gaoji_image.image = [UIImage imageNamed:@"dh_normal"];
        GlobalVC.isMode = NO;
    }
    else {
        self.tw_jichu_image.image = [UIImage imageNamed:@"dh_normal"];
        self.tw_gaoji_image.image = [UIImage imageNamed:@"dh_select"];
        GlobalVC.isMode = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatesTheStatusOfTheSelectedMode" object:nil];
}

- (void)tw_showView {
    WS(weakSelf)
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

- (void)tw_hiddenView {
    WS(weakSelf)
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

@end
