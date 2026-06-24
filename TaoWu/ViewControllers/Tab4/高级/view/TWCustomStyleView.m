//
//  TWCustomStyleView.m
//  TaoWu
//
//  Created by JJK on 2023/12/15.
//

#import "TWCustomStyleView.h"
#import "TWCustomStyleCollectionViewCell.h"

@interface TWCustomStyleView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView2;
@property (nonatomic, strong) NSArray *tw_listArray;
@property (nonatomic, strong) NSArray *tw_listArray2;
@property (nonatomic, assign) NSInteger tw_select_index;
@property (nonatomic, assign) NSInteger tw_select_section;

@property (nonatomic, copy) NSString *default_type; // 记录上次的选择

@end

@implementation TWCustomStyleView

- (instancetype)initWithFrame:(CGRect)frame withTragt:(id)tragt {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWCustomStyleView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        self.backgroundColor = UIColor.clearColor;
        self.delegate = tragt;
        self.tw_select_section = 1;
        self.tw_select_index = 100;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
        [layout setMinimumLineSpacing:12];
        [layout setMinimumInteritemSpacing:8];

        [self.tw_collectionView setBounces:NO];
        [self.tw_collectionView setDelegate:self];
        [self.tw_collectionView setDataSource:self];
        [self.tw_collectionView setCollectionViewLayout:layout];
        [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
        [self.tw_collectionView registerNib:[UINib nibWithNibName:@"TWCustomStyleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWCustomStyleCollectionViewCellID"];
        
        [self.tw_collectionView2 setBounces:NO];
        [self.tw_collectionView2 setDelegate:self];
        [self.tw_collectionView2 setDataSource:self];
        [self.tw_collectionView2 setCollectionViewLayout:layout];
        [self.tw_collectionView2 setBackgroundColor:UIColor.clearColor];
        [self.tw_collectionView2 registerNib:[UINib nibWithNibName:@"TWCustomStyleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWCustomStyleCollectionViewCellID2"];
        
        [self tw_initItems];
        
        
    }
    return self;
}

- (void)tw_initItems {
    self.tw_listArray = @[@{@"icon":@"fg_sbpk",@"iconName":@"赛博朋克",@"select":@"0"},
                          @{@"icon":@"fg_xsh",@"iconName":@"像素画",@"select":@"0"},
                          @{@"icon":@"fg_fsh",@"iconName":@"浮世绘",@"select":@"0"},
                          @{@"icon":@"fg_bpys",@"iconName":@"波谱艺术",@"select":@"0"},
                          @{@"icon":@"fg_xs",@"iconName":@"素描",@"select":@"0"},
                          @{@"icon":@"fg_3dkt",@"iconName":@"3D卡通",@"select":@"0"}];
    
    self.tw_listArray2 = @[
                          @{@"icon":@"fg_qb",@"iconName":@"Q版",@"select":@"0"},
                          @{@"icon":@"fg_sc",@"iconName":@"水彩",@"select":@"0"},
                          @{@"icon":@"fg_yh",@"iconName":@"油画",@"select":@"0"},
                          @{@"icon":@"fg_zgh",@"iconName":@"中国画",@"select":@"0"},
                          @{@"icon":@"fg_bpch",@"iconName":@"扁平插画",@"select":@"0"},
                          @{@"icon":@"fg_ecy",@"iconName":@"二次元",@"select":@"0"}];
    
    [self.tw_collectionView reloadData];
    [self.tw_collectionView2 reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.tw_collectionView]) {
        return self.tw_listArray.count;
    }
    else {
        return self.tw_listArray2.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj;
    if ([collectionView isEqual:self.tw_collectionView]) {
        
        obj = self.tw_listArray[indexPath.row];
        TWCustomStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWCustomStyleCollectionViewCellID" forIndexPath:indexPath];
        cell.tw_icon_image.image = SetImage([obj objectForKey:@"icon"]);
        cell.tw_name_label.text = [obj objectForKey:@"iconName"];
        
        cell.tw_icon_image.layer.cornerRadius = 19;
        cell.tw_icon_image.layer.masksToBounds = YES;
        cell.tw_icon_image.layer.borderColor = UIColor.clearColor.CGColor;
        
        if (indexPath.row == self.tw_select_index && self.tw_select_section ==  1 ) {
            cell.tw_icon_image.layer.borderWidth = 2;
            cell.tw_icon_image.layer.borderColor = UIColorFromRGB(0x23563FF).CGColor;
        }
        return cell;
        
    }
    
    else  {
        
        obj = self.tw_listArray2[indexPath.row];
        TWCustomStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWCustomStyleCollectionViewCellID2" forIndexPath:indexPath];
        
        cell.tw_icon_image.image = SetImage([obj objectForKey:@"icon"]);
        cell.tw_name_label.text = [obj objectForKey:@"iconName"];
        
        cell.tw_icon_image.layer.cornerRadius = 19;
        cell.tw_icon_image.layer.masksToBounds = YES;
        cell.tw_icon_image.layer.borderColor = UIColor.clearColor.CGColor;
        
        if (indexPath.row == self.tw_select_index && self.tw_select_section ==  2) {
            cell.tw_icon_image.layer.borderWidth = 2;
            cell.tw_icon_image.layer.borderColor = UIColorFromRGB(0x23563FF).CGColor;
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *obj;
    
    if ([collectionView isEqual:self.tw_collectionView]) {
        
        if (self.tw_select_index == indexPath.row) {
            self.tw_select_index = 100;
        }else {
            self.tw_select_index = indexPath.row;
        }
        
        
        self.tw_select_section = 1;
        obj = self.tw_listArray[indexPath.row];
        [self.tw_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    else if ([collectionView isEqual:self.tw_collectionView2]) {
        
        if (self.tw_select_index == indexPath.row) {
            self.tw_select_index = 100;
        }else {
            self.tw_select_index = indexPath.row;
        }
        
        self.tw_select_section = 2;
        obj = self.tw_listArray2[indexPath.row];
        [self.tw_collectionView2 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    [self.tw_collectionView reloadData];
    [self.tw_collectionView2 reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tw_selectCustomStyleView:)]) {
        
        [self.delegate tw_selectCustomStyleView:[obj objectForKey:@"iconName"]];
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(62, 86);
}



@end
