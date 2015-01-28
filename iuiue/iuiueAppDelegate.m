//
//  iuiueAppDelegate.m
//  iuiue
//
//  Created by mizilang on 14-5-8.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueAppDelegate.h"
#import "iuiueloginViewController.h"
#import "SvUDIDTools.h"
#import "UMSocial.h"
#import "MobClick.h"
#import "UMSocialYixinHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialLaiwangHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialTwitterHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialTencentWeiboHandler.h"
#import "UMSocialRenrenHandler.h"
#import "UMSocialInstagramHandler.h"
#import "iuiueChatListViewController.h"

#import "iuiueSQL.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation iuiueAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //这里初始化判断变量
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"zhendong"];
    }
    
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    
    [self updateInterfaceWithReachability: hostReach];
    //.....
    
    //获取广告标识符
    NSString *udid = [SvUDIDTools UDID];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    
    // 当前应用软件版本  比如：1.0.1 Version
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    // 当前应用版本号码   int类型  Build
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    //获取当前设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSString* deviceNamea = [[UIDevice currentDevice] model];
    NSLog(@"设备名称: %@",deviceNamea );
    
    //从钥匙串中获取zend
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_UDID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_UDID];
    iuiueAllService *service = [[iuiueAllService alloc]init];
    
    if (zend.length > 0 ) {
        [service applogDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:zend,@"imei",deviceName,@"phone_config",@"0",@"type",appCurVersionNum,@"version",@"0",@"channel",@"4",@"os", nil]];
        NSLog(@"发送数据：%@",zend);
    }
    else{
        //手动存储udid
        NSMutableDictionary *muniaoUdidKVPairs = [NSMutableDictionary dictionary];
        [muniaoUdidKVPairs setObject:udid forKey:KEYCHAIN_UDID];
        [iuiueCHKeychain save:KEYCHAIN_UDID data:muniaoUdidKVPairs];
        zend = udid;
        [service applogDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:zend,@"imei",deviceName,@"phone_config",@"0",@"type",@"1.0",@"version",@"0",@"channel",@"4",@"os", nil]];
    }
    //设置分享
