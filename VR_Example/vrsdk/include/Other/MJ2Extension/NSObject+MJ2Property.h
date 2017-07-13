//
//  NSObject+MJProperty.h
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJ2ExtensionConst.h"

@class MJ2Property;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^MJ2PropertiesEnumeration)(MJ2Property *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * (^MJ2ReplacedKeyFromPropertyName)();
typedef id (^MJ2ReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * (^MJ2ObjectClassInArray)();
/** 用于过滤字典中的值 */
typedef id (^MJ2NewValueFromOldValue)(id object, id oldValue, MJ2Property *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (MJProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)mj_enumerateProperties:(MJ2PropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)mj_setupNewValueFromOldValue:(MJ2NewValueFromOldValue)newValueFormOldValue;
+ (id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MJ2Property *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)mj_setupReplacedKeyFromPropertyName:(MJ2ReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)mj_setupReplacedKeyFromPropertyName121:(MJ2ReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)mj_setupObjectClassInArray:(MJ2ObjectClassInArray)objectClassInArray;
@end

@interface NSObject (MJPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(MJ2PropertiesEnumeration)enumeration MJ2ExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupNewValueFromOldValue:(MJ2NewValueFromOldValue)newValueFormOldValue MJ2ExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MJ2Property *)property MJ2ExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupReplacedKeyFromPropertyName:(MJ2ReplacedKeyFromPropertyName)replacedKeyFromPropertyName MJ2ExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupReplacedKeyFromPropertyName121:(MJ2ReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 MJ2ExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupObjectClassInArray:(MJ2ObjectClassInArray)objectClassInArray MJ2ExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
@end
