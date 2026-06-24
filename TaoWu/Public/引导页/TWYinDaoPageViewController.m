//
//  TWYinDaoPageViewController.m
//  TaoWu
//
//  Created by JJK on 2024/1/14.
//

#import "TWYinDaoPageViewController.h"
#import "TWYdPageCollectionViewCell.h"

@interface TWYinDaoPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TWYdPageCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;

@end

@implementation TWYinDaoPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tw_collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    
    self.tw_collectionView.bounces = NO;
    self.tw_collectionView.pagingEnabled = YES;
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerNib:[UINib nibWithNibName:@"TWYdPageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWYdPageCollectionViewCellID"];
}

- (IBAction)tw_nextButtonAction:(UIButton *)sender {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWYdPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWYdPageCollectionViewCellID" forIndexPath:indexPath];
    cell.tw_next_button.tag = indexPath.row+1;
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        cell.tw_bg_image.image = SetImage(@"yd_one");
    }
    
    else if (indexPath.row == 1) {
        cell.tw_bg_image.image = SetImage(@"yd_two");
    }
    
    else if (indexPath.row == 2) {
        cell.tw_bg_image.image = SetImage(@"yd_thrid");
    }
    
    else if (indexPath.row == 3) {
        cell.tw_bg_image.image = SetImage(@"yd_four");
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, kScreenHeight);
}

- (void)tw_cellIndexpath_item:(NSInteger)item {
    
    if (item == 4) {
        [SAVE_UDF setValue:@"1" forKey:@"login"];
        TWBaseTabBarViewController *tabBarController = TWBaseTabBarViewController.new;
        [GlobalVC.keywindow setRootViewController:tabBarController];
    }
    
    [self.tw_collectionView setContentOffset:CGPointMake(kScreenWidth*item, 0) animated:YES];
}

@end
