//
//  TWPayPalSdk.m
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import "TWPayPalSdk.h"

@interface TWPayPalSdk ()<SKPaymentTransactionObserver,SKProductsRequestDelegate> {
    NSString *current_purchased_id;
    PayPalSuccessHandle orderPayDone;
 }
 
@property (nonatomic, copy) NSString *transaction_id; /// 获取transaction_id
@property (nonatomic, strong) NSArray<SKPaymentTransaction *> *transactions;

@end

@implementation TWPayPalSdk

+ (instancetype)shared {
    static TWPayPalSdk *pay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        pay = [[TWPayPalSdk alloc] init];
    });
    return pay;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
 
- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//恢复购买
- (void)tw_RestoreOrder {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
 
 
- (void)tw_PayPalSdkID:(NSString *)productID completeHandle:(PayPalSuccessHandle)handle {
    
    [self _removeAllUncompleteTransactionBeforeStartNewTransaction];
   
    if (!productID.length) {
        [SVProgressHUD showErrorWithStatus:@"未找到相应的商品"];
    }
    if (productID) {
        if ([SKPaymentQueue canMakePayments]) {
            current_purchased_id = productID;
            orderPayDone = handle;
            
            //从App Store中检索关于指定产品列表的本地化信息
            NSSet *nsset = [NSSet setWithArray:@[productID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [self _statusInPaymentTheProcess:PayPalNotArrow data:nil];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先开启应用内付费购买功能。"];
    }
}

- (void)_statusInPaymentTheProcess:(PayPalStatusType)type data:(NSData *)data{
    [SVProgressHUD dismiss];
#if DEBUG
    switch (type) {
        case PayPalSuccess:
            NSLog(@"购买成功");
            break;
        case PayPalFailed:
            NSLog(@"购买失败");
            break;
        case PayPalCancel:
            NSLog(@"用户取消购买");
            break;
        case PayPalVerFailed:
            NSLog(@"订单校验失败");
            break;
        case PayPalVerSuccess:
            NSLog(@"订单校验成功");
            break;
        case PayPalNotArrow:
            NSLog(@"不允许程序内付费");
            break;
        default:
            break;
    }
#endif
    if(orderPayDone){
        orderPayDone(type,data,self.transaction_id);
    }
}

//data 转 json 字符串
- (NSString *)toJsonData:(id)theData{
    NSString *jsonStr = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    if (jsonStr.length > 0) {
        return jsonStr;
    }else{
        return nil;
    }
}
 
- (void)_orderVerifyPaymentTransaction:(SKPaymentTransaction *)trans {
    
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    //获取transaction_id
    self.transaction_id = trans.transactionIdentifier;
    [self toJsonData:receipt];
    if(!receipt){
        // 交易凭证为空验证失败
        [self _statusInPaymentTheProcess:PayPalVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self _statusInPaymentTheProcess:PayPalSuccess data:receipt];
     
    NSError *error;
    NSDictionary *requestContents;
    
    requestContents = @{@"receipt-data":[receipt base64EncodedStringWithOptions:0],
                            @"password":PassWord};
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
     
    if (!requestData) { //交易凭证为空验证失败
        [self _statusInPaymentTheProcess:PayPalVerFailed data:nil];
        return;
    }
    
    NSString *serverString = AppStore;
    
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // 无法连接服务器,购买校验失败
            [self _statusInPaymentTheProcess:PayPalVerFailed data:nil];
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 服务器校验数据返回为空校验失败
                [self _statusInPaymentTheProcess:PayPalVerFailed data:nil];
            }
            
            self.transaction_id = trans.transactionIdentifier;
            NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
            if(status && [status isEqualToString:@"0"]){
                
                NSString *productId = trans.payment.productIdentifier;
                NSLog(@"\n\n===============>> 购买成功ID:%@ <<===============\n\n",productId);
                
                NSArray *pending_renewal_info = jsonResponse[@"pending_renewal_info"];
                NSDictionary *latest_pending_renewal_dic;
                if (pending_renewal_info.count > 0) {
                    latest_pending_renewal_dic = pending_renewal_info[pending_renewal_info.count - 1];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSArray *latest_receipt_ary = jsonResponse[@"latest_receipt_info"];
                    
                    BOOL invoke = NO;
                    
                    if (latest_receipt_ary.count > 0) {
                        for (NSDictionary *latest_receipt_dic in latest_receipt_ary) {
                            NSUInteger expires_date_ms = [[latest_receipt_dic[@"expires_date_ms"] substringToIndex:10] integerValue];//过期时间
                            NSUInteger nowTime = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] longLongValue];
                            self.transaction_id = [latest_receipt_dic objectForKey:@"transaction_id"];
                            if (expires_date_ms > nowTime) {
                                invoke = YES;
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",expires_date_ms] forKey:@"expires_date_ms"];
                            }
                        }
                    }
                    NSDictionary *last_dic = [latest_receipt_ary firstObject];
                    self.transaction_id = [last_dic objectForKey:@"transaction_id"];
                    
                    NSString *expires_date_ms = [NSString stringWithFormat:@"%@",[last_dic objectForKey:@"expires_date_ms"]];
                    [[NSUserDefaults standardUserDefaults] setValue:@([expires_date_ms doubleValue]) forKey:@"expires_date_ms"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSLog(@"expires_date_ms:------%@",[last_dic objectForKey:@"expires_date_ms"]);
                    //purchase_date_ms//会员开通时间戳   expires_date_ms//会员到期时间戳
                    [self _statusInPaymentTheProcess:PayPalVerSuccess data:receipt];
                });
            } else {
                [self _statusInPaymentTheProcess:PayPalVerFailed data:nil];
            }
            
            NSLog(@"----验证结果 %@",jsonResponse);
            
#if DEBUG
            NSLog(@"----验证结果 %@",jsonResponse);
#endif
        }
    }];
    [task resume];
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:trans];
}
 
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if([product count] <= 0){
        [SVProgressHUD showErrorWithStatus:@"没有相应的商品"];
        return;
    }
     
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:current_purchased_id]){
            p = pro;
            break;
        }
    }
     
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"描述:%@",[p description]);
    NSLog(@"标题%@",[p localizedTitle]);
    NSLog(@"本地化描述%@",[p localizedDescription]);
    NSLog(@"价格：%@",[p price]);
    NSLog(@"产品productIdentifier：%@",[p productIdentifier]);
