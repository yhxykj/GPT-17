//
//  TWMainViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWMainViewController.h"
#import "TWDaAnTableViewCell.h"
#import "TWUserTableViewCell.h"
#import "TWMainHeaderView.h"

@interface TWMainViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TWHuiDaTableViewCellDelegate
>

@property (weak, nonatomic) IBOutlet UIView *tw_nav_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tw_nav_topLayout;
@property (weak, nonatomic) IBOutlet UIButton *tw_back_button;
@property (weak, nonatomic) IBOutlet UITableView *tw_tableView;
@property (weak, nonatomic) IBOutlet UIButton *tw_dh_status_button;

@property (nonatomic, strong) TWMainHeaderView *headerView;
@property (nonatomic, strong) TWChooseModeView *modeView;
@property (nonatomic, strong) TWVipCardView *cardView;
@property (nonatomic, strong) TWGiveStarsView *tw_starView;

@property (nonatomic, assign) BOOL firstMsg;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) dispatch_source_t tw_timer;
@property (nonatomic, copy) NSString *socket_message;

@end

@implementation TWMainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self tw_slideTotheBottomOfThePage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TWSpeechSynthesisManager.sharedManager tw_stopPlayerVoice];
    [self.tw_textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadChatRecords) name:@"ReloadChatRecordsNotificationName" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectStatus) name:@"updatesTheStatusOfTheSelectedMode" object:nil];
    
    self.messageArray = [NSMutableArray array];
    [self.tw_dh_status_button setImage:GlobalVC.isMode?SetImage(@"dh_gaoji_s"):SetImage(@"dh_jichu_s") forState:UIControlStateNormal];
    
