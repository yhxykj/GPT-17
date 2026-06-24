//
//  TWVoiceViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWVoiceViewController.h"
#import "TWNewVoiceViewController.h"
#import "TWShengYViewController.h"

#import "TWUserTableViewCell.h"

@interface TWVoiceViewController ()<UITableViewDelegate,UITableViewDataSource,TWHuiDaTableViewCellDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    NSMutableArray *voices_array;
}

@end

@implementation TWVoiceViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TWSpeechSynthesisManager.sharedManager tw_stopPlayerVoice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TWUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWUserTableViewCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"TWHuiDaTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWHuiDaTableViewCellID"];
    
    [self _reloadVoicesData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _reloadVoicesData];
}

- (void)_reloadVoicesData {
    voices_array = [NSMutableArray array];
    NSArray *array = [SAVE_UDF objectForKey:@"voice"];
    if (array.count > 0) {
        [voices_array addObjectsFromArray:array];
    }
    
    [_tableView reloadData];
    
    [self tw_slideTotheBottomOfThePage];
}

- (IBAction)tw_exchangeVoiceAction:(UIButton *)sender {
    TWShengYViewController *syVC = [[TWShengYViewController alloc] init];
    [self.navigationController pushViewController:syVC animated:YES];
}

- (IBAction)tw_startVoiceAction:(id)sender {
    TWNewVoiceViewController *vc = [[TWNewVoiceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return voices_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *param = voices_array[indexPath.row];
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

- (void)tw_slideTotheBottomOfThePage {
    NSInteger cellCount = [_tableView numberOfRowsInSection:0];
    if (cellCount > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - TWHuiDaTableViewCellDelegate -
- (void)tw_deleteTWDaAnTableViewCell:(TWHuiDaTableViewCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [voices_array removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
    [SAVE_UDF setValue:voices_array forKey:@"voice"];
}


@end
