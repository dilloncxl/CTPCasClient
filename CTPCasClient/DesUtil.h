//
//  DesUtil.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-8.
//
//

#import <Foundation/Foundation.h>

@interface DesUtil : NSObject

/**
 DES加密
 */
+ (NSString *) encryptUseDES:(NSString *)plainText;

/**
 DES解密
 */
+ (NSString *) decryptUseDES:(NSString *)plainText;



@end
