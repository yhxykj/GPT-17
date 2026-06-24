//
//  MacroHeadFile.h
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#ifndef MacroHeadFile_h
#define MacroHeadFile_h

#define API_BASE_URL @"https://jiaodelong.top/api"

#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"

#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

#define PassWord @"b5e5ca2ae0fc4028a61079dc21fe2ab6"

//阿里云一键登录
#define PNSATAUTHSDKINFOKEY @"ATAuthSDKInfoKey"

#define PNSATAUTHSDKINFO @"40qSsKF7EatCDiqX5uASI37v/LnKyIsN80i9u7O1FTz/3b1vgjsHqr9IdavZ9vogw1a7H27V6XlGmlRlpuCT9Cg5+9juk/lyhNlDz15H++vv7rLSFD1xxLDD2dQryaCgZ45WWULbmOF/Uh0DDYL+MtuNLQyzbXkJAEzLpdon+DIbCLyrACYHMuN3sWvZPTlMnjh7of5vdQHpu4TUE3mwoflGZn6SpHauWPRpnu3BMT005Cwcw3px/V0G/olYRelr9skjQPwEyaOVRF202oMDtg=="


#define SOCKET [TWSocketManager shareManager]

#define GlobalVC [TWGlobalVC shared]

#define HttpClient [TWAFHttpCustomClient shared]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define SAVE_UDF [NSUserDefaults standardUserDefaults]

/** 十六进制色值 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define K_BASE_INFO_KEY @"user"
#define K_BASE_INFO  [SAVE_UDF objectForKey:K_BASE_INFO_KEY]

/** 设置UIImage对象 */
#define SetImage(string) [UIImage imageNamed:(string)]
/** 图片url */
#define LoadingImageUrl(string) [NSURL URLWithString:(string)]
/** 默认占位图片 */
#define PlaceholderImage SetImage(@"wdwd_picmr")


#define SafeAreaInsetsBottom UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom

#define TWNSLog( s, ... ) printf("\n类名: <%p %s:(行数：%d) > \n方法: %s \n%s\n\n\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] )


#define SystemType  @"17"

#define APPID @"6475574470"

#define Ads_appKey  @""
#define Ads_express_Id  @""



static inline CGFloat TWStatusBarHeight(void) {
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    if (height <= 0) {
        height = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    if (height <= 0) {
        height = 20;
    }
    return height;
}

#endif /* MacroHeadFile_h */
