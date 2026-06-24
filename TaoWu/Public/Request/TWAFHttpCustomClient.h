//
//  TWAFHttpCustomClient.h
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AFSuccBlock)(id json);
typedef void(^AFFailBlock)(NSError *error);

@interface TWAFHttpCustomClient : NSObject

+ (TWAFHttpCustomClient *)shared;

/**
 进行POST请求
 
 @param URLString 当前接口
 @param param 需要传的参数
 @param success 成功后回调
 @param failure 失败后回调

 */
-(void) postUrl:(NSString *)URLString
          param:(NSMutableDictionary *)param
        success:(AFSuccBlock)success
        failure:(AFFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