//    [self shareToPeople];
    self.window.backgroundColor = [UIColor whiteColor];
    iuiueloginViewController *loginVc = [[iuiueloginViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:loginVc];
//    iuiueMyNavigationViewController *nav = [[iuiueMyNavigationViewController alloc]initWithRootViewController:loginVc];
    self.window.rootViewController = naVC;
    
    [self Update1];
    
//    //推送注册
//    if (ios8) {
//        
//        //原因是因为在ios8中，设置应用的application badge value需要得到用户的许可。使用如下方法咨询用户是否许可应用设置application badge value
//        
//        
////        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
////        
////        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        
//        
//        //1.创建消息上面要添加的动作(按钮的形式显示出来)
//        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
//        action.identifier = @"action";//按钮的标示
//        action.title=@"Accept";//按钮的标题
//        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        //    action.authenticationRequired = YES;
//        //    action.destructive = YES;
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
//        action2.identifier = @"action2";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action.destructive = YES;
//        
//        //2.创建动作(按钮)的类别集合
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
//        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
//        
//        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
//        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
//        [application registerUserNotificationSettings:notiSettings];
//        
//    }else{
//        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//    }
//    [[UIApplication sharedApplication] registerUserNotificationSettings:
//     [UIUserNotificationSettings settingsForTypes:
//      (UIUserNotificationTypeSound |
//       UIUserNotificationTypeAlert |
//       UIUserNotificationTypeBadge) categories:nil]];
//    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //推送注册
    if (ios8) {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        
        [application registerUserNotificationSettings:notiSettings];
        //         [UIUserNotificationSettings settingsForTypes:
        //          (UIUserNotificationTypeSound |
        //           UIUserNotificationTypeAlert |
        //           UIUserNotificationTypeBadge) categories:nil];
        //
        //        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}

//友盟分享

-(void)shareToPeople{
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
//    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx9f5cf3106ee65c89" url:@"http://www.muniao.com"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
//    //打开腾讯微博SSO开关，设置回调地址
//    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
//    //打开人人网SSO开关
//    [UMSocialRenrenHandler openSSO];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.muniao.com"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
//    //设置易信Appkey和分享url地址
//    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
//    
//    //设置来往AppId，appscret，显示来源名称和url地址
//    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
//    
    //使用友盟统计
    [MobClick startWithAppkey:UmengAppkey];
//
//    //设置facebook应用ID，和分享纯文字用到的url地址
//    //    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
//    
////    //下面打开Instagram的开关
////    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
//    
//    [UMSocialTwitterHandler openTwitter];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"close" forKey:@"status"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"open" forKey:@"status"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"dasd");
//    [application registerForRemoteNotifications];
    //注册远程通知
    [application registerForRemoteNotifications];
 

}


//推送的3个方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    NSLog(@"regisger success:%@",pToken);
    NSString *Str = [NSString stringWithFormat:@"%@",pToken];
    NSString *str = [Str substringFromIndex:1];
    Str = [str substringToIndex:str.length - 1];
    if ([Str isEqualToString:MY_TOKEN]) {
        
    }
    else{
        [iuiueCHKeychain save:KEYCHAIN_DEVICE_TOKEN data:Str];
    }
    
    NSLog(@"%@",KEYCHAIN_DEVICE_TOKEN);
    //注册成功，将deviceToken保存到应用服务器数据库中
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    
    NSLog(@"userinfo:%@",userInfo);
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"itype"]);
    NSString *str = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"itype"]];

    
    
    if(application.applicationState == UIApplicationStateInactive){
        
        if ([str isEqualToString:@"messages"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Chat" forKey:@"status"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:APNS_SHUA object:nil userInfo:dic];
        }else if([str isEqualToString:@"push"]){
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"OrderOut" forKey:@"status"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:APNS_SHUA object:nil userInfo:dic];
        }
        
    }
    else{
        if([str isEqualToString:@"push"]){
            
            BOOL sound = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
            BOOL zhendong = [[NSUserDefaults standardUserDefaults] boolForKey:@"zhendong"];
            if (zhendong) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            if (sound) {
                
                
                //第一步创建一个声音的路径
                NSURL *system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dingdong" ofType:@"wav"]];
                //第二步：申明一个sound id对象
                SystemSoundID system_sound_id;
                //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
                AudioServicesCreateSystemSoundID((__bridge  CFURLRef)system_sound_url, &system_sound_id);
                AudioServicesPlaySystemSound(system_sound_id);
                
                
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"OrderIn" forKey:@"status"];
             [[NSNotificationCenter defaultCenter] postNotificationName:APNS_SHUA object:nil userInfo:dic];
        }
        
    }

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registfail%@",error);
}




//自动升级功能
-(void)Update:(float)NewVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    if (NewVersion <= [appCurVersion floatValue]) {
        //自动更新不提示，手动更新提示
//        [[UIApplication sharedApplication].keyWindow makeToast:@"已是最新版本！"];
    }
    else{
        [self showView];
        
    }
}

-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否立即升级？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL_UPDATE]];
    }
    else{
        
    }
}

//
-(void)Update1{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APPSTORE_VERSION]];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            NSLog(@"%@",resultDict[@"results"]);
            NSArray *arr = resultDict[@"results"];
            NSDictionary *dic = arr.lastObject;
            
            NSString *NewVersion = dic[@"version"];
            NSLog(@"dic：%@",NewVersion);
            [self Update:[NewVersion floatValue]];
        }
    }
     ];
    [request setFailedBlock:^{
        
//        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
}



//网络监测
//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}


//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == kReachableViaWWAN)
    {
//        printf("\n3g/2G\n");
        [[UIApplication sharedApplication].keyWindow makeToast:@"4G/3G/2G蜂窝网络已连接"  duration:1.5 position:@"center"];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"open" forKey:@"status"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
    }
    else if(status == kReachableViaWiFi)
    {
//        printf("\nwifi\n");
        [[UIApplication sharedApplication].keyWindow makeToast:@"WIFI网络已连接" duration:1.5 position:@"center"];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"open" forKey:@"status"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
    }else
    {
//        printf("\n无网络\n");
        [[UIApplication sharedApplication].keyWindow makeToast:@"当前无网络连接" duration:1.5 position:@"center"];
    }
    
}


@end
