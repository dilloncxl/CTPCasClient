//
//  Base64.h
//  CTPCasClient
//
//  Created by chenxiaolong on 14-4-8.
//
//

#import <Foundation/Foundation.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@interface Base64 : NSObject

+ (int)char2Int:(char)c;

+ (NSData *)decode:(NSString *)data;

+ (NSString *)encode:(NSData *)data;


@end
