//
//  TWGlobalVC.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "TWGlobalVC.h"
#import <YBImageBrowser/YBImageBrowser.h>

@interface TWGlobalVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSDictionary *Image_obj;

@end

@implementation TWGlobalVC

+ (TWGlobalVC *)shared {

    static TWGlobalVC *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TWGlobalVC alloc] init];
    });
    
    return instance;
}

- (void)twAaction_setRootViewController {
    
    if ([[SAVE_UDF objectForKey:@"login"] intValue] != 1) {
        TWYinDaoPageViewController *ydVC = [[TWYinDaoPageViewController alloc] init];
        TWBaseNavViewController *nav = [[TWBaseNavViewController alloc] initWithRootViewController:ydVC];
        [self.keywindow setRootViewController:nav];
    }
    else {
        TWBaseTabBarViewController *tabBarController = TWBaseTabBarViewController.new;
        [self.keywindow setRootViewController:tabBarController];
    }
}

- (void)twAction_enterVIPViewController {
    
    TWVipViewController *vipVC = [[TWVipViewController alloc] init];
    [GlobalVC.base_nav pushViewController:vipVC animated:YES];
    
}

- (BOOL)IsNullString:(NSString *)string
{
    string = [NSString stringWithFormat:@"%@",string];
    if (![string isKindOfClass:[NSString class]]
        ||string == nil
        || [string isEqualToString:@"null"]
        || [string isEqualToString:@"<null>"]
        || [string isEqualToString:@"(null)"]
        || [string isEqualToString:@""])
    {
        return YES;
    }
    return  NO ;
}

/**
 字典转json格式字符串：
 */
- (NSString *)tw_dictionaryToJson:(id)target_object {   //NSJSONWritingPrettyPrinted  是有换位符的。
    //如果NSJSONWritingPrettyPrinted 是nil 的话 返回的数据是没有 换位符的
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:target_object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)tw_pasteboard:(NSString *)content {
    
    if ([self IsNullString:content]) {
        [SVProgressHUD showErrorWithStatus:@"复制内容不能为空！"];
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
    [SVProgressHUD showSuccessWithStatus:@"复制成功！"];
}

/**
 计算内容的高度
 */
- (CGFloat)tw_textContentHeightForText:(NSString *)text
                              andWidth:(CGFloat)width {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0]};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
    return size.height;
}


- (NSString *)tw_systemDeviceID {
    NSString *udid = objc_getAssociatedObject([UIDevice currentDevice], _cmd);
    if (udid == nil) {
        static NSString *service = @"DEVICE_UDID_TaoWu";
        static NSString *account = @"DEVICE_CURRENT_TaoWu";
        udid = [SAMKeychain passwordForService:service account:account];
        if (udid == nil) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef string = CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
            udid = (__bridge_transfer NSString *)string;
            [SAMKeychain setPassword:udid forService:service account:account];
        }
        objc_setAssociatedObject([UIDevice currentDevice], _cmd, udid, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return [NSString stringWithFormat:@"TaoWu_%@",udid];
}

/**
 检测网络状态
 */
- (void)tw_detectingNetworkStatus {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSLog(@"设备已连接到网络");
        } else {
            NSLog(@"设备未连接到网络");
        }
    }];

    [task resume];
}

/**
 获取当前标识符
 */
