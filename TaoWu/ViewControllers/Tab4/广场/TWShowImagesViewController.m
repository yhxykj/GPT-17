//
//  TWShowImagesViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/25.
//

#import "TWShowImagesViewController.h"

@interface TWShowImagesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (weak, nonatomic) IBOutlet UITextView *tw_textView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *tw_images;
@property (nonatomic, strong) UIImage *save_image;

@end

@implementation TWShowImagesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(5, 29, 5, 29)];
    [layout setMinimumLineSpacing:70];
    [layout setMinimumInteritemSpacing:30];
    
    [self.tw_collectionView setPagingEnabled:YES];
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerNib:[UINib nibWithNibName:@"TWShowImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"show_cell"];
    
    
    self.tw_images = [self.tw_param objectForKey:@"imgUrls"];
    [self.tw_collectionView reloadData];
    [self.tw_textView setText:[self.tw_param objectForKey:@"prompt"]];
    if ([self.tw_textView.text containsString:@"http"]) {
        self.tw_textView.hidden = YES;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"共 %ld 张",self.tw_images.count];
    
    if (self.tw_images.count > 1) {
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = self.tw_images.count;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tw_images.count;
}

- (__kindof TWShowImageCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TWShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"show_cell" forIndexPath:indexPath];
    NSString *image_string = self.tw_images[indexPath.row];
    [cell.cell_image sd_setImageWithURL:LoadingImageUrl(image_string)];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth-68, kScreenHeight-266-85-TWStatusBarHeight());
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [GlobalVC tw_showActionImageWithURLs:self.tw_images index:indexPath.row sender:collectionView];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(TWShowImageCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.save_image = cell.cell_image.image;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.tw_collectionView.contentOffset.x;
    if (width == kScreenWidth) {
        self.pageControl.currentPage = 1;
    }
    else if (width == 2*kScreenWidth) {
        self.pageControl.currentPage = 2;
    }
    else if (width > 2*kScreenWidth + 100) {
        self.pageControl.currentPage = 3;
    }
    else if (width == 0) {
        self.pageControl.currentPage = 0;
    }
}


- (IBAction)_saveImageAction:(id)sender {
    
    [GlobalVC tw_saveImageToPhoto:self.save_image];
}

- (IBAction)_createTkImageAction:(id)sender {
    
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    NSString *_prompt = [self.tw_param objectForKey:@"prompt"];
    
    [param setValue:[self.tw_param objectForKey:@"resultConfig"] forKey:@"resultConfig"];
    [param setValue:_prompt forKey:@"prompt"];
    [param setValue:[self.tw_param objectForKey:@"taskParameter"] forKey:@"taskParameter"];
    [param setValue:[self.tw_param objectForKey:@"sum"] forKey:@"sum"];
    
    TWResultViewController *resultVC = [[TWResultViewController alloc] init];
    resultVC.tw_param = param;
    resultVC.count = [[self.tw_param objectForKey:@"sum"] intValue];
    [self.navigationController pushViewController:resultVC animated:YES];
}



@end
