//
//  TabThirdViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TabThirdViewController.h"
#import "TWNewZhuliViewController.h"
#import "TabThirdCollectionViewCell.h"

@interface TabThirdViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UIView *title_view;
    __weak IBOutlet UIScrollView *title_scrollView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *listArray;

@end

@implementation TabThirdViewController

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
    [layout setMinimumLineSpacing:10];
    [layout setMinimumInteritemSpacing:10];
    
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerNib:[UINib nibWithNibName:@"TabThirdCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TabThirdCollectionViewCellID"];
}

- (IBAction)vc_enterVip:(id)sender {
    
    [GlobalVC twAction_enterVIPViewController];
}

- (IBAction)tw_addZhuliAction:(id)sender {
    TWNewZhuliViewController *zlVC = [[TWNewZhuliViewController alloc] init];
    [self.navigationController pushViewController:zlVC animated:YES];
}

- (IBAction)tw_chooseTitleTypeAction:(UIButton *)sender {
    
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
                
                NSLog(@"%.2f",title_scrollView.contentOffset.x);
            }
        }
    }
    
}

- (void)tw_getChuanZuoTitles {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"aiType"];
    
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
    [param setValue:@"1" forKey:@"aiType"];
    [param setValue:type forKey:@"createType"];
    [param setValue:@"60" forKey:@"rows"];
    
    WS(weakSelf)
    [HttpClient postUrl:@"/ai/findAi" param:param success:^(id  _Nonnull json) {
          
        weakSelf.listArray = [json objectForKey:@"rows"];
        
        [self.tw_collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

- (void)tw_createChuangzuoTitles {
    
    CGFloat orgin_x = 16;
    CGFloat x_width = 50;
    for (int i = 0; i < self.titles.count; i++) {
        NSDictionary *obj = self.titles[i];
        NSString *titleStr = [obj objectForKey:@"dictLabel"];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        button.tag = i;
        [title_scrollView addSubview:button];
        
        x_width = 50;
        if (titleStr.length > 3) {
            x_width = 70;
        }
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
    NSDictionary *obj = self.listArray[indexPath.row];
    TabThirdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TabThirdCollectionViewCellID" forIndexPath:indexPath];
    [cell cell_updateCellData:obj];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-42)/2, 247);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.listArray[indexPath.row];
    TWMainViewController *chatVC = [[TWMainViewController alloc] init];
    chatVC.isdefault = NO;
    chatVC.type_id = [obj objectForKey:@"id"];
    chatVC.tw_describle_string = [obj objectForKey:@"aiDetails"];
    [self.navigationController pushViewController:chatVC animated:YES];
}




@end
