//
//  TWCustomStyleView.h
//  TaoWu
//
//  Created by JJK on 2023/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWCustomStyleViewDelegate <NSObject>

- (void)tw_selectCustomStyleView:(NSString *)type_name;

@end

@interface TWCustomStyleView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTragt:(id)tragt;

@property (nonatomic, weak) id<TWCustomStyleViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
