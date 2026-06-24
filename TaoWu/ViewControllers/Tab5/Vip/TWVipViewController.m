//
//  TWVipViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/12.
//

#import "TWVipViewController.h"
#import "TWVipCollectionViewCell.h"
#import "TWVipPointsCollectionViewCell.h"

@interface TWVipViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIScrollView *tw_bigScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tw_topLayout;
@property (weak, nonatomic) IBOutlet UIImageView *tw_selectImage;
@property (weak, nonatomic) IBOutlet UIImageView *tw_itemImage;
@property (weak, nonatomic) IBOutlet UICollectionView *tw_collectionview;
@property (weak, nonatomic) IBOutlet UILabel *tw_hy_label;
@property (nonatomic, strong) TWGiveStarsView *tw_starView;

@property (nonatomic, assign) BOOL isPoints; // 是否为积分
@property (nonatomic, assign) NSInteger tw_selectIndex;
@property (nonatomic, strong) NSArray *tw_listArray;
@property (nonatomic, strong) NSArray *tw_pointsArray;
@property (nonatomic, copy) NSString *tw_iosID;
@property (nonatomic, copy) NSString *tw_orderID;

@end

@implementation TWVipViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:UIColor.clearColor];
    
    [self.tw_topLayout setConstant:TWStatusBarHeight() + 44];
    
    self.tw_bigScrollView.bounces = NO;
