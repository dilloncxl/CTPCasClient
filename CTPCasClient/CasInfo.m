//
//  CasInfo.m
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-8.
//
//

#import "CasInfo.h"

@implementation NSDictionary (casInfo)

- (NSNumber *)authenticationType {
    NSString *cc = [self objectForKey:@"authenticationType"];
    NSNumber *n = [NSNumber numberWithInt:[cc floatValue]];
    return n;
}

- (NSString *)tgtId {
    return [self objectForKey:@"tgtId"];
}

- (NSString *)credential {
    return [self objectForKey:@"credential"];
}

- (NSString *)code {
    return [self objectForKey:@"code"];
}

- (NSString *)message {
    return [self objectForKey:@"message"];
}

- (NSString *)userId {
    NSDictionary *dict = [self objectForKey:@"principal"];
    return [dict objectForKey:@"id"];
}

- (NSString *)employee_name {
    NSDictionary *dict = [self objectForKey:@"principal"];
    NSDictionary *dic = [dict objectForKey:@"attributes"];
    return [dic objectForKey:@"employee_name"];
}

- (NSString *)employee_id {
    NSDictionary *dict = [self objectForKey:@"principal"];
    NSDictionary *dic = [dict objectForKey:@"attributes"];
    return [dic objectForKey:@"employee_id"];
}

@end
