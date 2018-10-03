//  MyIOSSdk.m
#import "MyIOSSdk.h"
#import "BPush.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifiCations/UserNotifications.h>
#endif
@interface MyIOSSdk()
@end
#if defined(__cplusplus)
extern "C"{
#endif
    extern NSString* _CreateNSString (const char* string);
    
#if defined(__cplusplus)
}
#endif
//*****************************************************************************

@implementation MyIOSSdk

static NSString* msgObjStr=@"LobbyMsgReceiver";
static int msgNumber = 0;
static MyIOSSdk* delegateObject = nil;
static Boolean isSelfNotice = false;
+(MyIOSSdk*)getMyinstance{
    if(delegateObject==nil)
    {
        delegateObject= [[MyIOSSdk alloc] init];
    }
    return delegateObject;
}
+(Boolean)getIsSelfNotice{
    return isSelfNotice;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"————————————MyIOSSdk viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initNotice:(NSString*)pKey pMsgObj:(NSString*)pMsgObj pMode:(int)pMode{
    msgObjStr = pMsgObj;
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    //pKey =@"i3u6v7noo4HV5XW6bd1aju0t";
    NSLog(@"pkey>>>>%@",pKey);
    if(pMode==1){
         [BPush registerChannel:mLaunchOptions apiKey:pKey pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    }else{
         [BPush registerChannel:mLaunchOptions apiKey:pKey pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    }
   
    // 禁用地理位置推送 需要再绑定接口前调用。

    [BPush disableLbs];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [mLaunchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
-(void)initLxNotice:(NSString*)pMsgObj{
    isSelfNotice = true;
    msgObjStr = pMsgObj;
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
-(void)readedNoitce:(int) pNum{
    msgNumber = msgNumber - pNum;
    if(msgNumber<0){
        msgNumber=0;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:msgNumber];
}
-(void)addNotice:(NSString*)pContent pDelay:(int)pDelay pNum:(int)pNum{
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:pDelay];
    msgNumber += pNum;
    [BPush localNotification:fireDate alertBody:pContent badge:msgNumber withFirstAction:@"打开" withSecondAction:nil userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil useBehaviorTextInput:YES];   
    UnitySendMessage([msgObjStr UTF8String], [@"DoReceiveNotice" UTF8String], [pContent UTF8String]); 
}
-(void)showMessageView:(NSArray*)phones title:(NSString*)title body:(NSString*)body
{
    NSLog(@"————————————showMessageview");
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body=body;
        [UnityGetGLViewController() presentModalViewController:picker animated:NO];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(NSString*)getIdfa{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            //LOG_EXPR(@”Result: SMS sending canceled”);
            break;
        case MessageComposeResultSent:
            //LOG_EXPR(@”Result: SMS sent”);
            break;
        case MessageComposeResultFailed:
            //[UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"];
            break;
        default:
            //LOG_EXPR(@”Result: SMS not sent”);
            break;
    }
    [UnityGetGLViewController() dismissModalViewControllerAnimated:NO];
}

//字符串转化的工具函数
//**********************
//message tools

+ (void)sendU3dMessage:(NSString *)messageName param:(NSDictionary *)dict isToken:(Boolean)isToken
{
    NSString *param = @"";
    if ( nil != dict ) {
        for (NSString *key in dict)
        {
            if ([param length] == 0)
            {
                param = [param stringByAppendingFormat:@"%@=%@", key, [dict valueForKey:key]];
            }
            else
            {
                param = [param stringByAppendingFormat:@"&%@=%@", key, [dict valueForKey:key]];
            }
        }
    }
   
    if(isToken){
        param =[NSString stringWithFormat:@"token:\n%@",dict];
    }else{
		param = [NSString stringWithFormat:@"Received Remote Notification :\n%@",dict];
	}
    UnitySendMessage([msgObjStr UTF8String], [messageName UTF8String], [param UTF8String]);
}
+ (void)sendU3dMessageToken:(NSString *)messageName dict:(NSData *)dict
{
    // 方式1
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    const char *bytes = dict.bytes;
    int iCount = dict.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    NSLog(@"方式1：%@", deviceTokenString1);
    NSString *param = [@"token:" stringByAppendingString:deviceTokenString1];
    UnitySendMessage([msgObjStr UTF8String], [messageName UTF8String], [param UTF8String]);
}
#if defined(__cplusplus)
extern "C"{
#endif
    NSString* _CreateNSString (const char* string)
    {
        if (string)
            return [NSString stringWithUTF8String: string];
        else
            return [NSString stringWithUTF8String: ""];
    }
    char* _MakeStringCopy( const char* string)
    {
        if (NULL == string) {
            return NULL;
        }
        char* res = (char*)malloc(strlen(string)+1);
        strcpy(res, string);
        return res;
    }
    char* __makeCString(NSString* string)
    {
        if (string == nil) {
            return NULL;
        }
        
        const char* cstring = [string cStringUsingEncoding:NSUTF8StringEncoding];
        
        if (NULL == cstring) {
            return NULL;
        }
        char* res = (char*)malloc(strlen(cstring)+1);
        strcpy(res, cstring);
        return res;
    }
    //供u3d调用的c函数
    void _addFriendFromSms(const char* pContent)
    {
        if (delegateObject == nil){
            delegateObject = [[MyIOSSdk alloc] init];
            
        }
        [delegateObject showMessageView:[NSArray arrayWithObjects:@"",nil] title:@"" body:_CreateNSString(pContent)];
    }
    char* _getImei()
    {
        //return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //return idfv;
        if (delegateObject == nil){
            delegateObject = [[MyIOSSdk alloc] init];
            
        }
        return __makeCString([delegateObject getIdfa]);
    }
    void _initBaiduYuntui(const char* pContent,const char* pMsgObj,int pMode)
    {
        if (delegateObject == nil){
            delegateObject = [[MyIOSSdk alloc] init];
            
        }
        [delegateObject initNotice:_CreateNSString(pContent) pMsgObj:_CreateNSString(pMsgObj) pMode:pMode];
    }
    void _initLxYuntui(const char* pMsgObj)
    {
        if (delegateObject == nil){
            delegateObject = [[MyIOSSdk alloc] init];
            
        }
        [delegateObject initLxNotice:_CreateNSString(pMsgObj)];
    }
    void _localNotice(const char* pContent,int delayTime,int pCount)
    {
        if (delegateObject == nil){
            delegateObject = [[MyIOSSdk alloc] init];
            
        }
        [delegateObject addNotice:_CreateNSString(pContent) pDelay:delayTime pNum:pCount];
         NSLog(@"本地通知啦！！！%@",_CreateNSString(pContent));
    }
    void _readedNotice(int pNum)
    {
        if (delegateObject == nil){
            delegateObject = [[MyIOSSdk alloc] init];
        }
        [delegateObject readedNoitce:pNum];
    }
    //调用拨打电话
    void _callPhone(const char* pContent)
    {
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){//
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
            return;
        }
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:_CreateNSString(pContent)];
        [webView loadRequest:[NSURLRequest requestWithURL:url ]];
        [UnityGetGLView() addSubview:webView];
    }
    //判断是否安装了某程序
    float _isIOSApp(const char* urlshcema) {
        NSString *urlStr = _CreateNSString(urlshcema);
        NSURL *url = [NSURL URLWithString:urlStr];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            return 1.0;
        }
        return 0.0f;
    }
    //打开IOSApp的URL
    void _openIosAppURL(const char* pContent)
    {
        NSString *urlStr = _CreateNSString(pContent);
        NSURL *phoneURL = [NSURL URLWithString:urlStr];
        UIWebView *webView = [UIWebView new];
        [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [UnityGetGLView() addSubview:webView];
    }
    
#if defined(__cplusplus)
}
#endif
@end