//    [self.tw_bigScrollView setContentSize:CGSizeMake(0, 844)];
    [self.tw_bigScrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    
    [self tw_getPayTablelist];
    [self tw_getPoints];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(5, 16, 5, 16)];
    [layout setMinimumLineSpacing:12];
    [layout setMinimumInteritemSpacing:12];
    
    [self.tw_collectionview setCollectionViewLayout:layout];
    [self.tw_collectionview setBackgroundColor:UIColor.clearColor];
    [self.tw_collectionview registerNib:[UINib nibWithNibName:@"TWVipCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWVipCollectionViewCellID"];
    
    [self.tw_collectionview registerNib:[UINib nibWithNibName:@"TWVipPointsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"points_cell"];
    
    self.tw_starView = [[TWGiveStarsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tw_starView];
    self.tw_starView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    if (GlobalVC.vipLabel == 1) {
        [self.tw_hy_label setText:@"你已开通月会员"];
    }
    else if (GlobalVC.vipLabel == 5) {
        [self.tw_hy_label setText:@"你已开通周会员"];
    }
    else if (GlobalVC.vipLabel == 4) {
        [self.tw_hy_label setText:@"你已开通年会员"];
    }
    else if (GlobalVC.vipLabel == 6) {
        [self.tw_hy_label setText:@"你已开通终身会员"];
    }

    GlobalVC.sandboxTest = 0;
    
}


- (IBAction)tw_dissmissAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)tw_recoverAction:(id)sender {
    [SVProgressHUD showWithStatus:@"订单恢复中，请等待……"];
    [TWPayPalSdk.shared tw_RestoreOrder];
}

- (IBAction)tw_chooseItemsAction:(UIButton *)sender {
    if (sender.tag == 301) {
        [self.tw_selectImage setImage:SetImage(@"hy_xd_bg")];
        [self.tw_itemImage setImage:SetImage(@"hy_item")];
        self.isPoints = NO;
    }
    else {
        [self.tw_selectImage setImage:SetImage(@"hy_xd_jfbg")];
        [self.tw_itemImage setImage:SetImage(@"hy_jf_item")];
        self.isPoints = YES;
    }
    self.tw_selectIndex = 0;
    [self.tw_collectionview reloadData];
    [self.tw_collectionview setContentOffset:CGPointMake(0, 0)];
}

- (IBAction)tw_openVipAction:(id)sender {
    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1 && self.isPoints == NO) {
        [SVProgressHUD showErrorWithStatus:@"您已经开通会员了！"];
        return;
    }

    [self tw_createNewOrder];
    
}

- (IBAction)tw_selectPricyAndAgreementAndServiceAction:(UIButton *)sender {
    if (sender.tag == 301) {
        TWPrivacyViewController *webVC = [[TWPrivacyViewController alloc] init];
        webVC.web_type = @"隐私协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if (sender.tag == 302) {
        TWPrivacyViewController *webVC = [[TWPrivacyViewController alloc] init];
        webVC.web_type = @"用户协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else {
        TWPrivacyViewController *webVC = [[TWPrivacyViewController alloc] init];
        webVC.web_type = @"连续包月服务";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 获取支付列表
 */
- (void)tw_getPayTablelist {
    WS(weakSelf)
    [HttpClient postUrl:@"/app/meal/getVipMeal" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
        
        weakSelf.tw_listArray = [json objectForKey:@"data"];
        [weakSelf.tw_collectionview reloadData];
        
        if (weakSelf.tw_listArray.count > 0) {
            NSDictionary *param = weakSelf.tw_listArray[0];
            weakSelf.tw_iosID = [param objectForKey:@"iosId"];
            weakSelf.tw_orderID = [param objectForKey:@"id"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
 获取积分
 */
- (void)tw_getPoints {
    
    WS(weakSelf)
    [HttpClient postUrl:@"/app/meal/getTicketMeal" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
        
        weakSelf.tw_pointsArray = [json objectForKey:@"data"];
        [weakSelf.tw_collectionview reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


/**
 生成订单
 */
- (void)tw_createNewOrder {
    [SVProgressHUD showWithStatus:@"下单中，请稍等……"];
    
    WS(weakSelf)
    NSString *url = [NSString stringWithFormat:@"/app/order/create/%@",self.tw_orderID];
    NSMutableDictionary *obj = NSMutableDictionary.new;
    [HttpClient postUrl:url param:obj success:^(id  _Nonnull json) {
        
        if([json[@"code"] intValue] == 200) {
            [weakSelf tw_appleSdkCreateOrder:json[@"data"]];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"订单创建失败!"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)tw_appleSdkCreateOrder:(NSString *)order_ID {
    [SVProgressHUD showWithStatus:@"购买中，请稍等……"];
    
    [TWPayPalSdk.shared tw_PayPalSdkID:self.tw_iosID completeHandle:^(PayPalStatusType type, NSData * _Nonnull data, NSString * _Nonnull transaction_id) {
        NSString *receipt = [data base64EncodedStringWithOptions:0];
        
        if (data != nil) {
            [SVProgressHUD dismiss];
            if (self) {
                NSMutableDictionary *param = NSMutableDictionary.dictionary;
                [param setValue:self.tw_iosID forKey:@"productId"];
                [param setValue:order_ID forKey:@"orderNo"];
                [param setValue:receipt forKey:@"receipt"];
                [param setValue:transaction_id forKey:@"transactionId"];
                [param setValue:SystemType forKey:@"type"];
                [param setValue:@(GlobalVC.sandboxTest) forKey:@"sandboxTest"];
                [self tw_confirmOrderPurchaseStatus:param];
            }
        }
        else {
            [SVProgressHUD dismiss];
        }
        
    }];
}

- (void)tw_confirmOrderPurchaseStatus:(NSMutableDictionary *)param {
    
    WS(weakSelf)
    [SVProgressHUD showWithStatus:@"订单校验中，请稍等……"];
    [HttpClient postUrl:@"/app/order/ios/verify" param:param success:^(id  _Nonnull json) {
            
        if([json[@"code"] intValue] == 200) {
            
            [GlobalVC tw_getUserInfo];
            
            if (weakSelf.isPoints) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
            else {
                [SAVE_UDF setValue:@"1" forKey:@"vipStatus"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"订单校验失败!"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isPoints) {
        return self.tw_pointsArray.count;
    }
    return self.tw_listArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (self.isPoints) {
        TWVipPointsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"points_cell" forIndexPath:indexPath];
        [cell cell_updateCellData:self.tw_pointsArray[indexPath.row]];
        NSDictionary *param = self.tw_pointsArray[indexPath.row];
        
        [cell.tw_cell_image setImage:SetImage(@"hy_normal")];
        if (indexPath.row == self.tw_selectIndex) {
            [cell.tw_cell_image setImage:SetImage(@"hy_s")];
            
            self.tw_iosID = [param objectForKey:@"iosId"];
            self.tw_orderID = [param objectForKey:@"id"];
            
        }
        return cell;
    }
    else {
        TWVipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWVipCollectionViewCellID" forIndexPath:indexPath];
        [cell cell_updateCellData:self.tw_listArray[indexPath.row]];
        NSDictionary *param = self.tw_listArray[indexPath.row];
        
        [cell.tw_cell_image setImage:SetImage(@"hy_normal")];
        if (indexPath.row == self.tw_selectIndex) {
            [cell.tw_cell_image setImage:SetImage(@"hy_s")];
            
            self.tw_iosID = [param objectForKey:@"iosId"];
            self.tw_orderID = [param objectForKey:@"id"];
            
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(104, 120);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.tw_selectIndex = indexPath.row;
    [self.tw_collectionview reloadData];
    [self.tw_collectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.isPoints == NO) {
        NSDictionary *obj = self.tw_listArray[indexPath.row];
//        if ([[obj objectForKey:@"remark"] isEqualToString:@"1"]) {//月
//            self.tw_itemImage.image = SetImage(@"hy_is_item");
//        }
//        else if ([[obj objectForKey:@"remark"] isEqualToString:@"5"]) {//周
//            self.tw_itemImage.image = SetImage(@"hy_is_item");
//        }
//        else {
//            self.tw_itemImage.image = SetImage(@"hy_item");
//        }
        
    }
    
}


@end
