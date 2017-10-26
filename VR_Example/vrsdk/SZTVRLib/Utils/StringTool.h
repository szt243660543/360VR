//
//  StringTool.h
//  ANTVR_SDK
//
//  Created by ANTVR on 16/10/18.
//  Copyright © 2016年 ANTVR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringTool : NSObject

/**
 * 字符串字节截取
 * @param char stringName
 * @param lenth 开始截取
 */
+ (NSString *)substrCharByte:(char *)stringName lenth:(int)lenth;

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

+ (NSString *)replaceUnicode:(NSString*)aUnicodeString;

+ (NSString *)utf8ToUnicode:(NSString *)string;
@end
