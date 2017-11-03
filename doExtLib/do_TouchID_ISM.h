//
//  do_TouchID_IMethod.h
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol do_TouchID_ISM <NSObject>

//实现同步或异步方法，parms中包含了所需用的属性
@required
- (void)evaluate:(NSArray *)parms;

@end