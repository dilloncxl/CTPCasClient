//
//  CasClient.m
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-4.
//
//

#import "CasClient.h"

@implementation CasClient

static CasClient *casClient;

//static NSString * const CasServerURLString = @"http://10.10.62.91:8080/CAS/DemoServlet?";


static NSString * const CasServerURL = @"http://ask.comtop.com:8085/cas/authorize";

// 确保只有一个单例
+ (id)alloc {
    NSLog(@"alloc");
	@synchronized(self) {
		NSAssert(casClient == nil, @"试图初始化第二个cas客户端实例.");
		casClient = [super alloc];
        
        casClient.responseSerializer = [AFJSONResponseSerializer serializer];
        //casClient.requestSerializer = [AFJSONRequestSerializer serializer];

		return casClient;
	}
    
	return nil;
}

// 支持异步调用
+ (CasClient *)client {
    NSLog(@"client");
	@synchronized(self) {
		if (!casClient)
			casClient = [[CasClient alloc] init];
		return casClient;
	}
	return nil;
}


- (void)requestServerWithCredential:(NSString *)credential {
    @synchronized(self) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSNumber *type = [[NSNumber alloc] initWithInt:1];
        parameters[@"type"] = type;
        parameters[@"credential"] = credential;
        NSLog(@"请求获取TGT。。。");
        [self POST:CasServerURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            self.casInfo = (NSDictionary *) responseObject;
            NSLog(@"获取得到返回信息");
            NSLog(@"设置TGT");
            if ([self.casDelegate respondsToSelector:@selector(didResult:)]) {
                NSLog(@"访问代理！");
                [self.casDelegate didResult:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"无法获取TGT, %@",error);
        }];
    }
}

- (void)requestServerWithTGT:(NSString *) tgtId {
    @synchronized(self) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSNumber *type = [[NSNumber alloc] initWithInt:2];
        parameters[@"type"] = type;
        parameters[@"tgtId"] = tgtId;
        NSLog(@"根据TGT访问服务。。。");
        [self POST:CasServerURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            self.casInfo = (NSDictionary *) responseObject;
            NSLog(@"获取得到返回信息");
            NSLog(@"设置TGT");
            if ([self.casDelegate respondsToSelector:@selector(didResult:)]) {
                NSLog(@"访问代理！");
                [self.casDelegate didResult:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"无法获取TGT, %@",error);
        }];
    }
}


@end

