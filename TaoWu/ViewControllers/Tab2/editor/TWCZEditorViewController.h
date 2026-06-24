//
//  TWCZEditorViewController.h
//  TaoWu
//
//  Created by JJK on 2023/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWCZEditorViewController : UIViewController

@property (nonatomic, copy) NSString *tw_type;
@property (nonatomic, copy) NSString *tw_type_ID;

@property (weak, nonatomic) IBOutlet UIView *tw_sumView;
@property (strong, nonatomic) IBOutlet UIView *tw_big_sumView;

@end

NS_ASSUME_NONNULL_END
