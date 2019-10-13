#import "ZaloSdk.h"

#import <React/RCTUtils.h>
#import <ZaloSDK/ZaloSDK.h>

@implementation ZaloSdk

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(login:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    UIViewController *presentedViewController = RCTPresentedViewController();
    [[ZaloSDK sharedInstance] unauthenticate];
    [[ZaloSDK sharedInstance] authenticateZaloWithAuthenType:ZAZAloSDKAuthenTypeViaZaloAppAndWebView
                                            parentController:presentedViewController
                                                     handler:^(ZOOauthResponseObject * response) {
        if ([response isSucess]) {
            NSString * oauthCode = response.oauthCode;
            resolve(oauthCode);
        } else if (response.errorCode != kZaloSDKErrorCodeUserCancel) {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [
                                NSError errorWithDomain:@"Login error"
                                code:response.errorCode
                                userInfo:@{NSLocalizedDescriptionKey:message}
                                ];
            reject(errorCode, message, error);
        }
    }];
}


RCT_EXPORT_METHOD(logout)
{
    [[ZaloSDK sharedInstance] unauthenticate];
}

RCT_EXPORT_METHOD(getProfile:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] getZaloUserProfileWithCallback:^(ZOGraphResponseObject *response) {
        
        if (response.errorCode == kZaloSDKErrorCodeNoneError) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error = [
                               [NSError alloc] initWithDomain:@"Zalo Oauth"
                               code:response.errorCode
                               userInfo:@{@"message": response.errorMessage}
                               ];
            reject(errorCode, message, error);
        }
    }];
}

+ (BOOL) requiresMainQueueSetup
{
    return NO;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

@end