//    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1) {
//        self.tw_number_view.hidden = YES;
//    }
    
    self.firstMsg = YES;

    [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWUserTableViewCellID"];
    [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWHuiDaTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWHuiDaTableViewCellID"];
    
//    [self.view addSubview:self.tw_inputView];
//    self.tw_inputView.sd_layout.leftSpaceToView(self.view, 0).widthIs(kScreenWidth).bottomSpaceToView(self.view, 10).heightIs(68);
    
    
    self.modeView = [[TWChooseModeView alloc] init];
    [self.view addSubview:self.modeView];
    self.modeView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    self.cardView = [[TWVipCardView alloc] init];
    [self.view addSubview:self.cardView];
    self.cardView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.cardView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    NSArray *dh_array = [SAVE_UDF objectForKey:@"duihua"];
    if (self.isdefault == NO) {
        dh_array = [SAVE_UDF objectForKey:self.type_id];
        
        if (dh_array.count == 0) {
            dh_array = @[@{@"identifier":@"User",@"message":self.tw_describle_string,@"status":@"1"}];
        }
        [self.tw_tableView setTableHeaderView:nil];
        
        [self.tw_nav_view setHidden:NO];
        [self.tw_bgImage setHidden:NO];
    }
    else {
        [self.tw_nav_view setHidden:YES];
        [self.tw_nav_topLayout setConstant:0];
        [self.tw_tableView registerNib:[UINib nibWithNibName:@"TWDaAnTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWDaAnTableViewCellID"];
    }
    
    if (dh_array.count > 0) {
        [self.messageArray addObjectsFromArray:dh_array];
    }

    WS(weakSelf)
    self.headerView.sendDefaultQuestionBlock = ^(NSString * _Nonnull content) {
        weakSelf.tw_textView.text = content;
        weakSelf.tw_label.text = @"";
    };
    
    self.tw_starView = [[TWGiveStarsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_starView];
    self.tw_starView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    if ([[NSUserDefaults.standardUserDefaults objectForKey:@"vipStatus"] intValue] == 1) {
        self.tw_label.text = [NSString stringWithFormat:@"快来与AI对话吧～"];
    }else {
        [self tw_getUserFree];
    }
    
}

- (void)_reloadChatRecords {
    self.messageArray = NSMutableArray.array;
    
    NSArray *dh_array = [SAVE_UDF objectForKey:@"duihua"];
    if (self.isdefault == NO) {
        dh_array = [SAVE_UDF objectForKey:self.type_id];
    }
    if (dh_array.count > 0) {
        [self.messageArray addObjectsFromArray:dh_array];
    }
    [self.tw_tableView reloadData];
}

- (IBAction)tw_backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tw_chooseMode:(id)sender {
    [self.modeView tw_showView];
    
}

- (void)updateSelectStatus {
    if (GlobalVC.isMode) {
        [self.tw_dh_status_button setImage:[UIImage imageNamed:@"dh_gaoji_s"] forState:UIControlStateNormal];
    }
    else {
        [self.tw_dh_status_button setImage:[UIImage imageNamed:@"dh_jichu_s"] forState:UIControlStateNormal];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isdefault == YES) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isdefault == YES) {
        if (section == 0) {
            return 1;
        }
        else {
            return self.messageArray.count;
        }
    }
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isdefault == YES && indexPath.section == 0) {
        WS(weakSelf)
        TWDaAnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWDaAnTableViewCellID" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sendDefaultQuestionBlock = ^(NSString * _Nonnull content) {
            weakSelf.tw_textView.text = content;
            weakSelf.tw_label.text = @"";
        };
        
        return cell;
    }
    
    NSDictionary *param = self.messageArray[indexPath.row];
    if ([param[@"identifier"] isEqualToString:@"User"]) {
        TWUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWUserTableViewCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell tw_setCellData:param];
        
        cell.backgroundColor = UIColor.clearColor;
        return cell;
    }
    
    else {
        TWHuiDaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWHuiDaTableViewCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDelegate:self];
        cell.tw_sy_button.tag = indexPath.row;
        [cell tw_setCellData:param];
        
        return cell;
    }
    
    
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidChange:(UITextView *)textView {
    if ([GlobalVC IsNullString:self.tw_textView.text]) {
        self.tw_label.hidden = NO;
    }
    else {
        self.tw_label.hidden = YES;
    }
    
    CGFloat x_height = [GlobalVC tw_textContentHeightForText:self.tw_textView.text andWidth:kScreenWidth-114];
    
    if (x_height > 100) {
        
    }
    else if (x_height > 30) {
        self.tw_inputView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 10).heightIs(44 + x_height);
        self.inputHeight.constant = 44 + x_height;
        [self tw_slideTotheBottomOfThePage];
        
    }else {
        self.inputHeight.constant = 68;
        self.tw_inputView.sd_layout.leftSpaceToView(self.view, 0).widthIs(kScreenWidth).bottomSpaceToView(self.view, 10).heightIs(68);
    }
}


- (IBAction)tw_fsButtonAction:(id)sender {
    
    [self.tw_textView resignFirstResponder];
    
    if ([GlobalVC IsNullString:self.tw_textView.text]) {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空！"];
        return;
    }
    
    
    if ([GlobalVC tw_whetherCanUsedFree] == NO) {
        
        [self.cardView tw_showVipCardView];
        return;
        
    }
    
    [self.tw_textView resignFirstResponder];

    NSString *identifier = [GlobalVC tw_getCurrentUniqueIdentifier];
    NSString *socket = [NSString stringWithFormat:@"wss://jiaodelong.top/websocket/%@",identifier];

    [self.tw_fs_button setImage:SetImage(@"dh_zt") forState:UIControlStateNormal];


    NSDictionary *dic = @{@"identifier":@"User",@"message":self.tw_textView.text,@"status":@"1"};
    [self.messageArray addObject:dic];
    [self.tw_tableView reloadData];
    self.socket_message = @"";
    
    [self tw_createTimer];
    
    [self tw_slideTotheBottomOfThePage];

    WS(weakSelf)
    [SOCKET tw_open:socket connect:^{

        [weakSelf tw_connentServer:identifier];

        } receive:^(id  _Nonnull message, TWSocketReceiveType type) {

            if ([message isEqualToString:@"DONE"]) {
                
                [self.tw_fs_button setEnabled:true];
                [self.tw_fs_button setImage:SetImage(@"dh_fs") forState:UIControlStateNormal];
                
                [SOCKET tw_close];
                
                if (weakSelf.isdefault) {
                    [SAVE_UDF setValue:self.messageArray forKey:@"duihua"];
                }
                else {
                    [SAVE_UDF setValue:self.messageArray forKey:self.type_id];
                }
                
                NSInteger count = [[SAVE_UDF objectForKey:@"useTimes"] intValue];
                
                if (count == 1) {
                    [UIView animateWithDuration:2.8 animations:^{
                                            
                    } completion:^(BOOL finished) {
                        
                        [weakSelf.tw_starView tw_openTheStarView];
                        
                    }];
                }
                
            }
            
            else {
                [self tw_reloadTableView:message];
            }

        } failure:^(NSError * _Nonnull error) {
            [self.tw_fs_button setEnabled:true];
            [self.tw_fs_button setImage:SetImage(@"dh_fs") forState:UIControlStateNormal];
            [SVProgressHUD showErrorWithStatus:@"连接中断"];

        }];
}


