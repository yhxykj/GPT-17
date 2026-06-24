//
//  TWUserTableViewCell.h
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tw_content_label;

- (void)tw_setCellData:(NSDictionary *)cell_dic;

@end

NS_ASSUME_NONNULL_END
