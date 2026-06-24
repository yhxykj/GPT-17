//
//  TWYdPageCollectionViewCell.h
//  TaoWu
//
//  Created by JJK on 2024/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWYdPageCollectionViewCellDelegate <NSObject>

- (void)tw_cellIndexpath_item:(NSInteger)item;

@end

@interface TWYdPageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tw_bg_image;
@property (weak, nonatomic) IBOutlet UIButton *tw_next_button;

@property (nonatomic, assign) id<TWYdPageCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
