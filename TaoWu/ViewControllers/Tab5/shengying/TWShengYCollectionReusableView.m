//
//  TWShengYCollectionReusableView.m
//  TaoWu
//
//  Created by JJK on 2023/12/7.
//

#import "TWShengYCollectionReusableView.h"

@implementation TWShengYCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tw_reusableTitleLabel = [[UILabel alloc] init];
        self.tw_reusableTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.tw_reusableTitleLabel.textColor = UIColorFromRGB(0x333333);
        [self addSubview:self.tw_reusableTitleLabel];
        self.tw_reusableTitleLabel.alpha = 0.66;
        
        self.tw_reusableTitleLabel.sd_layout.leftSpaceToView(self, 23).centerYEqualToView(self).widthIs(100).heightIs(20);
    }
    return self;
}

@end
