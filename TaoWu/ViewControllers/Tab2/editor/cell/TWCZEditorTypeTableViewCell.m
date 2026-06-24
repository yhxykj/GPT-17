//
//  TWCZEditorTypeTableViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/20.
//

#import "TWCZEditorTypeTableViewCell.h"

@implementation TWCZEditorTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)tw_updateCellData:(NSDictionary *)param {
    [self.cell_name_label setText:[param objectForKey:@"name"]];
}

- (IBAction)tw_selectMoreClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(_selectMoreItems:)]) {
        [self.delegate _selectMoreItems:self];
    }
}
@end
