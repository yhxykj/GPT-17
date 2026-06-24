//
//  TabTwoViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TabTwoViewController.h"
#import "TWCZEditorViewController.h"
#import "TWChuangZuoCollectionViewCell.h"

@interface TabTwoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UIButton *tw_dh_status_button;
    __weak IBOutlet UIView *title_view;
    __weak IBOutlet UICollectionView *tw_collectionView;
    __weak IBOutlet UIScrollView *title_scrollView;
}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) TWChooseModeView *modeView;

@end

@implementation TabTwoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tw_getChuanZuoTitles];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
    [layout setMinimumLineSpacing:14];
    [layout setMinimumInteritemSpacing:12];
    
    [tw_collectionView setCollectionViewLayout:layout];
    [tw_collectionView setBackgroundColor:UIColor.clearColor];
    [tw_collectionView registerNib:[UINib nibWithNibName:@"TWChuangZuoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWChuangZuoCollectionViewCellID"];
    
    self.modeView = [[TWChooseModeView alloc] init];
    [TWGlobalVC.shared.keywindow addSubview:self.modeView];
    self.modeView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectStatus) name:@"updatesTheStatusOfTheSelectedMode" object:nil];
    [tw_dh_status_button setImage:GlobalVC.isMode?SetImage(@"dh_gaoji_s"):SetImage(@"dh_jichu_s") forState:UIControlStateNormal];
}

- (void)updateSelectStatus {
    [tw_dh_status_button setImage:GlobalVC.isMode?SetImage(@"dh_gaoji_s"):SetImage(@"dh_jichu_s") forState:UIControlStateNormal];
}

- (IBAction)tw_chooseMode:(id)sender {
    [self.modeView tw_showView];
}

- (IBAction)vc_enterVip:(id)sender {
    
    [GlobalVC twAction_enterVIPViewController];
}

- (IBAction)tw_chooseTitleTypeAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSDictionary *obj = self.titles[sender.tag];
    [self tw_getChuangzuoTablelist:[obj objectForKey:@"dictValue"]];
    
    for (UIView *obj in title_scrollView.subviews) {
        UIButton *button = (UIButton *)obj;
        
        if ([button isKindOfClass:[UIButton class]]) {
            [button setBackgroundColor:UIColorFromRGB(0xDEE5E2)];
            [button setTitleColor:UIColorFromRGB(0x8A9690) forState:UIControlStateNormal];
            
            if (button == sender) {
                [button setBackgroundColor:UIColorFromRGB(0x34CCBB)];
                [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
                
                if (title_scrollView.contentSize.width < kScreenWidth) {
                    
                }
                else if (button.center.x > kScreenWidth/2 && button.center.x < (title_scrollView.contentSize.width - kScreenWidth/2)) {
                    CGPoint centerPoint = CGPointMake(button.center.x - title_scrollView.bounds.size.width/2, 0);
                    [title_scrollView setContentOffset:centerPoint animated:YES];
                }
                else if (button.center.x < kScreenWidth/2) {
                    [title_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
                else {
                    [title_scrollView setContentOffset:CGPointMake(title_scrollView.contentSize.width - kScreenWidth, 0) animated:YES];
                }
                
            }
        }
        
    }
    
}

- (void)tw_getChuanZuoTitles {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"aiType"];
    
    WS(weakSelf)
    [HttpClient postUrl:@"/ai/findAiTypeList" param:param success:^(id  _Nonnull json) {
          
        weakSelf.titles = [json objectForKey:@"data"];
        
        [weakSelf tw_createChuangzuoTitles];
        
        if (weakSelf.titles.count > 0) {
            NSDictionary *obj = [weakSelf.titles firstObject];
            [weakSelf tw_getChuangzuoTablelist:[obj objectForKey:@"dictValue"]];
        }
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

- (void)tw_getChuangzuoTablelist:(NSString *)type {
    [SVProgressHUD show];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"aiType"];
    [param setValue:type forKey:@"createType"];
    [param setValue:@"60" forKey:@"rows"];
    
    WS(weakSelf)
    [HttpClient postUrl:@"/ai/findAi" param:param success:^(id  _Nonnull json) {
          
        weakSelf.listArray = [json objectForKey:@"rows"];
        
        [tw_collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

- (void)tw_createChuangzuoTitles {
    
    CGFloat orgin_x = 16;
    CGFloat x_width = 50;
    for (int i = 0; i < self.titles.count; i++) {
        NSDictionary *obj = self.titles[i];
        NSString *titleStr = [obj objectForKey:@"dictLabel"];
        
        x_width = 50;
        if (titleStr.length > 3) {
            x_width = 70;
        }
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        button.tag = i;
        [title_scrollView addSubview:button];
        button.frame = CGRectMake(orgin_x, 10, x_width, 27);
        [button addTarget:self action:@selector(tw_chooseTitleTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        orgin_x = orgin_x + x_width + 18;
        
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        
        [button setBackgroundColor:UIColorFromRGB(0xDEE5E2)];
        [button setTitleColor:UIColorFromRGB(0x8A9690) forState:UIControlStateNormal];
        if (i == 0) {
            [button setBackgroundColor:UIColorFromRGB(0x34CCBB)];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }
    }
    [title_scrollView setContentSize:CGSizeMake(orgin_x, 0)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWChuangZuoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWChuangZuoCollectionViewCellID" forIndexPath:indexPath];
    [cell cell_updateCellData:self.listArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-44)/2, 108);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.listArray[indexPath.row];
    TWCZEditorViewController *czVC = [[TWCZEditorViewController alloc] init];
    czVC.title = [obj objectForKey:@"aiName"];
    czVC.tw_type_ID = [obj objectForKey:@"id"];
    [self.navigationController pushViewController:czVC animated:YES];
}


@end
