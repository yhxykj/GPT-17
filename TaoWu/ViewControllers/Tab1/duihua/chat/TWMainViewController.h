//
//  TWMainViewController.h
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *tw_inputView;
@property (weak, nonatomic) IBOutlet UILabel *tw_label;
@property (weak, nonatomic) IBOutlet UITextView *tw_textView;
@property (weak, nonatomic) IBOutlet UIButton *tw_fs_button;
@property (weak, nonatomic) IBOutlet UIImageView *tw_bgImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;

@property (nonatomic, assign) BOOL isdefault; //是否为默认聊天
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *tw_describle_string;

@end

NS_ASSUME_NONNULL_END

