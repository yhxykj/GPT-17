//
//  TWPonitsView.m
//  TaoWu
//
//  Created by JJK on 2023/12/27.
//

#import "TWPonitsView.h"

@implementation TWPonitsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWPonitsView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

-(IBAction)_dismissAction:(id)sender {
    [self _hiddenImageView];
}

- (IBAction)_lijiOpenAction:(id)sender {
    
    [self _hiddenImageView];
    [GlobalVC twAction_enterVIPViewController];
    
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
