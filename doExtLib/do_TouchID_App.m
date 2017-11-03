//
//  do_TouchID_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_TouchID_App.h"
static do_TouchID_App* instance;
@implementation do_TouchID_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_TouchID_App alloc]init];
    return instance;
}
@end
