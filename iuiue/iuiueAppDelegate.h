//
//  iuiueAppDelegate.h
//  iuiue
//
//  Created by mizilang on 14-5-8.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import "Reachability.h"

#define UmengAppkey @"53d5e8a256240b98d3029803"

@interface iuiueAppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate>{
    @private
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;


- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变
- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接改变后的情况

@end
