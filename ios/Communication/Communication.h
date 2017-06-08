//
//  Communication.h
//  Communication
//
//  Created by zmt on 16/10/21.
//  Copyright © 2016年 cn.com.jiuqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface Communication : NSObject<RCTBridgeModule>

@end
