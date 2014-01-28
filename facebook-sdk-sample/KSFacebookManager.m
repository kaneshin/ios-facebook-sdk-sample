// KSFacebookManager.m
//
// Copyright (c) 2014 Shintaro Kaneko (http://kaneshinth.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KSFacebookManager.h"

typedef struct {
    char *appId;
} FacebookAppConfig;

static FacebookAppConfig kPProductionFBConfig = {
    "461090090658890",
};

static FacebookAppConfig kPStagingFBConfig = {
    "461090090658890",
};

@interface KSFacebookManager ()
@property (nonatomic, strong, readwrite) NSArray *permissions;
@property (nonatomic, assign) FacebookAppConfig *fbAppConfig;
- (BOOL)isProduction;
@end

@implementation KSFacebookManager

+ (KSFacebookManager *)sharedManager
{
    static KSFacebookManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KSFacebookManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.permissions = [NSArray arrayWithObjects:@"email", nil];
        self.fbAppConfig = self.isProduction ? &kPProductionFBConfig : &kPStagingFBConfig;
    }
    return self;
}

- (BOOL)isProduction
{
    return YES;
}

- (NSString *)URLScheme
{
    return [NSString stringWithFormat:@"fb%s", self.fbAppConfig->appId];
}

- (void)refreshSession
{
    self.session = [[FBSession alloc] init];
}

- (void)refreshSessionWithPermission
{
    if (self.isProduction) {
        self.session = [[FBSession alloc] initWithPermissions:self.permissions];
    } else {
        // To avoid .plist settings
        self.session = [[FBSession alloc] initWithAppID:[NSString stringWithFormat:@"%s", self.fbAppConfig->appId]
                                            permissions:self.permissions
                                        urlSchemeSuffix:[self URLScheme]
                                     tokenCacheStrategy:[FBSessionTokenCachingStrategy defaultInstance]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.session close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
}

- (void)sessionCloseAndClearTokenInformation
{
    if (self.session.isOpen) {
        [self.session closeAndClearTokenInformation];
    }
}

@end