//
//  TWYdPageCollectionViewCell.m
//  TaoWu
//
//  Created by JJK on 2024/1/14.
//

#import "TWYdPageCollectionViewCell.h"

@implementation TWYdPageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)tw_nextButtonAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tw_cellIndexpath_item:)]) {
        [self.delegate tw_cellIndexpath_item:sender.tag];
    }
    
}

@end
