//
//  TWCZEditorTableViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWCZEditorTableViewCellDelegate <NSObject>

/**
 选中内容
 @param cell_name 那一个模块
 @param cell_content 选中的内容
 */
- (void)cell_tWCZEditorTableViewCell:(NSString *)cell_name
                      cellForContent:(NSString *)cell_content;

@end

@interface TWCZEditorTableViewCell : UITableViewCell

- (void)tw_updateCellData:(NSDictionary *)param;

@property (nonatomic, weak) id<TWCZEditorTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
