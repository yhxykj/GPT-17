//
//  TWCZSelectTypeView.h
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SelectChuangZuoType,
    SelectZhuLiType,
} SelectType;

@interface TWCZSelectTypeView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tw_tableView;
@property (weak, nonatomic) IBOutlet UILabel *tw_title_label;

@property (nonatomic, assign) SelectType select_type;

@property (nonatomic, strong) NSArray *tw_listArray;

@property (nonatomic, strong) void(^selectTypeBlock)(NSString *select_type, NSString *dictValue);

@property (nonatomic, copy) NSString *tw_type;

@property (nonatomic, copy) NSString *tw_cz_ID;

- (void)tw_showSelectTypeView;

- (void)tw_hiddenSelectTypeView;

@end

NS_ASSUME_NONNULL_END
