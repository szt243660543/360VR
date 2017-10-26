//
//  FileDownloadUtil.h
//  tester360
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTvr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^downloadBlockParam)(NSString *);
typedef void(^failToLoadParam)(NSString *);

@interface FileDownloadUtil : NSObject<NSURLConnectionDataDelegate>
{
    downloadBlockParam downloadblock;
    failToLoadParam faildblock;
    
    NSString * fileName;
}

/**
 * 下载
 * @param urlPath 网络地址
 */
- (void)downloadWithUrl:(NSString *)urlPath;

/**
 * 下载完成回调
 * @param block
 */
- (void)setDownloadBlockParam:(downloadBlockParam)block;

- (void)failtoDownloadBlockParam:(failToLoadParam)block;

/**
 * 删除文件
 * @param fileName 文件名
 */
+ (void)deleteFile:(NSString *)fileName;

/**
 * 检验文件的完整性
 * @param fileName 文件名字
 */
+ (BOOL)checkFileNameIntegrated:(NSString *)fileName;

/**
 * 下载文件的总长度
 */
@property (nonatomic, assign) NSInteger totalLength;

/**
 * 已下载的总长度
 */
@property (nonatomic, assign) NSInteger currentLength;

/**
 * 文件句柄，用来实现文件存储
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;



@end
