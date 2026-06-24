//
//  TabThirdCollectionViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabThirdCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tw_cell_image;
@property (weak, nonatomic) IBOutlet UILabel *cell_name_label;
@property (weak, nonatomic) IBOutlet UILabel *cell_desc_label;

- (void)cell_updateCellData:(NSDictionary *)obj;

@end

NS_ASSUME_NONNULL_END
