//
//  TWGlobalVC.h
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWGlobalVC : NSObject

@property (nonatomic, strong) UIWindow *keywindow;

@property (nonatomic,weak) UINavigationController *base_nav;

@property (nonatomic, assign) BOOL isMode; /// 选择不同的模式，YES：高级模式   NO：基础模式

@property (nonatomic, assign) NSInteger points_total;   /// 积分消耗

@property (nonatomic, assign) NSInteger vipLabel; ///  判断用户是否有权限绘画 1、5无权限

@property (nonatomic, copy) NSString *vipTime; 

@property (nonatomic, assign) NSInteger Off;

@property (nonatomic, assign) NSInteger numberTimes;

@property (nonatomic, assign) NSInteger sandboxTest; //1、沙盒环境  0、生成环境

@property (nonatomic, copy) NSString *ImageId;

@property (nonatomic, strong) void(^choosePhotoBlock)(UIImage *selectImage);

+ (TWGlobalVC *)shared;

- (NSString *)tw_systemDeviceID;

- (void)twAaction_setRootViewController;

/**
 进入会员页
 */
- (void)twAction_enterVIPViewController;

- (BOOL)IsNullString:(NSString *)string;

/**
 字典转json格式字符串：
 */
- (NSString*)tw_dictionaryToJson:(id)target_object;

/**
 复制当前内容
 */
- (void)tw_pasteboard:(NSString *)content;

/**
 计算内容的高度
 @param text 当前内容
 @param width 输入框的宽度
 */
- (CGFloat)tw_textContentHeightForText:(NSString *)text
                              andWidth:(CGFloat)width;

/**
 检测网络状态
 */
- (void)tw_detectingNetworkStatus;

/**
 获取当前标识符
 */
- (NSString *)tw_getCurrentUniqueIdentifier;

/**
 设置view的渐变色
 
 @param frame 当前接口
 @param startColor 起始颜色
 @param endColor 结束颜色
 @param startPoint 左上角
 @param endPoint 右下角
 
 */
- (CAGradientLayer *)tw_gradientLayer:(CGRect)frame
          withStartColor:(UIColor *)startColor
            withEndColor:(UIColor *)endColor
          withStartPoint:(CGPoint)startPoint
            withEndPoint:(CGPoint)endPoint;

#pragma mark -- 通用接口 --
/**
 socket连接成功之后向服务端发起请求
 
 @param identifier 本条消息的唯一标识
 @param content 询问的内容
 @param type 询问的类型
 @param lastType 是否为第一条内容
 
 */
- (void)tw_connentServer:(NSString *)identifier
             withContent:(NSString *)content
            withChatType:(NSString *)type
            withLastType:(BOOL)lastType;

/**
 获取绘画中的图片
 */
- (void)tw_getImageProgress;

/**
 
 获取用户资料
 
 */
- (void)tw_getUserInfo;

/**
 
 获取阿里云语音token
 
 */
- (void)tw_getAliyunToken;


/**
 
 获取好评后赠送次数
 
 */
- (void)tw_getGoodCommentNumber;

/**
 
 获取免费使用次数
 
 */
- (void)tw_getUserFreeUseNumber;

/**
 
 是否可以免费使用
 
 */
- (BOOL)tw_whetherCanUsedFree;

/**
 是否需要弹出窗口
 */
- (void)tw_commentStatus;


/**
 
 打开相册获取图片
 
 */
- (void)tw_openPhotoAlbum;

/**
 获取指定View的图片
 */
- (UIImage *)tw_captureImageFromViewLow:(UIView *)orgView;

/**
 保存图片到相册
 */
- (void)tw_saveImageToPhoto:(UIImage *)image;

/**
 展示图片
 */
- (void)tw_showActionImageWithURLs:(NSArray<NSString *> *)imageURLs
                             index:(NSInteger)index
                            sender:(id)sender;

/**
 加载 Gif
 */
- (UIImage *)tw_loadingGifImage;

@end

NS_ASSUME_NONNULL_END
