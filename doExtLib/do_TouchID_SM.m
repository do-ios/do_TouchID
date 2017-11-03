//
//  do_TouchID_SM.m
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_TouchID_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation do_TouchID_SM
#pragma mark - 方法
#pragma mark - 同步异步方法的实现
//同步
//异步
- (void)evaluate:(NSArray *)parms
{
    //异步耗时操作，但是不需要启动线程，框架会自动加载一个后台线程处理这个函数
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    NSString *title = [doJsonHelper GetOneText:_dictParas :@"title" :@""];
    NSString *_callbackName = [parms objectAtIndex:2];
    //回调函数名_callbackName
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = title;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            NSString *status;
            NSString *code;
                if(success)
                {
                    //处理验证通过
                    code = @"";
                    status = @"true";
                }
                else
                {
                    //处理验证失败
                    code = [self getAuthErrorDescription:error.code];
                    status = @"false";
                }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:code forKey:@"code"];
            [dict setObject:status forKey:@"status"];
            
            doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
            //_invokeResult设置返回值
            [_invokeResult SetResultNode:dict];
            [_scritEngine Callback:_callbackName :_invokeResult];
            
        }];
    }
    else
    {
        //不支持Touch ID验证，提示用户
        NSString *code = @"6";
        NSString *status = @"false";
        if (authError) {
            code = [self getAuthErrorDescription:authError.code];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:code forKey:@"code"];
        [dict setObject:status forKey:@"status"];
        doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
        //_invokeResult设置返回值
        [_invokeResult SetResultNode:dict];
        [_scritEngine Callback:_callbackName :_invokeResult];
    }
}
- (NSString *)getAuthErrorDescription:(NSInteger)code
{
    NSString *msg = @"";
    NSString *codeStr = @"";
    switch (code) {
        case LAErrorTouchIDNotEnrolled:
            //认证不能开始,因为touch id没有录入指纹.
            msg = @"此设备未录入指纹信息!";
            codeStr = @"5";
            break;
        case LAErrorPasscodeNotSet:
            //认证不能开始,因为此台设备没有设置密码.
            msg = @"未设置密码,无法开启认证!";
            codeStr = @"4";
            break;
        case LAErrorSystemCancel:
            //认证被系统取消了,例如其他的应用程序到前台了
            msg = @"系统取消认证";
            codeStr = @"3";
            break;
        case LAErrorUserFallback:
            //认证被取消,因为用户点击了fallback按钮(输入密码).
            msg = @"选择输入密码!";
            codeStr = @"2";
            break;
        case LAErrorUserCancel:
            //认证被用户取消,例如点击了cancel按钮.
            msg = @"取消认证!";
            codeStr = @"1";
            break;
        case LAErrorAuthenticationFailed:
            //认证没有成功,因为用户没有成功的提供一个有效的认证资格
            msg = @"认证失败!";
            codeStr = @"0";
            break;
        default:
            break;
    }
    return codeStr;
}
@end