//
//  TWNewZhuliViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/14.
//

#import "TWNewZhuliViewController.h"
#import "TWSelectAvatarViewController.h"

@interface TWNewZhuliViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *tw_avatar_image;
@property (weak, nonatomic) IBOutlet UITextField *tw_name_label;
@property (weak, nonatomic) IBOutlet UILabel *tw_placeholder_label;
@property (weak, nonatomic) IBOutlet UITextView *tw_desc_textView;

@property (nonatomic, copy) NSString *avatar_string;
@property (nonatomic, copy) NSString *tw_dictValue;

@end

@implementation TWNewZhuliViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建助理";
}

- (IBAction)tw_sureButtonAction:(id)sender {
    
    if ([GlobalVC IsNullString:self.tw_name_label.text]) {
        [SVProgressHUD showErrorWithStatus:@"助理名称不能为空！"];
        return;
    }
    
    if ([GlobalVC IsNullString:self.tw_desc_textView.text]) {
        [SVProgressHUD showErrorWithStatus:@"助理描述不能为空！"];
        return;
    }
    
    if ([GlobalVC IsNullString:self.avatar_string]) {
        [SVProgressHUD showErrorWithStatus:@"请添加助理图片！"];
        return;//NBA球员资料、数据、历史地位
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.tw_dictValue forKey:@"createType"];
    [param setValue:self.tw_name_label.text forKey:@"aiName"];
    [param setValue:self.tw_desc_textView.text forKey:@"aiBrief"];
    [param setValue:self.tw_desc_textView.text forKey:@"aiDetails"];
    [param setValue:self.avatar_string forKey:@"headUrl"];
    [param setValue:@"1" forKey:@"aiType"];
    
    
    [HttpClient postUrl:@"/ai/addAi" param:param success:^(id  _Nonnull json) {
            
        [SVProgressHUD showSuccessWithStatus:@"新建助理成功！"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (IBAction)tw_choosePhotoAction:(id)sender {
    [self.view endEditing:YES];
    
    TWSelectAvatarViewController *avatarVC = [[TWSelectAvatarViewController alloc] init];
    
    WS(weakSelf)
    avatarVC.selectAvatarBlock = ^(NSString * _Nonnull avatar) {
        weakSelf.avatar_string = avatar;
        [weakSelf.tw_avatar_image sd_setImageWithURL:LoadingImageUrl(avatar)];
    };
    
    [self.navigationController pushViewController:avatarVC animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([GlobalVC IsNullString:self.tw_desc_textView.text]) {
        self.tw_placeholder_label.text = @"例如：假如你是一位米其林餐厅的经理，请为[西红柿炒鸡蛋]这道菜想一个创意菜品名及菜品简介。";
    }
    else {
        self.tw_placeholder_label.text = @"";
    }
}

@end
