//
//  TWVipCollectionViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import "TWVipCollectionViewCell.h"

@implementation TWVipCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)cell_updateCellData:(NSDictionary *)obj {
    [self.tw_time_label setText:[obj objectForKey:@"descript"]];
    [self.tw_price_label setText:[obj objectForKey:@"amountDescript"]];
    [self.tw_Yprice_label setText:[obj objectForKey:@"descript"]];
    [self.tw_sjf_label setText:[NSString stringWithFormat:@"送%@积分",[obj objectForKey:@"valueDescript"]]];
    
    [self.tw_price_label sizeToFit];
    
    if ([[obj objectForKey:@"remark"] isEqualToString:@"1"]) {//月
        [self.tw_time_label setText:@"月度会员"];
    }
    else if ([[obj objectForKey:@"remark"] isEqualToString:@"5"]) {//周
        [self.tw_time_label setText:@"周度会员"];
    }
    else if ([[obj objectForKey:@"remark"] isEqualToString:@"4"]) {//年f
        [self.tw_time_label setText:@"年度会员"];
    }
    else if ([[obj objectForKey:@"remark"] isEqualToString:@"6"]) {//永久
        [self.tw_time_label setText:@"终身会员"];
    }
    
    
    if ([self.tw_price_label.text containsString:@"￥"] || [self.tw_price_label.text containsString:@"$"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.tw_price_label.text];
        UIFont *firstCharacterFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [attributedString addAttribute:NSFontAttributeName value:firstCharacterFont range:NSMakeRange(0, 1)];
        self.tw_price_label.attributedText = attributedString;
    }

    
}

@end
