//
//  ViewController.m
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-4.
//
//

#import "LoginViewController.h"
#import "IndexViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username;
@synthesize password;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"Login" forKey:@"view"];
    [userDefaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    self.username.text = @"";
    self.password.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 用户权限认证，获取TGT
 */
- (IBAction) tgtAuthenticate {
    
    if ( [self.username.text  isEqual: @""] || [self.password.text  isEqual: @""] || self.username.text == nil || self.password.text == nil) {
        NSLog(@"用户名或密码为空");
        return;
    }
    
	NSString *passwordFild = [MD5Tools md5HexDigest:self.password.text];
    NSLog(@"password MD5 : %@", passwordFild);
    
    
    NSString *credential = [DesUtil encryptUseDES:[[self.username.text stringByAppendingString:@"&"]stringByAppendingString:passwordFild]];
    credential = [credential stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"username&password DES: 【%@】", credential);
            
    [CasClient client].casDelegate = self;
    [[CasClient client] requestServerWithCredential:credential];
}

- (void) didResult:(CasClient *)casClient {
    NSLog(@"设置TGT：%@", casClient.casInfo.tgtId);
    if (casClient.casInfo.tgtId == nil) {
        NSLog(@"TGT为空");
        return;
    }
    
    IndexViewController *indexViewController = [[IndexViewController alloc] init];
    
    [self presentViewController:indexViewController animated:YES completion:^{
        indexViewController.tgtResult.text = casClient.casInfo.tgtId;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"Index" forKey:@"view"];
        [userDefaults setObject:casClient.casInfo.tgtId forKey:@"tgtId"];
        [userDefaults synchronize];
    }];

}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

@end
