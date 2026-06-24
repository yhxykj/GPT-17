//
//  TabThirdCollectionViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TabThirdCollectionViewCell.h"

@implementation TabThirdCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
}

- (void)cell_updateCellData:(NSDictionary *)obj {
    self.cell_name_label.text = [obj objectForKey:@"aiName"];
    self.cell_desc_label.text = [obj objectForKey:@"aiBrief"];
    [self.tw_cell_image sd_setImageWithURL:LoadingImageUrl([obj objectForKey:@"headUrl"])];
}

@end
