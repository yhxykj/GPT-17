//
//  TWSocketManager.m
//  TaoWu
//
//  Created by JJK on 2023/12/5.
//

#import "TWSocketManager.h"
#import "SRWebSocket.h"

@interface TWSocketManager ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;

@property (nonatomic,assign)TWSocketStatus tw_socketStatus;

@property (nonatomic,weak)NSTimer *timer;

@property (nonatomic,copy)NSString *urlString;

@end



@implementation TWSocketManager
{
    NSInteger _reconnectCounter;
}

//static TWSocketManager *shareManager = nil;

+ (instancetype)shareManager {
    static TWSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 5;
    });
    return instance;
}

- (void)tw_open:(NSString *)urlStr connect:(TWSocketDidConnectBlock)connect receive:(TWSocketDidReceiveBlock)receive failure:(TWSocketDidFailBlock)failure{
    
    [TWSocketManager shareManager].connect = connect;
    [TWSocketManager shareManager].receive = receive;
    [TWSocketManager shareManager].failure = failure;
    [self tw_open:urlStr];
}

- (void)tw_close:(TWSocketDidCloseBlock)close{
    [TWSocketManager shareManager].close = close;
    [self tw_close];
}

// Send a UTF8 String or Data.
- (void)tw_send:(id)data{
    switch ([TWSocketManager shareManager].fl_socketStatus) {
        case TWSocketStatusConnected:
            
        case TWSocketStatusReceived:{
            NSLog(@"发送中。。。");
            [self.webSocket send:data];
            break;
        }
        case TWSocketStatusFailed:
            NSLog(@"发送失败");
            break;
        case TWSocketStatusClosedByServer:
            NSLog(@"已经关闭");
            break;
        case TWSocketStatusClosedByUser:
            NSLog(@"已经关闭");
            break;
    }
    
}

#pragma mark -- private method
- (void)tw_open:(id)params{
//    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [TWSocketManager shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

- (void)tw_close{
    
    [self.webSocket close];
//    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)tw_reconnect{
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(tw_open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else{
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    
}

#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    
    [TWSocketManager shareManager].connect ? [TWSocketManager shareManager].connect() : nil;
    [TWSocketManager shareManager].tw_socketStatus = TWSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    [TWSocketManager shareManager].tw_socketStatus = TWSocketStatusFailed;
    [TWSocketManager shareManager].failure ? [TWSocketManager shareManager].failure(error) : nil;
    // 重连
    [self tw_reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@":( Websocket Receive With message %@", message);
    [TWSocketManager shareManager].tw_socketStatus = TWSocketStatusReceived;
    [TWSocketManager shareManager].receive ? [TWSocketManager shareManager].receive(message,TWSocketReceiveTypeForMessage) : nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);
    if (reason) {
        [TWSocketManager shareManager].tw_socketStatus = TWSocketStatusClosedByServer;
        // 重连
        [self tw_reconnect];
    }
    else{
        [TWSocketManager shareManager].tw_socketStatus = TWSocketStatusClosedByUser;
    }
    [TWSocketManager shareManager].close ? [TWSocketManager shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSLog(@":( Websocket Receive With message %@", pongPayload);
    [TWSocketManager shareManager].receive ? [TWSocketManager shareManager].receive(pongPayload,TWSocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    // Close WebSocket
    [self tw_close];
}

//+ (void)releaseInstance {
//    shareManager = nil;
//}

@end
