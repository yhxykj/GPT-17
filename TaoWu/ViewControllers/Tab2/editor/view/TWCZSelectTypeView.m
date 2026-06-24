//
//  TWCZSelectTypeView.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TWCZSelectTypeView.h"
#import "TWCZSelectTypeTableViewCell.h"

@interface TWCZSelectTypeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger tw_selectIndex;
@property (nonatomic, copy) NSString *select_typeStr;
@property (nonatomic, copy) NSString *select_name;

@end

@implementation TWCZSelectTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWCZSelectTypeView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    
        [self.tw_tableView setDelegate:self];
        [self.tw_tableView setDataSource:self];
        [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWCZSelectTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWCZSelectTypeTableViewCellID"];
        
        
    }
    return self;
}

- (IBAction)tw_tapHiddenAction:(id)sender {
    [self tw_hiddenSelectTypeView];
    
}

- (IBAction)tw_dissmissAction:(id)sender {
    [self tw_hiddenSelectTypeView];
    
}

- (void)setTw_type:(NSString *)tw_type {
//    if (_tw_type.length > 0) {
//        return;
//    }
    _tw_type = tw_type;
    if ([tw_type isEqualToString:@"助理类别"]) {
        [self tw_getZhuLiTitles];
        self.tw_title_label.text = @"助理类别";
    }
    else {
        self.tw_title_label.text = tw_type;
        
    }
}

- (void)setTw_listArray:(NSArray *)tw_listArray {
    self.tw_selectIndex = 110;
    self.select_name = @"";
    self.select_typeStr = @"";
    _tw_listArray = tw_listArray;
    [self.tw_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tw_listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    TWCZSelectTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWCZSelectTypeTableViewCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.select_type == SelectChuangZuoType) {
        NSString *name_string = self.tw_listArray[indexPath.row];
        cell.tw_name_label.text = name_string;
    }
    
    else {
        NSDictionary *obj = self.tw_listArray[indexPath.row];
        cell.tw_name_label.text = [obj objectForKey:@"dictLabel"];
    }
    
    [cell.tw_image setImage:SetImage(@"cz_normal")];
    if (self.tw_selectIndex == indexPath.row) {
        [cell.tw_image setImage:SetImage(@"cz_select")];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tw_selectIndex = indexPath.row;
    [self.tw_tableView reloadData];
    
    if (self.select_type == SelectZhuLiType) {
        NSDictionary *obj = self.tw_listArray[self.tw_selectIndex];
        if (self.selectTypeBlock) {
            self.selectTypeBlock([obj objectForKey:@"dictLabel"], [obj objectForKey:@"dictValue"]);
        }
        
        self.select_name = [obj objectForKey:@"dictLabel"];
        self.select_typeStr = [obj objectForKey:@"dictValue"];
        
    }
    else {
        NSString *name_string = self.tw_listArray[indexPath.row];
        self.select_name = self.tw_listArray[indexPath.row];
        self.select_typeStr = self.tw_title_label.text;
//        if (self.selectTypeBlock) {
//            self.selectTypeBlock(name_string, self.tw_title_label.text);
//        }
    }
    
}

- (IBAction)_sureButtonAction:(id)sender {
    if (self.selectTypeBlock) {
        self.selectTypeBlock(self.select_name, self.select_typeStr);
    }
    [self tw_hiddenSelectTypeView];
}

- (void)tw_showSelectTypeView {
    WS(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
           weakSelf.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

- (void)tw_hiddenSelectTypeView {
    WS(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
           weakSelf.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

// 获取助理类型
- (void)tw_getZhuLiTitles {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"aiType"];
    
    WS(weakSelf)
    [HttpClient postUrl:@"/ai/findAiTypeList" param:param success:^(id  _Nonnull json) {
          
        weakSelf.tw_listArray = [json objectForKey:@"data"];
        
        [weakSelf.tw_tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

@end
