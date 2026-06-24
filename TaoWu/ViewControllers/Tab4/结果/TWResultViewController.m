//
//  TWResultViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/15.
//

#import "TWResultViewController.h"
#import "TWShowImageView.h"

@interface TWResultCollectionViewCell: UICollectionViewCell
@property (nonatomic, strong) UIImageView *cell_image;
@property (nonatomic, strong) UILabel *cell_label;
@end

@implementation TWResultCollectionViewCell

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

@interface TWResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (nonatomic, strong) TWShowImageView *loadingImageView;
@property (nonatomic, strong) TWPonitsView *tw_pointsView;

@property (nonatomic, copy) NSString *_imageId;
@property (nonatomic, strong) NSArray *tw_images;
@property (nonatomic, assign) NSInteger tw_jindu;
@property (nonatomic, assign) NSInteger tw_taskType;

@end

@implementation TWResultViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter postNotificationName:@"TWUpdateUserPointsNotificationName" object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"reloadHistoryImagesNotificationName" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"生成结果"];
    
    self.tw_jindu = 10;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
    [layout setMinimumLineSpacing:12];
    [layout setMinimumInteritemSpacing:14];

    [self.tw_collectionView setBounces:NO];
    [self.tw_collectionView setDelegate:self];
    [self.tw_collectionView setDataSource:self];
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerClass:[TWResultCollectionViewCell class] forCellWithReuseIdentifier:@"TWResultCollectionViewCellID"];
    
    self.loadingImageView = [[TWShowImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.loadingImageView];
    self.loadingImageView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    self.loadingImageView.alpha = 0.0;
    
    [self tw_drawingInTextRequest];

    
    self.tw_pointsView = [[TWPonitsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_pointsView];
    self.tw_pointsView.alpha = 0.0;
    
    self.loadingImageView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadImages:) name:@"reloadHistoryImagesNotificationName" object:nil];
}

- (void)_reloadImages:(NSNotification *)notification {
    NSDictionary *obj = notification.userInfo;
    if ([[obj objectForKey:@"taskType"] intValue] == 2) {
        [self.loadingImageView _hiddenImageView];
        self.tw_images = [obj objectForKey:@"imgUrls"];
        [self.tw_collectionView reloadData];
        self.tw_jindu = 10;
        
        self.tw_taskType = [[obj objectForKey:@"taskType"] intValue];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.tw_images.count > 0) {
        return self.tw_images.count;
    }
    else {
        return self.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWResultCollectionViewCellID" forIndexPath:indexPath];
    
    if (self.tw_images.count > 0) {
        NSString *image_string = self.tw_images[indexPath.row];
        [cell.cell_image sd_setImageWithURL:LoadingImageUrl(image_string)];
        
        [cell.cell_label setHidden:YES];
    }
    else {
        [cell.cell_image setImage:SetImage(@"hh_default")];
        
        [cell.cell_label setText:[NSString stringWithFormat:@"正在生成中 %ld%%",self.tw_jindu]];
        
        [cell.cell_label setHidden:NO];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [GlobalVC tw_showActionImageWithURLs:self.tw_images index:indexPath.row sender:collectionView];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.count == 1) {
        return CGSizeMake(kScreenWidth-32, 430);
    }
    
    return CGSizeMake((kScreenWidth-46)/2, 227);
}

- (void)tw_drawingInTextRequest {
    
    WS(weakSelf)
    [HttpClient postUrl:@"/img/aiSketch" param:self.tw_param success:^(id  _Nonnull json) {
           
        NSInteger code = [[json objectForKey:@"code"] intValue];
        
        if (code == 500) {
            [weakSelf.tw_pointsView _showImageView];
        }
        else if (code != 200) {
            [SVProgressHUD showErrorWithStatus:@"绘画失败！"];
        }
        else {
            [weakSelf.loadingImageView _showImageView];
            GlobalVC.ImageId = [json objectForKey:@"data"];
            
            [weakSelf _getImageProgress];
            
            [weakSelf performSelector:@selector(tw_seekCurrentImages) afterDelay:1.01];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)tw_seekCurrentImages {
    
    if (self.tw_taskType != 2) {
        [self performSelector:@selector(tw_seekCurrentImages) afterDelay:1.01];
    }
    if (self.tw_jindu < 90) {
        self.tw_jindu = self.tw_jindu + 3;
    }
    [self.tw_collectionView reloadData];
  
}

- (void)_getImageProgress {
    
    [GlobalVC tw_getImageProgress];
}

@end