- (NSString *)tw_getCurrentUniqueIdentifier {
    NSDate*date=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString*timeStr=[NSString stringWithFormat:@"%@_%.0f",[self tw_systemDeviceID],time];
    return timeStr;
}

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
            withEndPoint:(CGPoint)endPoint {

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;

    gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];

    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.08, 0.11); // 左上角
    gradientLayer.endPoint = CGPointMake(0.93, 0.88); // 右下角
    
    return gradientLayer;
}

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
            withLastType:(BOOL)lastType {
    
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    [param setValue:content forKey:@"prompt"];
    [param setValue:identifier forKey:@"uid"];
    
    
    if (type.length > 3) {
        [param setValue:type forKey:@"aiTypeId"];
    }
    
    
    [param setValue:@(0) forKey:@"modelType"]; /// 文字是0、语音是1
    
    if (lastType == YES) {
        [param setValue:@"1" forKey:@"lastType"];
    }
    
    if (![type isEqualToString:@"1"]) {
        [param setObject:@"2" forKey:@"modelId"];
    }else {
        /// 1、基础版   2、高级版,助理、创作默认位高级
        if (self.isMode) {
            [param setObject:@"2" forKey:@"modelId"];
        }
        else {
            [param setObject:@"1" forKey:@"modelId"];
        }
    }
    
    [HttpClient postUrl:@"/ai/aiChat" param:param success:^(id  _Nonnull json) {
            
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
 
 获取用户资料
 
 */
- (void)tw_getUserInfo {
    
    [SVProgressHUD show];
    [HttpClient postUrl:@"/app/user/getCurrentInfo" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
           
        NSDictionary *data = [json objectForKey:@"data"];
        [SAVE_UDF setValue:data[@"vipStatus"] forKey:@"vipStatus"];
        
        self.points_total = [[data objectForKey:@"imgNum"] intValue];
        
        self.vipLabel = [[data objectForKey:@"vipLabel"] intValue];
        
        self.vipTime = [data objectForKey:@"vipExpireTime"];
        
#if DEBUG
        [SAVE_UDF setValue:@"0" forKey:@"vipStatus"];
#endif
        [self tw_getAliyunToken];
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
}

/**
 
 获取阿里云语音token
 
 */
- (void)tw_getAliyunToken {
    
    [HttpClient postUrl:@"/app/getAliyunToken" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
           
        NSString *data = [json objectForKey:@"data"];
        [SAVE_UDF setValue:data forKey:@"aliyunToken"];
        
        [[TWSpeechSynthesisManager sharedManager] initNuiTts];
        
        [self tw_getUserFreeUseNumber];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

/**
 
 获取好评后赠送次数
 
 */
- (void)tw_getGoodCommentNumber {
    
    [HttpClient postUrl:@"/app/getGoodSum" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
           
        NSInteger data = [[json objectForKey:@"data"] intValue];
        [SAVE_UDF setValue:@(data) forKey:@"goodSum"];
        
        [self tw_commentStatus];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

/**
 
 获取免费使用次数
 
 */
- (void)tw_getUserFreeUseNumber {
    
    [HttpClient postUrl:@"/app/getSum" param:NSMutableDictionary.dictionary success:^(id  _Nonnull json) {
           
        self.numberTimes = [[json objectForKey:@"data"] intValue];
        [SAVE_UDF setValue:@(self.numberTimes) forKey:@"freeSum"];
        
        [self tw_getGoodCommentNumber];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
 
 是否可以免费使用
 
 */
- (BOOL)tw_whetherCanUsedFree {
    
    NSInteger useSum = [[SAVE_UDF objectForKey:@"useTimes"] intValue]; /// 使用次数
    
    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] == 1) { /// 用户为会员
        [SAVE_UDF setValue:@(useSum + 1) forKey:@"useTimes"];
        return YES;
    }
    else {
        
        if (self.isMode == YES) {
            return NO;
        }
        
        if (useSum >= self.numberTimes) { /// 免费次数已用完
            return NO;
        }
        [SAVE_UDF setValue:@(useSum + 1) forKey:@"useTimes"];
    }
    
    return YES;
}

/**
 是否需要弹出窗口
 */
- (void)tw_commentStatus {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [HttpClient postUrl:@"/app/switchIs" param:param success:^(id  _Nonnull json) {
        
        self.Off = [json[@"data"] intValue];
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

/**
 获取绘画中的图片
 */
- (void)tw_seekCurrentImages:(NSString *)imageId {
  
    WS(weakSelf)
    NSMutableDictionary *param = NSMutableDictionary.dictionary;
    [param setValue:imageId forKey:@"taskId"];
    [HttpClient postUrl:@"/img/findImg" param:param success:^(id  _Nonnull json) {
        
        weakSelf.Image_obj = [json objectForKey:@"data"];
        
        if ([[weakSelf.Image_obj objectForKey:@"taskType"] intValue] == 2) {
            [NSNotificationCenter.defaultCenter postNotificationName:@"reloadHistoryImagesNotificationName" object:nil userInfo:[json objectForKey:@"data"]];
            
            [weakSelf tw_judgeCurrentController];
        }
        
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)tw_getImageProgress {
    if ([[self.Image_obj objectForKey:@"taskType"] intValue] != 2) {
        [self performSelector:@selector(tw_getImageProgress) afterDelay:5.01];
        [self tw_seekCurrentImages:self.ImageId];
    }
    
    
}


#pragma mark - 选择图片 -
/**
 打开相册获取图片
 
 */
- (void)tw_openPhotoAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.base_nav presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    
    if (self.choosePhotoBlock) {
        self.choosePhotoBlock(selectedImage);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 获取指定View的图片
 */
- (UIImage *)tw_captureImageFromViewLow:(UIView *)orgView {
    
    UIGraphicsBeginImageContextWithOptions(orgView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [orgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 保存图片到相册
 */
- (void)tw_saveImageToPhoto:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


// 保存完成后的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"图片保存失败"];
        NSLog(@"：%@", error.localizedDescription);
    } else {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }
}

/**
 展示图片
 */
- (void)tw_showActionImageWithURLs:(NSArray<NSString *> *)imageURLs
                             index:(NSInteger)index
                            sender:(id)sender {
    
    if (!imageURLs.count || index < 0 || index >= imageURLs.count) {
        return;
    }
    NSMutableArray *datas = NSMutableArray.new;
    [imageURLs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {    YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:obj];
        data.projectiveView = sender;
        [datas addObject:data];
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    [browser setDataSourceArray:datas];
    [browser setCurrentPage:index];
    [browser show];
}


/**
 加载 Gif
 */
- (UIImage *)tw_loadingGifImage {
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"Ellipsis" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    UIImage *gifImage = [UIImage sd_imageWithGIFData:gifData];
    return gifImage;
}


/**
 判断是否在特定页面，如果不在，就弹出提示框
 */
- (void)tw_judgeCurrentController {
    UIViewController *topViewController = self.base_nav.topViewController;
    
    if ([topViewController isKindOfClass:[TWResultViewController class]]) {
        NSLog(@"当前属于 TWResultViewController");
    }else if ([topViewController isKindOfClass:[TWPaintHistoryViewController class]]) {
        NSLog(@"当前属于 TWPaintHistoryViewController");
        
    }  else {
        [self _alertPopupDialogBox];
        NSLog(@"当前不属于任何特定的控制器");
    }
}

- (void)_alertPopupDialogBox {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的图片已经生成，请点击查看。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.base_nav pushViewController:TWPaintHistoryViewController.new animated:YES];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];

    [self.base_nav presentViewController:alert animated:YES completion:nil];
}


@end