#endif
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSString *receiptPath = receiptURL.path;

    if ([receiptPath containsString:@"sandboxReceipt"]) {
        NSLog(@"当前是沙盒环境");
        GlobalVC.sandboxTest = 1;
    } else {
        GlobalVC.sandboxTest = 0;
    }
    
}
 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------从App Store中检索本地化信息错误-----------------:%@", error);
}
 
- (void)requestDidFinish:(SKRequest *)request{

    NSLog(@"------------requestDidFinish-----------------");
}
 
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self _orderVerifyPaymentTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                NSLog(@"商品添加进列表");
                self.transactions = transactions;
#endif
                break;
            case SKPaymentTransactionStateRestored:
                [SVProgressHUD dismiss];
#if DEBUG
                NSLog(@"已经购买过商品");
#endif
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self _tradFailedTransaction:tran];
                break;
            default:
                break;
        }
    }
}

// 交易失败
- (void)_tradFailedTransaction:(SKPaymentTransaction *)transaction{
   
    [SVProgressHUD dismiss];
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self _statusInPaymentTheProcess:PayPalFailed data:nil];
    }else{
        [self _statusInPaymentTheProcess:PayPalCancel data:nil];
    }
     
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"恢复Transactions = %@",queue.transactions);
    
    [SVProgressHUD dismiss];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    NSLog(@"恢复error = %@",error);
}



#pragma mark -- 结束上次未完成的交易 防止串单
- (void)_removeAllUncompleteTransactionBeforeStartNewTransaction {
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
    }
}

/// 取消正在购买的订单
- (void)_cancelPurchasing {
    for (SKPaymentTransaction *transaction in self.transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}


@end
