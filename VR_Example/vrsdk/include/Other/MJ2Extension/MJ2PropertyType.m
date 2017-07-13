//
//  MJPropertyType.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "MJ2PropertyType.h"
#import "MJ2Extension.h"
#import "MJ2Foundation.h"
#import "MJ2ExtensionConst.h"

@implementation MJ2PropertyType

static NSMutableDictionary *types_;
+ (void)initialize
{
    types_ = [NSMutableDictionary dictionary];
}

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    MJ2ExtensionAssertParamNotNil2(code, nil);
    @synchronized (self) {
        MJ2PropertyType *type = types_[code];
        if (type == nil) {
            type = [[self alloc] init];
            type.code = code;
            types_[code] = type;
        }
        return type;
    }
}

#pragma mark - 公共方法
- (void)setCode:(NSString *)code
{
    _code = code;
    
    MJ2ExtensionAssertParamNotNil(code);
    
    if ([code isEqualToString:MJ2PropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [MJ2Foundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:MJ2PropertyTypeSEL] ||
               [code isEqualToString:MJ2PropertyTypeIvar] ||
               [code isEqualToString:MJ2PropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    
    // 是否为数字类型
    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[MJ2PropertyTypeInt, MJ2PropertyTypeShort, MJ2PropertyTypeBOOL1, MJ2PropertyTypeBOOL2, MJ2PropertyTypeFloat, MJ2PropertyTypeDouble, MJ2PropertyTypeLong, MJ2PropertyTypeLongLong, MJ2PropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:MJ2PropertyTypeBOOL1]
            || [lowerCode isEqualToString:MJ2PropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end
