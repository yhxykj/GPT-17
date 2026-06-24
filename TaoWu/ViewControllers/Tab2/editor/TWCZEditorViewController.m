//
//  TWCZEditorViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/13.
//

#import "TWCZEditorViewController.h"
#import "TWCZResultViewController.h"
#import "TWCZEditorCollectionViewCell.h"
#import "TWCZSelectTypeView.h"

#import "TWCZEditorTableViewCell.h"
#import "TWCZEditorTextTableViewCell.h"
#import "TWCZEditorTypeTableViewCell.h"

@interface TWCZEditorViewController () <UITableViewDelegate,UITableViewDataSource,TWCZEditorTableViewCellDelegate,TWCZEditorTextTableViewCellDelegate,TWCZEditorTypeTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tw_tableView;
@property (weak, nonatomic) IBOutlet UIView *tw_number_view;
@property (weak, nonatomic) IBOutlet UILabel *tw_number_label;

@property (nonatomic, strong) TWCZSelectTypeView *tw_selectTypeView;

@property (nonatomic, strong) TWVipCardView *cardView;
@property (nonatomic, strong) TWGiveStarsView *tw_starView;

@property (nonatomic, strong) NSArray *content_array;
@property (nonatomic, strong) NSArray *text_array;

@property (nonatomic, assign) NSInteger tw_selectIndex;

@property (nonatomic, strong) NSArray *tw_listArray;

@property (nonatomic, copy) NSString *type_string;

@property (nonatomic, assign) CGFloat text_height; // 修改文本时，刷新cell高度

@property (nonatomic, assign) BOOL isNumber; // 是否包含字数

@property (nonatomic, strong) NSMutableDictionary *param;

@end

@implementation TWCZEditorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tw_number_label.text = [NSString stringWithFormat:@"新用户免费次数：%ld",GlobalVC.numberTimes];
    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1) {
        self.tw_number_view.hidden = YES;
    }
    
    [self.tw_big_sumView setFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    
    [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWCZEditorTableViewCell" bundle:nil] forCellReuseIdentifier:@"content"];
    [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWCZEditorTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"text"];
    [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWCZEditorTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"type"];
    

    self.tw_selectTypeView = [[TWCZSelectTypeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    self.tw_selectTypeView.select_type = SelectChuangZuoType;
    [self.view addSubview:self.tw_selectTypeView];
    
    self.cardView = [[TWVipCardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.cardView];
    self.cardView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    self.tw_starView = [[TWGiveStarsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_starView];
    self.tw_starView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    self.text_height = 120;
    [self tw_getChuangzuoContent];
    
    self.param = NSMutableDictionary.dictionary;
}

- (IBAction)tw_chooseTextNumberAction:(UIButton *)sender {
    for (UIView *obj in self.tw_sumView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)obj;
            [button setTitleColor:UIColorFromRGB(0x9A9A9A) forState:UIControlStateNormal];
            [button setBackgroundImage:SetImage(@"cz_white_n") forState:UIControlStateNormal];
            if (button == sender) {
                [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                [button setBackgroundImage:SetImage(@"cz_green_s") forState:UIControlStateNormal];
            }
        }
    }
}




- (IBAction)tw_sureButtonAction:(id)sender {
    
    
    if (self.param.allValues.count != self.tw_listArray.count) {
        [SVProgressHUD showErrorWithStatus:@"内容填写不完整！"];
        return;
    }
    
    for (NSString *value in self.param.allValues) {
        
        if (value.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"内容填写不完整！"];
            return;
        }
    }
    
    
    if ([GlobalVC tw_whetherCanUsedFree] == NO) {
        
        [self.cardView tw_showVipCardView];
        return;
        
    }
    
    NSString *str = [GlobalVC tw_dictionaryToJson:self.param];
    
    self.type_string = @"";
    [self.tw_tableView reloadData];
    
    
    TWCZResultViewController *vc = [[TWCZResultViewController alloc] init];
    vc.title = self.navigationItem.title;
    vc.tw_type = self.tw_type_ID;
    vc.tw_question = str;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tw_listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *param = self.tw_listArray[indexPath.row];
    NSString *type = [param objectForKey:@"type"];
    
    if ([type intValue] == 1) {
        TWCZEditorTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell tw_updateCellData:param];
        [cell setDelegate:self];
        cell.tw_textField.tag = indexPath.row + 100;
        return cell;
    }
    else if ([type intValue] == 2) {
        TWCZEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell tw_updateCellData:param];
        [cell setDelegate:self];
        
        return cell;
    }
    else {
        TWCZEditorTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell tw_updateCellData:param];
        [cell setDelegate:self];
        [cell.cell_type_label setText:self.type_string];
        
        return cell;
    }
    
}

