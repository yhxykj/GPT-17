//
//  TWCZEditorTextTableViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TWCZEditorTextTableViewCell;
@protocol TWCZEditorTextTableViewCellDelegate <NSObject>

/**
 选中内容
 @param cell_name 那一个模块
 @param cell_content 选中的内容
 */
- (void)cell_tWCZEditorTextFieldTableViewCell:(NSString *)cell_name
                      cellForContent:(NSString *)cell_content;

- (void)cell_tWCZEditorTextFieldTableViewCell:(TWCZEditorTextTableViewCell *)cell;

@end

@interface TWCZEditorTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cell_contentView_height;
@property (weak, nonatomic) IBOutlet UILabel *cell_name_label;
@property (weak, nonatomic) IBOutlet UITextView *tw_textField;
@property (weak, nonatomic) IBOutlet UILabel *cell_placeholder_label;

- (void)tw_updateCellData:(NSDictionary *)param;

@property (nonatomic, weak) id<TWCZEditorTextTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
