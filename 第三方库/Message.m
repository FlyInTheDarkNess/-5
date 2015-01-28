//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    self.icon = dict[@"userimage"];
    self.time = dict[@"addtime"];
    self.content = dict[@"contents"];
//    if (dict[@"type"]) {
//        self.type = 0;
//    }
//    else{
//        self.type = 1;
//    }
//    self.type = [dict[@"type"] intValue];
}



@end
