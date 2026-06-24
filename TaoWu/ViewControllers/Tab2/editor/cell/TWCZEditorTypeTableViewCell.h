//
//  TWCZEditorTypeTableViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/20.
//

#import <UIKit/UIKit.h>

@class TWCZEditorTypeTableViewCell;
@protocol TWCZEditorTypeTableViewCellDelegate <NSObject>

- (void)_selectMoreItems:(TWCZEditorTypeTableViewCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TWCZEditorTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cell_pop_button;
@property (weak, nonatomic) IBOutlet UILabel *cell_type_label;
@property (weak, nonatomic) IBOutlet UILabel *cell_name_label;

@property (nonatomic, weak) id<TWCZEditorTypeTableViewCellDelegate> delegate;

- (void)tw_updateCellData:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
