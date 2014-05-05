//
//  MD5Tools.m
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-9.
//
//

#import "MD5Tools.h"
#import <commonCrypto/CommonDigest.h>


@implementation MD5Tools

// MD5加密
+ (NSString *)md5HexDigest:(NSString *)plainText {
    const char* str = [plainText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] ;
    CC_MD5(str, strlen(str), result);
    // CC_MD5_DIGEST_LENGTH=16, 乘2是生成32位MD5
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        // x小写生成的md5码是小写，X大写生成md5码是大写
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

@end
