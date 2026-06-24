//
//  TWVipPointsCollectionViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import "TWVipPointsCollectionViewCell.h"

@implementation TWVipPointsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)cell_updateCellData:(NSDictionary *)obj {
    
    [self.tw_points_label setText:[obj objectForKey:@"descript"]];
    [self.tw_price_label setText:[obj objectForKey:@"valueDescript"]];
    
    if ([self.tw_price_label.text containsString:@"¥"] || [self.tw_price_label.text containsString:@"$"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.tw_price_label.text];
        UIFont *firstCharacterFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [attributedString addAttribute:NSFontAttributeName value:firstCharacterFont range:NSMakeRange(0, 1)];
        self.tw_price_label.attributedText = attributedString;
    }
    
}

@end
