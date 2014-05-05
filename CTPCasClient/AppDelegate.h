//
//  AppDelegate.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-4.
//
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class IndexViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) LoginViewController *rootViewController;
@property (retain, nonatomic) IndexViewController *indexViewController;

@end
