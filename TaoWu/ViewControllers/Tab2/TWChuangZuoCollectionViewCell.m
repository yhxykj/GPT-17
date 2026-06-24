//
//  TWChuangZuoCollectionViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/13.
//

#import "TWChuangZuoCollectionViewCell.h"

@implementation TWChuangZuoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)cell_updateCellData:(NSDictionary *)obj {
    
    self.tw_name_label.text = [obj objectForKey:@"aiName"];
    self.tw_desc_label.text = [obj objectForKey:@"aiBrief"];
    [self.tw_icon_image sd_setImageWithURL:LoadingImageUrl([obj objectForKey:@"headUrl"])];
}

@end
