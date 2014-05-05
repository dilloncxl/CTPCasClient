//
//  IndexViewController.m
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-15.
//
//

#import "IndexViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoSecondApp:(id)sender {
    
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [self.tgtResult.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ourPath = [@"casAPP://goto=Index&tgtId=" stringByAppendingString:URLEncodedText];
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        [ourApplication openURL:ourURL];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未找到APP" message:@"无法向另一个应用发送TGT." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)logoutPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"登出");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"Login" forKey:@"view"];
        [userDefaults synchronize];
    }];
}

@end
