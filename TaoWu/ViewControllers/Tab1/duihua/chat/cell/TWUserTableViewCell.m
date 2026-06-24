//
//  TWUserTableViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import "TWUserTableViewCell.h"

@implementation TWUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tw_setCellData:(NSDictionary *)cell_dic {
    
    [self.tw_content_label setText:[cell_dic objectForKey:@"message"]];
    
}

@end
