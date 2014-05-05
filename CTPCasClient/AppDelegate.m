//
//  AppDelegate.m
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-4.
//
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IndexViewController.h"

@implementation AppDelegate

@synthesize window, rootViewController, indexViewController;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotatio {
    NSString *param = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *view = [userDefaults stringForKey:@"view"];
    if ([view isEqualToString:@"Index"]) {
        param = [@"goto=Index&tgtId=" stringByAppendingString:[userDefaults stringForKey:@"tgtId"]];
    } else {
        param = @"goto=Login";
    }
    
    NSLog(@"CasClient 副应用的页面选择 %@", param);
    
    NSString *URLEncodedText = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *ourPath = [@"casAPP://" stringByAppendingString:URLEncodedText];
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        NSLog(@"CasClient 跳转至副应用制定界面");
        [ourApplication openURL:ourURL];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[window addSubview:viewController.view];
    
    self.rootViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
