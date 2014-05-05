//
//  CasClient.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-4.
//
//

#import "AFHTTPSessionManager.h"
#import "CasInfo.h"

@protocol CasClientDelegate;

@interface CasClient : AFHTTPSessionManager

@property (nonatomic, weak) id<CasClientDelegate> casDelegate;

// 用户信息
@property (nonatomic, retain) NSString *credential;
@property (nonatomic, retain) NSNumber *type;

// Cas服务返回信息
@property (retain) NSDictionary *casInfo;

+ (CasClient *)client;

// 根据用户名密码访问服务获取TGT
- (void)requestServerWithCredential:(NSString *)credential;

// 根据TGT访问服务
- (void)requestServerWithTGT:(NSString *) tgtId;


@end

@protocol CasClientDelegate <NSObject>

// 操作服务返回结果集
- (void) didResult:(CasClient *)casClient;

@end
