//
//  TWPlazaViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TWPlazaViewController.h"

@interface TWPlazaCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *tw_avatar_image;
@end

@implementation TWPlazaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tw_avatar_image = [[UIImageView alloc] init];
        [self.tw_avatar_image setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.tw_avatar_image];
        self.tw_avatar_image.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        self.tw_avatar_image.layer.cornerRadius = 16;
        self.tw_avatar_image.layer.masksToBounds = YES;
    }
    return self;
}

@end

@interface TWPlazaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;

@property (nonatomic, strong) NSMutableArray *tw_images;
@property (nonatomic, strong) NSMutableArray *tw_rows;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation TWPlazaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.page = 1;
    self.tw_rows = NSMutableArray.array;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
    [layout setMinimumLineSpacing:12];
    [layout setMinimumInteritemSpacing:12];
    
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerClass:[TWPlazaCollectionViewCell class] forCellWithReuseIdentifier:@"TWPlazaCollectionViewCellID"];
    
    [self tw_seekImagesTableList];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tw_rows.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.tw_rows[indexPath.row];
    
    TWPlazaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWPlazaCollectionViewCellID" forIndexPath:indexPath];
    
    NSArray *images = [obj objectForKey:@"imgUrls"];
    if (images.count > 1) {
        NSString *image_string = images[0];
        [cell.tw_avatar_image sd_setImageWithURL:LoadingImageUrl(image_string)];
    }
    else {
        [cell.tw_avatar_image sd_setImageWithURL:LoadingImageUrl([obj objectForKey:@"imgUrl"])];
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-44.12)/2, 227);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *obj = self.tw_rows[indexPath.row];
    TWShowImagesViewController *showVC = [[TWShowImagesViewController alloc] init];
    showVC.tw_param = obj;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.tw_rows.count - 3) {
        if (self.tw_rows.count < self.total) {
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
    
    [SVProgressHUD show];
    
    [HttpClient postUrl:@"/img/findAiSketchList" param:param success:^(id  _Nonnull json) {
        
        if (weakSelf.page == 1) {
            weakSelf.tw_rows = NSMutableArray.array;
        }
        
        NSArray *rows = [json objectForKey:@"rows"];
        weakSelf.total = [[json objectForKey:@"total"] intValue];
        if (rows > 0) {
            [weakSelf.tw_rows addObjectsFromArray:rows];
        }
        
        [weakSelf.tw_collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



@end
