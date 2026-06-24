//
//  TWSocketManager.h
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,TWSocketStatus){
    TWSocketStatusConnected,// 已连接
    TWSocketStatusFailed,// 失败
    TWSocketStatusClosedByServer,// 系统关闭
    TWSocketStatusClosedByUser,// 用户关闭
    TWSocketStatusReceived// 接收消息
};
/**

 *
 *  消息类型
 */
typedef NS_ENUM(NSInteger,TWSocketReceiveType){
    TWSocketReceiveTypeForMessage,
    TWSocketReceiveTypeForPong
};
/**

 *
 *  连接成功回调
 */
typedef void(^TWSocketDidConnectBlock)();
/**

 *
 *  失败回调
 */
typedef void(^TWSocketDidFailBlock)(NSError *error);
/**

 *
 *  关闭回调
 */
typedef void(^TWSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
/**

 *
 *  消息接收回调
 */
typedef void(^TWSocketDidReceiveBlock)(id message ,TWSocketReceiveType type);

@interface TWSocketManager : NSObject
@property (nonatomic,copy)TWSocketDidConnectBlock connect;
/**

 *
 *  接收消息回调
 */
@property (nonatomic,copy)TWSocketDidReceiveBlock receive;
/**

 *
 *  失败回调
 */
@property (nonatomic,copy)TWSocketDidFailBlock failure;
/**

 *
 *  关闭回调
 */
@property (nonatomic,copy)TWSocketDidCloseBlock close;
/**

 *
 *  当前的socket状态
 */
@property (nonatomic,assign,readonly)TWSocketStatus fl_socketStatus;
/**

 *
 *  超时重连时间，默认1秒
 */
@property (nonatomic,assign)NSTimeInterval overtime;
/**
 *  @author Clarence
 *
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
/**

 *
 *  单例调用
 */
+ (instancetype)shareManager;
/**

 *
 *  开启socket
 *
 *  @param urlStr  服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)tw_open:(NSString *)urlStr connect:(TWSocketDidConnectBlock)connect receive:(TWSocketDidReceiveBlock)receive failure:(TWSocketDidFailBlock)failure;
/**

 *
 *  关闭socket
 *
 *  @param close 关闭回调
 */
- (void)tw_close:(TWSocketDidCloseBlock)close;
/**

 *
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
- (void)tw_send:(id)data;

/**

 *
 *  关闭socket
 *
 *
 */
- (void)tw_close;

//+ (void)releaseInstance;

@end

NS_ASSUME_NONNULL_END
