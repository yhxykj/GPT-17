//
//  TWPayPalSdk.h
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    PayPalSuccess = 0,       // 购买成功
    PayPalFailed = 1,        // 购买失败
    PayPalCancel = 2,        // 取消购买
    PayPalVerFailed = 3,     // 订单校验失败
    PayPalVerSuccess = 4,    // 订单校验成功
    PayPalNotArrow = 5,      // 不允许内购
}PayPalStatusType;

typedef void (^PayPalSuccessHandle)(PayPalStatusType type, NSData *data, NSString *transaction_id);

@interface TWPayPalSdk : NSObject

+ (instancetype)shared;

//恢复购买
- (void)tw_RestoreOrder;

- (void)tw_PayPalSdkID:(NSString *)productID completeHandle:(PayPalSuccessHandle)handle;

/// 取消正在购买的订单
- (void)_cancelPurchasing;

@end

NS_ASSUME_NONNULL_END
