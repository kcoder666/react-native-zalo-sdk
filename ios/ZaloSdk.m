#import "ZaloSdk.h"

#import <React/RCTUtils.h>
#import <ZaloSDK/ZaloSDK.h>

@implementation ZaloSdk

RCT_EXPORT_MODULE()

#pragma Authentication

RCT_EXPORT_METHOD(login:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] unauthenticate];
    [[ZaloSDK sharedInstance] authenticateZaloWithAuthenType:ZAZAloSDKAuthenTypeViaZaloAppAndWebView
                                            parentController:RCTPresentedViewController()
                                                     handler:^(ZOOauthResponseObject * response) {
        if ([response isSucess]) {
            NSString * oauthCode = response.oauthCode;
            resolve(oauthCode);
        } else if (response.errorCode != kZaloSDKErrorCodeUserCancel) {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Login"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(isAuthenticated:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] isAuthenticatedZaloWithCompletionHandler:^(ZOOauthResponseObject *response) {
        
        if ([response isSucess]) {
            resolve(TRUE);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Check Auth"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(logout)
{
    [[ZaloSDK sharedInstance] unauthenticate];
}

#pragma Interact with Zalo app

RCT_EXPORT_METHOD(sendMessageInZalo:(NSString*)message
                  withAppName:(NSString*)appName
                  withLink:(NSString*)link
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    ZOFeed * feed = [[ZOFeed alloc] initWithLink:link appName:appName message:message others:nil];
    
    [[ZaloSDK sharedInstance] sendMessage:feed
                             inController:RCTPresentedViewController()
                                 callback:^(ZOShareResponseObject *response) {
        
        if (response.errorCode == kZaloSDKErrorCodeNoneError) {
            resolve(nil);
        } else if (response.errorCode != kZaloSDKErrorCodeUserCancel) {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Send Message (in Zalo)"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(shareFeedInZalo:(NSString*)message
                  withAppName:(NSString*)appName
                  withLink:(NSString*)link
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    ZOFeed * feed = [[ZOFeed alloc] initWithLink:link appName:appName message:message others:nil];
    
    [[ZaloSDK sharedInstance] shareFeed:feed
                           inController:RCTPresentedViewController()
                               callback:^(ZOShareResponseObject *response) {
        
        if (response.errorCode == kZaloSDKErrorCodeNoneError) {
            resolve(nil);
        } else if (response.errorCode != kZaloSDKErrorCodeUserCancel) {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Share Feed (in Zalo)"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

#pragma Open APIs

RCT_EXPORT_METHOD(sendOfficalAccountMessage:(NSString*)templateId
                  withTemplateData:(NSDictionary*)templateData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] sendOfficalAccountMessageWith:templateId
                                               templateData:templateData
                                                   callback:^(ZOGraphResponseObject *response) {
     
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Send Message (Official Account)"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(sendMessage:(NSString*)friendId
                  withMessage:(NSString*)message
                  withLink:(NSString*)link
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] sendMessageTo:friendId
                                    message:message
                                       link:link
                                   callback:^(ZOGraphResponseObject *response) {
     
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Send Message"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(sendAppRequest:(NSString*)friendId
                  withMessage:(NSString*)message
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] sendAppRequestTo:friendId
                                       message:message
                                      callback:^(ZOGraphResponseObject *response) {
     
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Send App Request"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(postFeed:(NSString*)message
                  withLink:(NSString*)link
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] postFeedWithMessage:message
                                             link:link
                                         callback:^(ZOGraphResponseObject *response) {
     
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Post Feed"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(getFriendList:(NSUInteger)offset
                  withCount:(NSUInteger)count
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] getUserFriendListAtOffset:offset
                                                  count:count
                                               callback:^(ZOGraphResponseObject *response) {
        
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Get Friends"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(getInvitableFriendList:(NSUInteger)offset
                  withCount:(NSUInteger)count
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] getUserInvitableFriendListAtOffset:offset
                                                           count:count
                                                        callback:^(ZOGraphResponseObject *response) {
        
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error  = [NSError errorWithDomain:@"Get Invitable Friends"
                                                   code:response.errorCode
                                               userInfo:@{NSLocalizedDescriptionKey:message}];
            reject(errorCode, message, error);
        }
    }];
}

RCT_EXPORT_METHOD(getProfile:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] getZaloUserProfileWithCallback:^(ZOGraphResponseObject *response) {
        
        if ([response isSucess]) {
            resolve(@[response.data]);
        } else {
            NSString * errorCode = [NSString stringWithFormat:@"%ld", (long) response.errorCode];
            NSString * message = response.errorMessage;
            NSError * error = [[NSError alloc] initWithDomain:@"Get Profile"
                                                         code:response.errorCode
                                                     userInfo:@{@"message": response.errorMessage}];
            reject(errorCode, message, error);
        }
    }];
}

+ (BOOL) requiresMainQueueSetup
{
    return NO;
}

- (dispatch_queue_t) methodQueue
{
  return dispatch_get_main_queue();
}

@end
