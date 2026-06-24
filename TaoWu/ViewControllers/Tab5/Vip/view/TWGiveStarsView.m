//
//  TWGiveStarsView.m
//  TaoWu
//
//  Created by JJK on 2023/12/27.
//

#import "TWGiveStarsView.h"

@implementation TWGiveStarsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self =[[[NSBundle mainBundle] loadNibNamed:@"TWGiveStarsView" owner:self options:nil] objectAtIndex:0];
        self.frame=frame;
        self.alpha = 0.0;
    }
    return self;
}

- (IBAction)tw_giveFiveStartCommentAction:(UIButton *)sender {
    
    [self tw_vanishTheStarView];
    
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }
    
}

- (IBAction)LetMeThinkAgainAction:(id)sender {
    
    [self tw_vanishTheStarView];
    
}

/// 快速去评价
- (IBAction)_rapidDeevaluationAction:(id)sender {
    
    [self tw_vanishTheStarView];

    NSURL *storeString = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", APPID]];
    
    if ([[UIApplication sharedApplication] canOpenURL:storeString]) {
        [[UIApplication sharedApplication] openURL:storeString options:@{} completionHandler:nil];
    }
}


- (void)tw_openTheStarView {
    self.transform = CGAffineTransformMakeScale(0.010, 0.010);
    self.alpha = 0.0;
    [UIView animateWithDuration:0.31 animations:^{
        self.transform = CGAffineTransformMakeScale(1.00, 1.00);
        self.alpha = 1.00;
    }];
}

- (void)tw_vanishTheStarView {
    self.transform = CGAffineTransformMakeScale(1.00, 1.00);
    self.alpha = 1.00;
    [UIView animateWithDuration:0.31 animations:^{
        self.transform = CGAffineTransformMakeScale(0.010, 0.010);
        self.alpha = 0.00;
    }];
}

@end
