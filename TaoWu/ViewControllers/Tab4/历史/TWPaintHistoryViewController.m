//
//  TWPaintHistoryViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import "TWPaintHistoryViewController.h"

@interface TWPaintHistoryCollectionViewCell: UICollectionViewCell
@property (nonatomic, strong) UIImageView *cell_image;
@property (nonatomic, strong) UILabel *cell_label;
@end

@implementation TWPaintHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cell_image = [[UIImageView alloc] init];
        self.cell_image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.cell_image];
        self.cell_image.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        self.cell_image.layer.cornerRadius = 16;
        self.cell_image.layer.masksToBounds = YES;
        
        self.cell_label = [[UILabel alloc] init];
        self.cell_label.textColor = UIColorFromRGB(0x333333);
        self.cell_label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.cell_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.cell_label];
        self.cell_label.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    }
    return self;
}

@end

@interface TWPaintHistoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (nonatomic, strong) TWShowImageView *showImageView;
@property (nonatomic, strong) NSMutableArray *tw_images;

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation TWPaintHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"历史记录"];
    
    self.tw_images = NSMutableArray.array;
    [self tw_seekImagesTableList];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
    [layout setMinimumLineSpacing:12];
    [layout setMinimumInteritemSpacing:14];

//    [self.tw_collectionView setBounces:NO];
    [self.tw_collectionView setDelegate:self];
    [self.tw_collectionView setDataSource:self];
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerClass:[TWPaintHistoryCollectionViewCell class] forCellWithReuseIdentifier:@"TWPaintHistoryCollectionViewCellID"];
    
    self.showImageView = [[TWShowImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [GlobalVC.keywindow addSubview:self.showImageView];
    self.showImageView.alpha = 0.0;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadImages:) name:@"reloadHistoryImagesNotificationName" object:nil];
}

- (void)_reloadImages:(NSNotification *)notification {
    NSDictionary *obj = notification.userInfo;
    if ([[obj objectForKey:@"taskType"] intValue] == 2) {
        self.tw_images = NSMutableArray.array;
        [self tw_seekImagesTableList];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tw_images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWPaintHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWPaintHistoryCollectionViewCellID" forIndexPath:indexPath];
    
    NSDictionary *obj = self.tw_images[indexPath.row];
    NSArray *images = [obj objectForKey:@"imgUrls"];
    cell.cell_label.hidden = YES;
    if (images.count == 0) {
        [cell.cell_image setImage:SetImage(@"hh_default")];
        [cell.cell_label setText:@"正在构图中……"];
        cell.cell_label.hidden = NO;
    }
    else if (images.count > 1) {
        NSString *image_string = images[0];
        [cell.cell_image sd_setImageWithURL:LoadingImageUrl(image_string)];
    }
    else {
        [cell.cell_image sd_setImageWithURL:LoadingImageUrl([obj objectForKey:@"imgUrl"])];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.tw_images[indexPath.row];
    TWShowImagesViewController *showVC = [[TWShowImagesViewController alloc] init];
    showVC.tw_param = obj;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-46)/2, 227);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.tw_images.count - 3) {
        if (self.tw_images.count < self.total) {
            self.page++;
            [self tw_seekImagesTableList];
            self.isRefresh = NO;
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_y = self.tw_collectionView.contentOffset.y;
    
    if (offset_y < -55 && !self.isRefresh) {
        self.page = 1;
        self.isRefresh = YES;
        [self tw_seekImagesTableList];
    }
}


- (void)tw_seekImagesTableList {
  
    WS(weakSelf)
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    [param setValue:@(self.page) forKey:@"pageNum"];
    [param setValue:@(10) forKey:@"pageSize"];
    
    [HttpClient postUrl:@"/img/list" param:param success:^(id  _Nonnull json) {
        
        if (weakSelf.page == 1) {
            weakSelf.tw_images = NSMutableArray.array;
        }
        
        NSArray *rows = [json objectForKey:@"rows"];
        weakSelf.total = [[json objectForKey:@"total"] intValue];
        if (rows > 0) {
            [weakSelf.tw_images addObjectsFromArray:rows];
        }

        [weakSelf.tw_collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
