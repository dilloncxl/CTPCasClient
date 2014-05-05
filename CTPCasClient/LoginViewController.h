//
//  ViewController.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-4.
//
//

#import <UIKit/UIKit.h>
#import "CasClient.h"
#import "DesUtil.h"
#import "MD5Tools.h"

@interface LoginViewController : UIViewController <CasClientDelegate> {
    UITextField *username;
    UITextField *password;
}



@property(nonatomic, retain) IBOutlet UITextField *username;
@property(nonatomic, retain) IBOutlet UITextField *password;


- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;


@end


