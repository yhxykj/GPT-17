//
//  TWChuangZuoCollectionViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWChuangZuoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tw_name_label;
@property (weak, nonatomic) IBOutlet UILabel *tw_desc_label;
@property (weak, nonatomic) IBOutlet UIImageView *tw_icon_image;

- (void)cell_updateCellData:(NSDictionary *)obj;

@end

NS_ASSUME_NONNULL_END
