//
//  TWVipPointsCollectionViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWVipPointsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tw_cell_image;
@property (weak, nonatomic) IBOutlet UILabel *tw_points_label;
@property (weak, nonatomic) IBOutlet UILabel *tw_price_label;
@property (weak, nonatomic) IBOutlet UILabel *tw_Yprice_label;

- (void)cell_updateCellData:(NSDictionary *)obj;

@end

NS_ASSUME_NONNULL_END
