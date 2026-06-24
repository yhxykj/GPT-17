//
//  TWDaAnTableViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class TWDaAnTableViewCell;
//@protocol TWDaAnTableViewCellDelegate <NSObject>
//
//- (void)tw_deleteTWDaAnTableViewCell:(TWDaAnTableViewCell *)cell;
//
//@end

@interface TWDaAnTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *tw_content_label;
//@property (weak, nonatomic) IBOutlet UIButton *tw_sy_button;
//
//@property (nonatomic, weak) id<TWDaAnTableViewCellDelegate> delegate;
//
//- (void)tw_setCellData:(NSDictionary *)cell_dic;

@property (nonatomic, strong) void(^sendDefaultQuestionBlock) (NSString *content);

@end

NS_ASSUME_NONNULL_END
