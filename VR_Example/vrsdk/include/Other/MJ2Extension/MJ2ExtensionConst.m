#ifndef __MJExtensionConst__M__
#define __MJExtensionConst__M__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const MJ2PropertyTypeInt = @"i";
NSString *const MJ2PropertyTypeShort = @"s";
NSString *const MJ2PropertyTypeFloat = @"f";
NSString *const MJ2PropertyTypeDouble = @"d";
NSString *const MJ2PropertyTypeLong = @"l";
NSString *const MJ2PropertyTypeLongLong = @"q";
NSString *const MJ2PropertyTypeChar = @"c";
NSString *const MJ2PropertyTypeBOOL1 = @"c";
NSString *const MJ2PropertyTypeBOOL2 = @"b";
NSString *const MJ2PropertyTypePointer = @"*";

NSString *const MJ2PropertyTypeIvar = @"^{objc_ivar=}";
NSString *const MJ2PropertyTypeMethod = @"^{objc_method=}";
NSString *const MJ2PropertyTypeBlock = @"@?";
NSString *const MJ2PropertyTypeClass = @"#";
NSString *const MJ2PropertyTypeSEL = @":";
NSString *const MJ2PropertyTypeId = @"@";

#endif
