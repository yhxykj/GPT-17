

#import "AliYunLoginManager.h"

@implementation AliYunLoginManager

+ (void)requestATAuthSDKInfo:(void (^)(BOOL, NSString * _Nonnull))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        
        if (block) {
            block(YES, PNSATAUTHSDKINFO);
        }
    });
}

@end
