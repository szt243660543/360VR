//
//  NSObject+MJClass.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSObject+MJ2Class.h"
#import "NSObject+MJ2Coding.h"
#import "NSObject+MJ2KeyValue.h"
#import "MJ2Foundation.h"
#import <objc/runtime.h>

static const char MJ2AllowedPropertyNamesKey = '\0';
static const char MJ2IgnoredPropertyNamesKey = '\0';
static const char MJ2AllowedCodingPropertyNamesKey = '\0';
static const char MJ2IgnoredCodingPropertyNamesKey = '\0';

static NSMutableDictionary *allowedPropertyNamesDict_;
static NSMutableDictionary *ignoredPropertyNamesDict_;
static NSMutableDictionary *allowedCodingPropertyNamesDict_;
static NSMutableDictionary *ignoredCodingPropertyNamesDict_;

@implementation NSObject (MJ2Class)

+ (void)load
{
    allowedPropertyNamesDict_ = [NSMutableDictionary dictionary];
    ignoredPropertyNamesDict_ = [NSMutableDictionary dictionary];
    allowedCodingPropertyNamesDict_ = [NSMutableDictionary dictionary];
    ignoredCodingPropertyNamesDict_ = [NSMutableDictionary dictionary];
}

+ (NSMutableDictionary *)dictForKey:(const void *)key
{
    @synchronized (self) {
        if (key == &MJ2AllowedPropertyNamesKey) return allowedPropertyNamesDict_;
        if (key == &MJ2IgnoredPropertyNamesKey) return ignoredPropertyNamesDict_;
        if (key == &MJ2AllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict_;
        if (key == &MJ2IgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict_;
        return nil;
    }
}

+ (void)mj_enumerateClasses:(MJ2ClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([MJ2Foundation isClassFromFoundation:c]) break;
    }
}

+ (void)mj_enumerateAllClasses:(MJ2ClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

#pragma mark - 属性黑名单配置
+ (void)mj_setupIgnoredPropertyNames:(MJ2IgnoredPropertyNames)ignoredPropertyNames
{
    [self mj_setupBlockReturnValue:ignoredPropertyNames key:&MJ2IgnoredPropertyNamesKey];
}

+ (NSMutableArray *)mj_totalIgnoredPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_ignoredPropertyNames) key:&MJ2IgnoredPropertyNamesKey];
}

#pragma mark - 归档属性黑名单配置
+ (void)mj_setupIgnoredCodingPropertyNames:(MJ2IgnoredCodingPropertyNames)ignoredCodingPropertyNames
{
    [self mj_setupBlockReturnValue:ignoredCodingPropertyNames key:&MJ2IgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)mj_totalIgnoredCodingPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_ignoredCodingPropertyNames) key:&MJ2IgnoredCodingPropertyNamesKey];
}

#pragma mark - 属性白名单配置
+ (void)mj_setupAllowedPropertyNames:(MJ2AllowedPropertyNames)allowedPropertyNames;
{
    [self mj_setupBlockReturnValue:allowedPropertyNames key:&MJ2AllowedPropertyNamesKey];
}

+ (NSMutableArray *)mj_totalAllowedPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_allowedPropertyNames) key:&MJ2AllowedPropertyNamesKey];
}

#pragma mark - 归档属性白名单配置
+ (void)mj_setupAllowedCodingPropertyNames:(MJ2AllowedCodingPropertyNames)allowedCodingPropertyNames
{
    [self mj_setupBlockReturnValue:allowedCodingPropertyNames key:&MJ2AllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)mj_totalAllowedCodingPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_allowedCodingPropertyNames) key:&MJ2AllowedCodingPropertyNamesKey];
}
#pragma mark - block和方法处理:存储block的返回值
+ (void)mj_setupBlockReturnValue:(id (^)())block key:(const char *)key
{
    if (block) {
        objc_setAssociatedObject(self, key, block(), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 清空数据
    [[self dictForKey:key] removeAllObjects];
}

+ (NSMutableArray *)mj_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    NSMutableArray *array = [self dictForKey:key][NSStringFromClass(self)];
    if (array) return array;
    
    // 创建、存储
    [self dictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
        if (subArray) {
            [array addObjectsFromArray:subArray];
        }
    }
    
    [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        NSArray *subArray = objc_getAssociatedObject(c, key);
        [array addObjectsFromArray:subArray];
    }];
    return array;
}
@end
