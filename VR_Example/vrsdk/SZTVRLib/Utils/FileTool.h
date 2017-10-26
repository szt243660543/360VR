//
//  FileTool.h
//  SztFramework
//
//  Created by szt on 16/5/10.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTool : NSObject

/** 
 * 拷贝文件到沙盒
 * fileName 文件名
 */
+ (void)copyFileToPath:(NSString *)fileName;

/**
 * 异步下载文件到本地路径 (针对小文件下载)
 * urlName 下载路径
 * 下载完成回调
 */
+ (void)downloadFile:(NSString *)urlName block:(void (^)(NSString *))block;

/**
 * 异步下载文件到本地路径 (针对大文件下载)
 * fileUrl 下载路径
 * existFileName 本地存在
 * downloadFileName 下载完成回调
 */
+ (void)downLoadWithFileName:(NSString *)fileUrl hasExist:(void (^)(NSString *))existFileName finishDownload:(void (^)(NSString *))downloadFileName;

/**
 *
 * 判断沙盒版本和info版本是否一致
 * isEqual block
 * noEqual block
 */
+ (void)checkBundleVersion:(void (^)(void))isEqual noEqual:(void (^)(void))noEqual;

/** 
 * 转换歌词
 * path 
 */
+ (NSDictionary *)ConvertLyricsToTextAndTime:(NSString *)path;

/** 
 *
 * 读取本地plist (存储的是数组)
 * return 数组
 */
+ (NSMutableArray *)readPlistFromLocal:(NSString *)filePath;

/** 将int值转成钟表时间 */
+ (NSString*)TimeformatFromSeconds:(int)seconds;

+ (NSDate *)getDateTimeFromMilliSeconds:(long long)miliSeconds;

// 将NSDate类型的时间转换为时间戳,从1970/1/1开始
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

/** 创建文件夹 */
+ (NSString *)createFilePathWithName:(NSString *)filePathName;

/**
 * 将gif解压成序列帧和帧间隔, 返回的一个数组里面包含两个数组
 * 1、序列帧 2、帧间隔
 */
+ (NSMutableArray *)decodeGifWithGifPath:(NSString *)path isApng:(BOOL)isApng;

+ (NSString *)deviceVersion;

+ (float)readCacheSize;

+ (void)clearFile:(void (^)(float))cleared;

@end
