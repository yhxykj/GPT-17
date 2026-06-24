//
//  TWShowImageView.m
//  TaoWu
//
//  Created by JJK on 2023/12/25.
//

#import "TWShowImageView.h"

@implementation TWShowImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWShowImageView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (IBAction)_dismissAction:(id)sender {
    [self _hiddenImageView];
}

- (void)_showImageView {
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0;
    }];
}

- (void)_hiddenImageView {
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0.0;
    }];
}

@end
