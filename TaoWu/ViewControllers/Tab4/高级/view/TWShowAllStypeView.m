//
//  TWShowAllStypeView.m
//  TaoWu
//
//  Created by JJK on 2023/12/26.
//

#import "TWShowAllStypeView.h"

@interface TWShowAllCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *cell_name_label;
@property (nonatomic, strong) UIImageView *cell_image_s;

@end

@implementation TWShowAllCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.cell_name_label = label;
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        self.cell_name_label.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        UIImageView *image = [[UIImageView alloc] init];
        image.image = SetImage(@"zy_s");
        [self addSubview:image];
        self.cell_image_s = image;
        self.cell_image_s.sd_layout.heightIs(17).widthIs(17).rightSpaceToView(self, 6).bottomSpaceToView(self, 6);
        
    }
    return self;
}

@end

@interface TWShowAllStypeView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIScrollView *tw_scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSMutableArray *select_names;

@property (nonatomic, strong) UIImageView *line;

@end

@implementation TWShowAllStypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"TWShowAllStypeView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        
        self.select_names = [NSMutableArray array];
        self.nameArray = [self _getAllData];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setSectionInset:UIEdgeInsetsMake(5, 12, 85, 12)];
        [layout setMinimumLineSpacing:14];
        [layout setMinimumInteritemSpacing:14];
        
        [self.tw_collectionView setDelegate:self];
        [self.tw_collectionView setDataSource:self];
        [self.tw_collectionView setCollectionViewLayout:layout];
        [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
        [self.tw_collectionView registerClass:[TWShowAllCollectionViewCell class] forCellWithReuseIdentifier:@"TWShowAllCollectionViewCellID"];
        
        [self tw_createTitles];
        
    }
    return self;
}

