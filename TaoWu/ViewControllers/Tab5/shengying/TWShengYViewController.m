//
//  TWShengYViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/7.
//

#import "TWShengYViewController.h"
#import "TWShengYCollectionViewCell.h"
#import "TWShengYCollectionReusableView.h"

@interface TWShengYViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (weak, nonatomic) IBOutlet UISlider *tw_slider;
@property (weak, nonatomic) IBOutlet UILabel *tw_speed_label;

@property (nonatomic, strong) NSMutableArray *tw_sh_Array;
@property (nonatomic, assign) NSInteger tw_section;
@property (nonatomic, assign) NSInteger tw_row;

@end

@implementation TWShengYViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TWSpeechSynthesisManager.sharedManager tw_stopPlayerVoice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择声音"];
    
    self.tw_slider.minimumTrackTintColor = UIColorFromRGB(0x2CD3BE);
    self.tw_slider.maximumTrackTintColor = UIColorFromRGB(0xD2F2E0);
    self.tw_slider.minimumValue = 0.7;
    self.tw_slider.maximumValue = 1.5;
    
    NSString *speed_level = [SAVE_UDF objectForKey:@"speed_level"];
    
    if ([speed_level floatValue] > 0.5) {
        self.tw_slider.value = [speed_level floatValue];
        self.tw_speed_label.text = speed_level;
    }else {
        self.tw_slider.value = 1.0;
        self.tw_speed_label.text = @"1.0";
    }
    
    [self.tw_slider setThumbImage:SetImage(@"wd_sy_yq") forState:UIControlStateNormal];
    [self.tw_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(10, 23, 10, 23)];
    [layout setMinimumInteritemSpacing:16];
    [layout setMinimumLineSpacing:24];
    
    [self.tw_collectionView setBounces:YES];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView registerNib:[UINib nibWithNibName:@"TWShengYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWShengYCollectionViewCellID"];
    [self.tw_collectionView registerClass:[TWShengYCollectionReusableView self] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];

    
    NSArray *syArray = @[@[@{@"name":@"御姐女声",@"label":@"zhiyuan",@"selelct":@"0"},
                           @{@"name":@"知心女声",@"label":@"zhiyue",@"selelct":@"0"},
                           @{@"name":@"电台女声",@"label":@"zhiyan_emo",@"selelct":@"0"},
                           @{@"name":@"标准女声",@"label":@"zhimiao_emo",@"selelct":@"0"}],
                         @[@{@"name":@"标准男声",@"label":@"aishuo",@"selelct":@"0"},
                           @{@"name":@"磁性男声",@"label":@"ailun",@"selelct":@"0"},
                           @{@"name":@"青年男声",@"label":@"sicheng",@"selelct":@"0"},
                           @{@"name":@"诙谐男声",@"label":@"laotie",@"selelct":@"0"}]];
    
    self.tw_sh_Array = [NSMutableArray arrayWithArray:syArray];
    
    self.tw_row = 100;
    self.tw_section = 100;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.tw_sh_Array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tw_sh_Array[section] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWShengYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWShengYCollectionViewCellID" forIndexPath:indexPath];
    NSDictionary *obj = self.tw_sh_Array[indexPath.section][indexPath.row];
    [cell.cell_name_label setText:[obj objectForKey:@"name"]];
    [cell.cell_bg_view.layer setCornerRadius:12];
    [cell.cell_bg_view.layer setMasksToBounds:YES];
    
    [cell.cell_bg_view setBackgroundColor:UIColorFromRGB(0xF4F6F8)];
    if (self.tw_section == indexPath.section) {
        if (indexPath.row == self.tw_row) {
            [cell.cell_bg_view setBackgroundColor:UIColorFromRGB(0xD2F2E0)];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.tw_sh_Array[indexPath.section][indexPath.row];
    NSString *font_name = [obj objectForKey:@"label"];
    [SAVE_UDF setObject:font_name forKey:@"font_name"];
    
    self.tw_section = indexPath.section;
    self.tw_row = indexPath.row;
    
    [[TWSpeechSynthesisManager sharedManager] tw_stopPlayerVoice];
    
    [self performSelector:@selector(delayAction) afterDelay:0.691];
    
    [self.tw_collectionView reloadData];
}

- (void)delayAction {
    [[TWSpeechSynthesisManager sharedManager] tw_playerVoice:@"你好，我是AI小助手，请问有什么可以帮你的吗？"];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-94)/2, 45);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake((kScreenWidth-94)/2, 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TWShengYCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            [reusableView.tw_reusableTitleLabel setText:@"女声"];
        }
        
        else {
            [reusableView.tw_reusableTitleLabel setText:@"男声"];
        }
        
        return reusableView;
    }
    return UICollectionReusableView.new;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)sliderValueChanged:(UISlider *)sender {
    CGFloat value = sender.value;
    self.tw_speed_label.text = [NSString stringWithFormat:@"%.2fx",value];
    [SAVE_UDF setValue:self.tw_speed_label.text forKey:@"speed_level"];
}

@end
