//
//  TWCustomStyleCollectionViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWCustomStyleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tw_icon_image;
@property (weak, nonatomic) IBOutlet UILabel *tw_name_label;

@end

NS_ASSUME_NONNULL_END