- (void)_showAllStypeView {
    WS(weakSelf)
    [UIView animateWithDuration:0.31 animations:^{
        weakSelf.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

- (IBAction)_closeAction:(id)sender {
    WS(weakSelf)
    [UIView animateWithDuration:0.31 animations:^{
        weakSelf.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

- (IBAction)_queRenAction:(id)sender {
    NSString *string = [self.select_names componentsJoinedByString:@","];
    if (self.addStypeSuccessBlock) {
        self.addStypeSuccessBlock(string);
    }
    
    WS(weakSelf)
    [UIView animateWithDuration:0.31 animations:^{
        weakSelf.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    TWShowAllCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWShowAllCollectionViewCellID" forIndexPath:indexPath];
    NSString *nameStr = self.nameArray[indexPath.row];
    cell.cell_name_label.text = nameStr;
    cell.backgroundColor = UIColorFromRGB(0xF3FCFF);
    cell.cell_name_label.textColor = UIColorFromRGB(0x333333);
    
    cell.cell_image_s.hidden = YES;
    if ([self.select_names containsObject:nameStr]) {
        cell.cell_image_s.hidden = NO;
        cell.backgroundColor = UIColorFromRGB(0x4C7FFF);
        cell.cell_name_label.textColor = UIColorFromRGB(0xFFFFFF);
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-52)/3, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *nameStr = self.nameArray[indexPath.row];
    
    if ([self.select_names containsObject:nameStr]) {
        [self.select_names removeObject:nameStr];
    }
    else {
        [self.select_names addObject:nameStr];
    }
    
    [self.tw_collectionView reloadData];
    
}





#pragma mark -
- (void)tw_createTitles {
    
    CGFloat orgin_x = 4;
    CGFloat x_width = 53;
    
    self.titles = @[@"全部", @"风格", @"光线", @"材质", @"渲染", @"色彩", @"构图", @"视角"];
    
    for (int i = 0; i < self.titles.count; i++) {
        NSString *titleStr = self.titles[i];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        button.tag = i;
        [self.tw_scrollView addSubview:button];
        
        button.frame = CGRectMake(orgin_x, 0, x_width, 44);
        
        [button addTarget:self action:@selector(tw_chooseTitleTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        orgin_x = orgin_x + x_width;
        
        [button setTitleColor:UIColorFromRGB(0x757577) forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
            
            self.line = [[UIImageView alloc] init];
            self.line.image = SetImage(@"zy_line");
            [self.tw_scrollView addSubview:self.line];
            self.tw_scrollView.frame = CGRectMake(16, 33, 26, 5);
            self.line.userInteractionEnabled = YES;
            
        }
    }
    [self.tw_scrollView setContentSize:CGSizeMake(orgin_x, 0)];
}

- (void)tw_chooseTitleTypeAction:(UIButton *)sender {
    
    for (UIView *obj in self.tw_scrollView.subviews) {
        UIButton *button = (UIButton *)obj;
        if ([button isKindOfClass:[UIButton class]]) {
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:UIColorFromRGB(0x757577) forState:UIControlStateNormal];
            if (button == sender) {
                [button.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                
                self.line.centerX = button.center.x;
                
                if (self.tw_scrollView.contentSize.width < kScreenWidth) {
                    return;
                }
                
                if (button.center.x > kScreenWidth/2 && button.center.x < (self.tw_scrollView.contentSize.width - kScreenWidth/2)) {
                    CGPoint centerPoint = CGPointMake(button.center.x - self.tw_scrollView.bounds.size.width/2, 0);
                    [self.tw_scrollView setContentOffset:centerPoint animated:YES];
                }
                else if (button.center.x < kScreenWidth/2) {
                    [self.tw_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
                else {
                    [self.tw_scrollView setContentOffset:CGPointMake(self.tw_scrollView.contentSize.width - kScreenWidth, 0) animated:YES];
                }
                
                NSLog(@"%.2f",self.tw_scrollView.contentOffset.x);
            }
            
        }
    }
    
    if (sender.tag == 0) {
        self.nameArray = [self _getAllData];
    }else if (sender.tag == 1) {
        self.nameArray = [self _getStypeData];
    }else if (sender.tag == 2) {
        self.nameArray = [self _getRayOflightData];
    }else if (sender.tag == 3) {
        self.nameArray = [self _getMaterialData];
    }else if (sender.tag == 4) {
        self.nameArray = [self _getRenderData];
    }else if (sender.tag == 5) {
        self.nameArray = [self _getColorsData];
    }else if (sender.tag == 6) {
        self.nameArray = [self _getCompositionOfPictureData];
    }else if (sender.tag == 7) {
        self.nameArray = [self _getVisualAngleData];
    }
    
    [self.tw_collectionView reloadData];
    
}

/// 全部
- (NSArray *)_getAllData {
    NSArray *array = @[
        @"非洲未来主义", @"剪影", @"涂鸦", @"碎裂效果", @"波西米亚风格", @"美式漫画", @"ASCIl art", @"蒙德里安", @"毕加索", @"穆夏", @"包豪斯", @"Q版", @"水彩", @"油画", @"中国画", @"扁平插画", @"二次元", @"素描", @"3D卡通", @"轮廓光", @"体积光", @"霓虹灯", @"镭射光", @"荧光", @"侧光", @"反射光", @"摄影棚照明", @"透镜光晕", @"氛围光照", @"自然光", @"太空光", @"发光效果", @"冷光", @"背景光", @"逆光", @"聚光灯", @"暖光", @"生物发光", @"双性照明", @"电影级光照", @"伦勃朗光", @"丁达尔效应", @"漏光效应", @"彩色玻璃工艺", @"彩虹箔", @"X光", @"磨砂玻璃", @"玻璃渐变", @"铜版雕刻", @"液态金属", @"毛毡风格", @"充气效果", @"铝制", @"亚克力质感", @"衍纸艺术", @"虚幻引擎", @"CAD", @"Blender", @"Octane", @"柔和色彩", @"莫兰迪色调", @"荧光色", @"互补色", @"微距镜头", @"超广角镜头", @"长焦镜头", @"仰视视角", @"俯视视角"
    ];
    
    return array;
}

/// 风格
- (NSArray *)_getStypeData {
    NSArray *array = @[@"印象派", @"点彩画", @"厚涂", @"像素画", @"波谱艺术", @"彩铅", @"赛博朋克", @"浮世绘", @"皮克斯风格", @"低聚", @"工笔画", @"水墨画", @"梵高风格", @"莫奈风格", @"蒸汽朋克", @"柴油朋克", @"故障艺术", @"全息投影", @"机械美学", @"古风", @"吉卜力", @"非洲未来主义", @"剪影", @"涂鸦", @"碎裂效果", @"波西米亚风格", @"美式漫画", @"ASCIl art", @"蒙德里安", @"毕加索", @"穆夏", @"包豪斯", @"Q版", @"水彩", @"油画", @"中国画", @"扁平插画", @"二次元", @"素描", @"3D卡通"];
    
    return array;
}

/// 光线
- (NSArray *)_getRayOflightData {
    NSArray *array = @[@"漏光效应", @"轮廓光", @"体积光", @"霓虹灯", @"镭射光", @"荧光", @"侧光", @"反射光", @"摄影棚照明", @"透镜光晕", @"氛围光照", @"自然光", @"太空光", @"发光效果", @"冷光", @"背景光", @"逆光", @"聚光灯", @"暖光", @"生物发光", @"双性照明", @"电影级光照", @"伦勃朗光", @"丁达尔效应"];
    
    return array;
}

/// 材质
- (NSArray *)_getMaterialData {
    NSArray *array = @[@"衍纸艺术", @"彩色玻璃工艺", @"彩虹箔", @"X光", @"磨砂玻璃", @"玻璃渐变", @"铜版雕刻", @"液态金属", @"毛毡风格", @"充气效果", @"铝制", @"亚克力质感"];
    
    return array;
}

/// 渲染
- (NSArray *)_getRenderData {
    NSArray *array = @[@"Octane", @"虚幻引擎", @"C4D", @"Blender"];
    
    return array;
}


/// 色彩
- (NSArray *)_getColorsData {
    NSArray *array = @[@"莫兰迪色调", @"荧光色", @"互补色", @"柔和色彩"];
    
    return array;
}


/// 构图
- (NSArray *)_getCompositionOfPictureData {
    NSArray *array = @[@"等距视图", @"对称结构", @"Knolling", @"3D平面图"];
    
    return array;
}


/// 视角
- (NSArray *)_getVisualAngleData {
    NSArray *array = @[@"微距镜头", @"超广角镜头", @"长焦镜头", @"仰视视角", @"俯视视角"];
    
    return array;
}


@end
