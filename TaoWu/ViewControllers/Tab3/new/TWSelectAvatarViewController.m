//
//  TWSelectAvatarViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TWSelectAvatarViewController.h"

@interface TWSelectAvatarCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *tw_avatar_image;
@end

@implementation TWSelectAvatarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tw_avatar_image = [[UIImageView alloc] init];
        [self.tw_avatar_image setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.tw_avatar_image];
        self.tw_avatar_image.layer.cornerRadius = 10;
        self.tw_avatar_image.layer.masksToBounds = YES;
        self.tw_avatar_image.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    }
    return self;
}

@end

@interface TWSelectAvatarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;

@property (nonatomic, strong) NSArray *tw_images;
@property (nonatomic, assign) NSInteger tw_selectIndex;

@end

@implementation TWSelectAvatarViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择头像";
    self.tw_selectIndex = 100;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
    [layout setMinimumLineSpacing:14];
    [layout setMinimumInteritemSpacing:12];
    
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerClass:[TWSelectAvatarCollectionViewCell class] forCellWithReuseIdentifier:@"TWSelectAvatarCollectionViewCellID"];
    
    self.tw_images = @[@"https://oss.yhxykj.com/im-prod/img/18_1.png",
                       @"https://oss.yhxykj.com/im-prod/img/18_2.png",
                       @"https://oss.yhxykj.com/im-prod/img/18_3.png",
                       @"https://oss.yhxykj.com/im-prod/img/18_4.png",
                       @"https://oss.yhxykj.com/im-prod/img/18_5.png",
                       @"https://oss.yhxykj.com/im-prod/img/18_6.png"];
}

- (IBAction)tw_queDingAction:(id)sender {
    
    if (self.selectAvatarBlock) {
        self.selectAvatarBlock(self.tw_images[self.tw_selectIndex]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tw_images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    TWSelectAvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWSelectAvatarCollectionViewCellID" forIndexPath:indexPath];
    [cell.tw_avatar_image sd_setImageWithURL:LoadingImageUrl(self.tw_images[indexPath.row])];
    
    cell.tw_avatar_image.layer.borderWidth = 0;
    if (self.tw_selectIndex == indexPath.row) {
        cell.tw_avatar_image.layer.borderWidth = 2;
        cell.tw_avatar_image.layer.borderColor = UIColorFromRGB(0x4C82FF).CGColor;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-44)/2, 227);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.tw_selectIndex = indexPath.row;
    [self.tw_collectionView reloadData];
}

@end
