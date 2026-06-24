//
//  TWAdvancedViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TWAdvancedViewController.h"
#import "TWCustomStyleView.h"
#import "TWShowAllStypeView.h"

@interface TWAdvancedViewController ()<UITextViewDelegate,TWCustomStyleViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *tw_scrollView;
@property (weak, nonatomic) IBOutlet UIView *tw_fg_view;
@property (weak, nonatomic) IBOutlet UILabel *tw_place_label;
@property (weak, nonatomic) IBOutlet UITextView *tw_desc_textView;
@property (weak, nonatomic) IBOutlet UITextField *tw_sum_textField;
@property (weak, nonatomic) IBOutlet UIView *tw_sizeView;
@property (weak, nonatomic) IBOutlet UIButton *tw_jian_button;
@property (weak, nonatomic) IBOutlet UIButton *tw_add_button;
@property (weak, nonatomic) IBOutlet UITextField *tw_style_text;
@property (weak, nonatomic) IBOutlet UILabel *tw_done_label;

@property (nonatomic, strong) TWCustomStyleView *styleView;
@property (nonatomic, strong) TWShowAllStypeView *showAllView;
@property (nonatomic, strong) TWPonitsView *tw_pointsView;
@property (nonatomic, assign) NSInteger tw_point;

@property (nonatomic, copy) NSString *tw_imageSize;
@property (nonatomic, copy) NSString *custom_text;
@property (nonatomic, copy) NSString *select_type_string; /// 选择的咒语书
@property (nonatomic, strong) NSMutableArray *desc_array;

@end

