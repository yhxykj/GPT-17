//
//  TWCZEditorTableViewCell.m
//  TaoWu
//
//  Created by JJK on 2023/12/20.
//

#import "TWCZEditorTableViewCell.h"
#import "TWCZEditorCollectionViewCell.h"

@interface TWCZEditorTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionView;
@property (weak, nonatomic) IBOutlet UILabel *cell_name_label;

@property (nonatomic, strong) NSArray *text_array;
@property (nonatomic, assign) NSInteger tw_selectIndex;

@end

@implementation TWCZEditorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(5, 15, 5, 15)];
    [layout setMinimumLineSpacing:15];
    [layout setMinimumInteritemSpacing:15];
    
    [self.tw_collectionView setDelegate:self];
    [self.tw_collectionView setDataSource:self];
    [self.tw_collectionView setCollectionViewLayout:layout];
    [self.tw_collectionView setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionView registerNib:[UINib nibWithNibName:@"TWCZEditorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"text_cell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tw_updateCellData:(NSDictionary *)param {
    
    self.text_array = [param objectForKey:@"content"];
    [self.cell_name_label setText:[param objectForKey:@"name"]];
    
    [self.tw_collectionView reloadData];
    
    self.tw_selectIndex = 100;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.text_array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    TWCZEditorCollectionViewCell *cell;
    
    if (collectionView == self.tw_collectionView) {
        
        NSString *name_string = self.text_array[indexPath.row];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text_cell" forIndexPath:indexPath];
        
        [cell.cell_name_label setTextColor:UIColorFromRGB(0x9A9A9A)];
        [cell.cell_bg_image setImage:SetImage(@"cz_white_n")];
        [cell.cell_name_label setText:name_string];
        
        if (self.tw_selectIndex == indexPath.row) {
            [cell.cell_bg_image setImage:SetImage(@"cz_green_s")];
            [cell.cell_name_label setTextColor:UIColorFromRGB(0xFFFFFF)];
        }
        
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-108)/3, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content_string = self.text_array[indexPath.row];
    
    if (collectionView == self.tw_collectionView) {
        self.tw_selectIndex = indexPath.row;
        [self.tw_collectionView reloadData];
    }
    [self.tw_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell_tWCZEditorTableViewCell:cellForContent:)]) {
        [self.delegate cell_tWCZEditorTableViewCell:self.cell_name_label.text cellForContent:content_string];
    }
}

@end
