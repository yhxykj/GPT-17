//
//  TWAFHttpCustomClient.m
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import "TWAFHttpCustomClient.h"

@implementation TWAFHttpCustomClient

+ (TWAFHttpCustomClient *)shared {
    
    static TWAFHttpCustomClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TWAFHttpCustomClient alloc] init];
    });
    
    return instance;
    
}

-(void) postUrl:(NSString *)URLString
          param:(NSMutableDictionary *)param
        success:(AFSuccBlock)success
        failure:(AFFailBlock)failure {
    [self requestUrl:URLString param:param success:success failure:failure method:@"POST"];
}

#pragma mark- 直接返回字段对象的 请求方式
-(void) requestUrl:(nullable NSString *)URLString
             param:(nullable NSMutableDictionary *)param
           success:(nullable AFSuccBlock)success
           failure:(nullable AFFailBlock)failure
            method:(nullable NSString *)method
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer     = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = responseSerializer;
    
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"application/x-javascript", nil];
    
    [param setValue:SystemType forKey:@"systemType"];
    NSLog(@"%@",param);
    
    
    NSString *String = [NSString stringWithFormat:@"%@%@",API_BASE_URL,URLString];
    
    [manager POST:String parameters:param headers:[TWAFHttpCustomClient tw_httpHeaderField] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![URLString containsString:@"/app/order/create/"]) {
            [SVProgressHUD dismiss];
        }
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        NSDictionary *data = (NSDictionary *)responseObject;
        
        if (code == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(responseObject);
                }
            });
        }else if (code == 401) {
//            [GlobalVC.base_nav pushViewController:TWLoginViewController.new animated:YES];
            
            [NSNotificationCenter.defaultCenter postNotificationName:@"loginAccountNotificationName" object:nil];
            
        }
    
        TWNSLog(@"网络请求成功解析：data=%@",data);
        
        if (code == 500) {
            
            if ([[data objectForKey:@"msg"] isEqualToString:@"ai.ios.drawing.sum"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        success(responseObject);
                    }
                });
            }
            
            else {
                [SVProgressHUD showErrorWithStatus:[data objectForKey:@"msg"]];
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n============Error :%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"网络请求失败!"];
            if (failure) {
                failure(error);
            }
        });
        [SVProgressHUD dismiss];
    }];
    
}

+ (NSMutableDictionary *)tw_httpHeaderField {
    NSString *token = [SAVE_UDF objectForKey:@"user_token"];
    NSMutableDictionary *header = NSMutableDictionary.dictionary;
    if (token.length) {
        header[@"Authorization"] = [NSString stringWithFormat:@"Bearer %@",token];
    }
    header[@"userType"] = @"app_user";
    NSLog(@"header:%@",header);
    return header;
}


@end
