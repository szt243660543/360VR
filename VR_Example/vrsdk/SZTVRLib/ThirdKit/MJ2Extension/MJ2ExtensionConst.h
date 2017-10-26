
#ifndef __MJ2ExtensionConst__H__
#define __MJ2ExtensionConst__H__

#import <Foundation/Foundation.h>

// 过期
#define MJ2ExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define MJ2ExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setMj_error:error];

// 日志输出
#ifdef DEBUG
#define MJ2ExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define MJ2ExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define MJ2ExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setMj_error:nil]; \
if ((condition) == NO) { \
    MJ2ExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define MJ2ExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define MJ2ExtensionAssert(condition) MJ2ExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define MJ2ExtensionAssertParamNotNil2(param, returnValue) \
MJ2ExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define MJ2ExtensionAssertParamNotNil(param) MJ2ExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define MJ2LogAllIvars \
-(NSString *)description \
{ \
    return [self mj_keyValues].description; \
}
#define MJ2ExtensionLogAllProperties MJ2LogAllIvars

/**
 *  类型（属性类型）
 */
extern NSString *const MJ2PropertyTypeInt;
extern NSString *const MJ2PropertyTypeShort;
extern NSString *const MJ2PropertyTypeFloat;
extern NSString *const MJ2PropertyTypeDouble;
extern NSString *const MJ2PropertyTypeLong;
extern NSString *const MJ2PropertyTypeLongLong;
extern NSString *const MJ2PropertyTypeChar;
extern NSString *const MJ2PropertyTypeBOOL1;
extern NSString *const MJ2PropertyTypeBOOL2;
extern NSString *const MJ2PropertyTypePointer;

extern NSString *const MJ2PropertyTypeIvar;
extern NSString *const MJ2PropertyTypeMethod;
extern NSString *const MJ2PropertyTypeBlock;
extern NSString *const MJ2PropertyTypeClass;
extern NSString *const MJ2PropertyTypeSEL;
extern NSString *const MJ2PropertyTypeId;

#endif