- (void)tw_connentServer:(NSString *)identifier {
    
    if (self.isdefault == YES) {
        self.firstMsg = NO;
    }
    
    [GlobalVC tw_connentServer:identifier withContent:self.tw_textView.text withChatType:self.isdefault?@"1":self.type_id withLastType:self.firstMsg];
    self.firstMsg = NO;
    
    self.tw_textView.text = nil;
    
    if (self.tw_timer) {
        dispatch_source_cancel(self.tw_timer);
        self.tw_timer = nil;
        NSLog(@"倒计时结束");
    }
}

- (void)tw_reloadTableView:(NSString *)msg {
    
    self.socket_message = [NSString stringWithFormat:@"%@%@",self.socket_message,msg];

    NSDictionary *dic = @{@"identifier":@"Robot",@"message":self.socket_message,@"status":@"1"};

    if ([self.socket_message isEqualToString:msg] && msg.length > 0) {
        [self.messageArray addObject:dic];
    }else if ([self.socket_message isEqualToString:msg] && msg.length == 0) {
        return;
    }
    [self.messageArray replaceObjectAtIndex:self.messageArray.count-1 withObject:dic];

    [self.tw_tableView reloadData];
    
    [self tw_slideTotheBottomOfThePage];
}

- (void)tw_createTimer {
    
    WS(weakSelf)
    __block NSInteger countdown = 15;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.tw_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.tw_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.tw_timer, ^{
        countdown--;
        if (countdown >= 0) {
            NSLog(@"倒计时：%ld", (long)countdown);
        } else {
            [weakSelf tw_countDownAndEnd];
        }
    });
    dispatch_resume(self.tw_timer);
    
    [self.tw_fs_button setEnabled:false];
}

- (void)tw_countDownAndEnd {
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.tw_fs_button setEnabled:true];
        [self.tw_fs_button setImage:SetImage(@"dh_fs") forState:UIControlStateNormal];
    });

    if (self.tw_timer) {
        dispatch_source_cancel(self.tw_timer);
        self.tw_timer = nil;
        NSLog(@"倒计时结束");
    }
    
    [SOCKET tw_close];
}

- (void)tw_slideTotheBottomOfThePage {
    NSInteger cellCount;
    
    if (self.isdefault == YES) {
        cellCount = [self.tw_tableView numberOfRowsInSection:1];
        if (cellCount > 0) {
            [self.tw_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCount - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    else {
        cellCount = [self.tw_tableView numberOfRowsInSection:0];
        if (cellCount > 0) {
            [self.tw_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    
}

#pragma mark - TWHuiDaTableViewCellDelegate -
- (void)tw_deleteTWDaAnTableViewCell:(TWHuiDaTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tw_tableView indexPathForCell:cell];
    [self.messageArray removeObjectAtIndex:indexPath.row];
    [self.tw_tableView reloadData];
    [SAVE_UDF setValue:self.messageArray forKey:@"duihua"];
}

- (void)tw_getUserFree{
    
    [HttpClient postUrl:@"/app/getSum" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSInteger number = [[json objectForKey:@"data"] intValue];
            self.tw_label.text = [NSString stringWithFormat:@"新用户可享受 %ld 次免费试用机会",number];
        }
        else {
            self.tw_label.text = [NSString stringWithFormat:@"快来与AI对话吧～"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
