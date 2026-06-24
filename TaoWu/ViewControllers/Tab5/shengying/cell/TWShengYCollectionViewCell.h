//
//  TWShengYCollectionViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWShengYCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cell_bg_view;
@property (weak, nonatomic) IBOutlet UILabel *cell_name_label;
@property (weak, nonatomic) IBOutlet UIImageView *cell_voice_image;

@end

NS_ASSUME_NONNULL_END
