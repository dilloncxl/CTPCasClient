//
//  CasInfo.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-8.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (casInfo)

// 认证类型
- (NSNumber *)authenticationType;

// TGT
- (NSString *)tgtId;

// 用户名密码
- (NSString *)credential;

// 认证结果编码
- (NSString *)code;

// 认证结果信息
- (NSString *)message;

// 用户ID
- (NSString *)userId;

// 员工名
- (NSString *)employee_name;

// 员工ID
- (NSString *)employee_id;

@end
