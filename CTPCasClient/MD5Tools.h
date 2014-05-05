//
//  MD5Tools.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-9.
//
//

#import <Foundation/Foundation.h>

@interface MD5Tools : NSObject

//  MD5加密
+ (NSString *)md5HexDigest:(NSString *)plainText;

@end