- (void)tw_getChuangzuoContent {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.tw_type_ID forKey:@"id"];
    [SVProgressHUD show];
    WS(weakSelf)
    [HttpClient postUrl:@"/ai/findAiCreation" param:param success:^(id  _Nonnull json) {
        
        weakSelf.tw_listArray = [json objectForKey:@"data"];
        
        [weakSelf.tw_tableView reloadData];
        
        [weakSelf.tw_listArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj objectForKey:@"name"] isEqualToString:@"字数"]) {
                [weakSelf.tw_tableView setTableFooterView:nil];
                weakSelf.isNumber = YES;
                
                
            }
        }];
        
        if (weakSelf.isNumber == NO) {
            [weakSelf.tw_tableView setTableFooterView:self.tw_big_sumView];
        }
        
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

#pragma mark - TWCZEditorTableViewCellDelegate -

- (void)cell_tWCZEditorTableViewCell:(NSString *)cell_name cellForContent:(NSString *)cell_content {
    
    NSLog(@"------%@ --------%@",cell_name,cell_content);
    
    [self.param setValue:cell_content forKey:cell_name];
}


#pragma mark - TWCZEditorTextTableViewCellDelegate -
- (void)cell_tWCZEditorTextFieldTableViewCell:(NSString *)cell_name cellForContent:(NSString *)cell_content {
    
    NSLog(@"------%@ --------%@",cell_name,cell_content);
    
    [self.param setValue:cell_content forKey:cell_name];
}


// 更新cell的高度
- (void)cell_tWCZEditorTextFieldTableViewCell:(TWCZEditorTextTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tw_tableView indexPathForCell:cell];
    
    NSLog(@"-----%ld------%@ --------%@",indexPath.row,cell.cell_name_label.text,cell.tw_textField.text);
    
    CGFloat x_height = [GlobalVC tw_textContentHeightForText:cell.tw_textField.text andWidth:kScreenWidth-135];
    
    NSLog(@"=========== %.2f",x_height);
    
    if (x_height > 36) {
        [self.tw_tableView beginUpdates];
        [cell.cell_contentView_height setConstant:x_height + 28];
        [self.tw_tableView endUpdates];
        [cell.tw_textField becomeFirstResponder];
    }else {
        [self.tw_tableView beginUpdates];
        [cell.cell_contentView_height setConstant:60];
        [self.tw_tableView endUpdates];
        [cell.tw_textField becomeFirstResponder];
    }
    
    
    
}

- (void)_selectMoreItems:(TWCZEditorTypeTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tw_tableView indexPathForCell:cell];
    NSIndexPath *screen = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSLog(@"%ld",indexPath.row);
    NSDictionary *param = self.tw_listArray[indexPath.row];
    
    [self.tw_selectTypeView tw_showSelectTypeView];
    [self.tw_selectTypeView setTw_cz_ID:self.tw_type_ID];
    [self.tw_selectTypeView setTw_type:[param objectForKey:@"name"]];
    
    self.tw_selectTypeView.tw_listArray = [param objectForKey:@"content"];
    self.tw_selectTypeView.tw_type = [param objectForKey:@"name"];
    
    WS(weakSelf)
    self.tw_selectTypeView.selectTypeBlock = ^(NSString * _Nonnull select_type, NSString * _Nonnull dictValue) {
        weakSelf.type_string = select_type;
        [weakSelf.param setValue:select_type forKey:dictValue];
        [weakSelf.tw_tableView reloadRowsAtIndexPaths:@[screen] withRowAnimation:UITableViewRowAnimationNone];
    };
    
}

@end