@implementation TWAdvancedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.desc_array = NSMutableArray.array;
    
    self.styleView = [[TWCustomStyleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 188) withTragt:self];
    [self.tw_fg_view addSubview:self.styleView];
    self.styleView.sd_layout.leftSpaceToView(self.tw_fg_view, 0).topSpaceToView(self.tw_fg_view, 0).rightSpaceToView(self.tw_fg_view, 0).widthIs(kScreenWidth).bottomSpaceToView(self.tw_fg_view, 0);
    
    
    self.showAllView = [[TWShowAllStypeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    [GlobalVC.keywindow addSubview:self.showAllView];
    
    self.tw_pointsView = [[TWPonitsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [GlobalVC.keywindow addSubview:self.tw_pointsView];
    self.tw_pointsView.alpha = 0.0;
    self.tw_point = 40;
    
    WS(weakSelf)
    self.showAllView.addStypeSuccessBlock = ^(NSString * _Nonnull style) {
        
        if (style.length > 0) {
            [weakSelf.desc_array addObject:style];
            weakSelf.tw_style_text.text = [weakSelf.desc_array componentsJoinedByString:@","];
        }
        
        else if (style.length == 0 && weakSelf.select_type_string.length > 0) {
            [weakSelf.desc_array removeObject:weakSelf.select_type_string];
            weakSelf.tw_style_text.text = [weakSelf.desc_array componentsJoinedByString:@","];
            weakSelf.select_type_string = @"";
        }
        else {
            
        }
        
        weakSelf.select_type_string = style;
        
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    self.tw_imageSize = @"1";
    
}

- (void)textFieldDidChange:(NSNotification *)notification {
    NSLog(@"%@",notification.object);
}


- (IBAction)tw_chooseDecribleAction:(UIButton *)sender {
    self.tw_desc_textView.text = @"";
    self.tw_place_label.text = @"";
    if (sender.tag == 201) {
        self.tw_desc_textView.text = @"可爱萌宠";
    }
    if (sender.tag == 202) {
        self.tw_desc_textView.text = @"百变御姐";
    }
    if (sender.tag == 203) {
        self.tw_desc_textView.text = @"帅气霸总";
    }
}

- (IBAction)tw_seekAllStypeAction:(id)sender {
    [self.showAllView _showAllStypeView];
}

- (IBAction)tw_jianOneAction:(id)sender {
    NSInteger sum = [self.tw_sum_textField.text intValue] - 1;
    
    [self tw_getAddAndJianStatus:sum];
}

- (IBAction)tw_addOneAction:(UIButton *)sender {
    NSInteger sum = [self.tw_sum_textField.text intValue] + 1;
    [self tw_getAddAndJianStatus:sum];
}

- (IBAction)tw_chooseSizeAction:(UIButton *)sender {
    int i = 0;
    NSArray *sizes = @[@{@"normal":@"cc_one",@"select":@"cc_one_s"},@{@"normal":@"cc_four",@"select":@"cc_four_s"},@{@"normal":@"cc_five",@"select":@"cc_five_s"}];
    
    for (UIView *obj in self.tw_sizeView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            
            NSDictionary *dic = sizes[i];
            
            UIButton *button = (UIButton *)obj;
            [button setImage:SetImage([dic objectForKey:@"normal"]) forState:UIControlStateNormal];
            if (button == sender) {
                [button setImage:SetImage([dic objectForKey:@"select"]) forState:UIControlStateNormal];
            }
            i++;
        }
    }
}

- (IBAction)tw_sureButtonAction:(UIButton *)sender {
    
    if (GlobalVC.vipLabel == 1 || GlobalVC.vipLabel == 5 || GlobalVC.vipLabel == 0) {
        [SVProgressHUD showErrorWithStatus:@"年会员和永久会员才有绘画权限哟！"];
        return;
    }
    
    if (GlobalVC.points_total < self.tw_point) {
        [self.tw_pointsView _showImageView];
        return;
    }
    
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    
    if ([GlobalVC IsNullString:self.tw_desc_textView.text]) {
        [SVProgressHUD showErrorWithStatus:@"描述不能为空！"];
        return;
    }
    
    if ([self.tw_sum_textField.text intValue] < 1) {
        [SVProgressHUD showErrorWithStatus:@"生成张数不能小于 1 ！"];
        return;
    }
    
    if ([self.tw_sum_textField.text intValue] > 4) {
        [SVProgressHUD showErrorWithStatus:@"生成张数不能大于 4 ！"];
        return;
    }
    
    if ([GlobalVC IsNullString:self.tw_imageSize]) {
        [SVProgressHUD showErrorWithStatus:@"请选择尺寸！"];
        return;
    }
    
    NSString *_prompt = [NSString stringWithFormat:@"%@,%@",self.tw_desc_textView.text,self.tw_style_text.text];
    
    [param setValue:self.tw_imageSize forKey:@"resultConfig"];
    [param setValue:_prompt forKey:@"prompt"];
    [param setValue:@"2" forKey:@"taskParameter"];
    [param setValue:self.tw_sum_textField.text forKey:@"sum"];
    
    TWResultViewController *resultVC = [[TWResultViewController alloc] init];
    resultVC.tw_param = param;
    resultVC.count = [self.tw_sum_textField.text intValue];
    [self.navigationController pushViewController:resultVC animated:YES];
}


- (void)tw_getAddAndJianStatus:(NSInteger)sum {
    if (sum >= 4) {
        [self.tw_add_button setEnabled:NO];
        [self.tw_add_button setImage:SetImage(@"jc_add") forState:UIControlStateNormal];
    }
    else {
        [self.tw_add_button setEnabled:YES];
        [self.tw_add_button setImage:SetImage(@"jc_add_s") forState:UIControlStateNormal];
    }
    
    if (sum <= 1) {
        [self.tw_jian_button setEnabled:NO];
        [self.tw_jian_button setImage:SetImage(@"jc_jian") forState:UIControlStateNormal];
    }
    else {
        [self.tw_jian_button setEnabled:YES];
        [self.tw_jian_button setImage:SetImage(@"jc_jian_s") forState:UIControlStateNormal];
    }
    if (sum < 1 || sum > 4) {
        return;
    }
    [self.tw_sum_textField setText:[NSString stringWithFormat:@"%ld",sum]];
    [self.tw_done_label setText:[NSString stringWithFormat:@"立即生成 消耗%ld积分",sum*40]];
    self.tw_point = sum*40;
}

#pragma mark - UITextViewDelegate -
- (void)textViewDidChange:(UITextView *)textView {
    if ([GlobalVC IsNullString:self.tw_desc_textView.text]) {
        self.tw_place_label.text = @"描述词越详细，出现的画面越准确越精美，例如：中国山水图远山，绝美少妇，中式仿古纱白裙，魏晋风格，中国传统发型，清澈的河流，古建筑，飞鸟，云雾，绚丽的光线。";
    }
    else {
        self.tw_place_label.text = @"";
    }
}

#pragma mark - TWCustomStyleViewDelegate -

- (void)tw_selectCustomStyleView:(NSString *)type_name {
    
    if ([self.desc_array containsObject:type_name]) {
        [self.desc_array removeObject:type_name];
    }
    else {
        [self.desc_array addObject:type_name];
    }
    
    self.tw_style_text.text = [self.desc_array componentsJoinedByString:@","];
}

@end
