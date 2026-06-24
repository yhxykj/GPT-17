//
//  TWUploadCommentController.m
//  TaoWu
//
//  Created by JJK on 2023/12/28.
//

#import "TWUploadCommentController.h"

@interface TWUploadCommentController ()
{
    
    __weak IBOutlet UIImageView *_addImage;
}
@end

@implementation TWUploadCommentController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    
}

- (IBAction)_addImageAction:(id)sender {
    [GlobalVC tw_openPhotoAlbum];
    
    WS(weakSelf)
    GlobalVC.choosePhotoBlock = ^(UIImage * _Nonnull selectImage) {
        _addImage.image = selectImage;
    };
}

- (IBAction)_doneAction:(id)sender {
    
    
    [SVProgressHUD showWithStatus:@"提交中，请等待……"];
    [self performSelector:@selector(_backAction) afterDelay:1.81];
    
    [SAVE_UDF setValue:@"1" forKey:@"isReviewed"];
    
    NSInteger count = [[SAVE_UDF objectForKey:@"goodSum"] intValue];
    NSInteger index = [[SAVE_UDF objectForKey:@"freeSum"] intValue];
    
    GlobalVC.numberTimes = count + index;
    
}

- (void)_backAction {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
