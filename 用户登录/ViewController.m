//
//  ViewController.m
//  用户登录
//
//  Created by 张玺科 on 16/6/6.
//  Copyright © 2016年 张玺科. All rights reserved.
//

#import "ViewController.h"

static NSString *kLoginUserNameKey = @"kLoginUserNameKey";
static NSString *kLoginUserPwdKey = @"kLoginUserPwdKey";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadUserAccount];
}

- (IBAction)login {
//    [self getLogin];
    
//    [self postLogin];
    [self postLoginWithUserName:_nameText.text pwd:_pwdText.text];
}

- (void)postLoginWithUserName:(NSString *)userName pwd:(NSString *)pwd {
    NSURL *url = [NSURL URLWithString:@"http://localhost/php/login.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *formString = [NSString stringWithFormat:@"username=%@&password=%@", userName, pwd];
    NSData *formData = [formString dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = formData;

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"请求错误!");
            
            return;
        }
        
        // 反序列化
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSLog(@"%@", result);
        
        if ([result[@"userId"] integerValue] > 0) {
            [self saveUserAccount];
        }

    }] resume];

}

- (void)saveUserAccount {
    
    static NSString *kLoginUserNameKey = @"kLoginUserNameKey";
    static NSString *kLoginUserPwdKey = @"kLoginUserPwdKey";
    
    // 1. 用户偏好
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 2. 保存
    [defaults setObject:_nameText.text forKey:kLoginUserNameKey];
    [defaults setObject:_pwdText.text forKey:kLoginUserPwdKey];
}

- (void)loadUserAccount {
    // 1. 用户偏好
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 2. 设置 UI
    _nameText.text = [defaults stringForKey:kLoginUserNameKey];
    _pwdText.text = [defaults stringForKey:kLoginUserPwdKey];
}

- (void)getLogin{

    NSString *urlString = [NSString stringWithFormat:@"http://localhost/php/login.php?username=%@&password=%@", @"zhangsan", @"zhang"];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"请求错误");
            
            return;
        }
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSLog(@"%@",result);
    }]resume];
}

@end
