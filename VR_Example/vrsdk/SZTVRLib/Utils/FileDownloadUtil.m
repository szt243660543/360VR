//
//  FileDownloadUtil.m
//  tester360
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTvr. All rights reserved.
//

#import "FileDownloadUtil.h"
#import "FileTool.h"

// 获取CECHES
#define CECHES [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@implementation FileDownloadUtil

- (void)downloadWithUrl:(NSString *)urlPath
{
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark -- NSURLConnectionDataDelegate
/**
 *  请求失败时调用（请求超时、网络异常）
 *
 *  @param error      错误原因
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    SZTLog(@"failed to download files:%@",error);
    
    [FileDownloadUtil deleteFile:fileName];
    
    if (faildblock) {
        faildblock(fileName);
    }
}

/**
 *  接收到服务器的响应就会调用
 *
 *  @param response   响应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 文件路径
    fileName = [[FileTool createFilePathWithName:@"Downloaded"] stringByAppendingPathComponent:response.suggestedFilename];
    
    // 创建一个空的文件到沙盒中
    NSFileManager* mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:fileName contents:nil attributes:nil];

    // 创建一个用来写数据的文件句柄对象
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    
    // 获得文件的总大小
    self.totalLength = (NSInteger)response.expectedContentLength;
    
    // 将文件总大小记录到本地
    [self setTotalSizeToLocal];
}

- (void)setTotalSizeToLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.totalLength forKey:[fileName lastPathComponent]];
    
    [userDefaults synchronize];
}

- (void)setCurrentSizeToLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempName = [NSString stringWithFormat:@"%@Temp",[fileName lastPathComponent]];
    [userDefaults setInteger:self.currentLength forKey:tempName];
    
    [userDefaults synchronize];
}

+ (BOOL)checkFileNameIntegrated:(NSString *)fileName;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int totalSize = [[userDefaults objectForKey:[fileName lastPathComponent]] intValue];
    
    NSString *tempName = [NSString stringWithFormat:@"%@Temp",fileName];
    int downLoadsize = [[userDefaults objectForKey:[tempName lastPathComponent]] intValue];
    
    if (totalSize == downLoadsize) {
        SZTLog(@"文件完整");
        return YES;
    }

    SZTLog(@"文件缺失");
    [userDefaults removeObjectForKey:[fileName lastPathComponent]];
    [userDefaults removeObjectForKey:[tempName lastPathComponent]];
    
    [userDefaults synchronize];
    
    return NO;
}

/**
 *  当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）
 *
 *  @param data       这次返回的数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    [self.writeHandle synchronizeFile];
    
    // 累计写入文件的长度
    self.currentLength += data.length;
    
    [self setCurrentSizeToLocal];
    // 下载进度
    SZTLog(@"-----------%f",(double)self.currentLength / self.totalLength);
}

/**
 *  加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        downloadblock(fileName);
    });
}

- (void)setDownloadBlockParam:(downloadBlockParam)block
{
    downloadblock = block;
}

- (void)failtoDownloadBlockParam:(failToLoadParam)block
{
    faildblock = block;
}

- (void)isFileCompleted
{
    if ((double)self.currentLength / self.totalLength <= 1.0) {
        [FileDownloadUtil deleteFile:fileName];
    }
}

// 删除沙盒里的文件
+ (void)deleteFile:(NSString *)fileName
{
    NSFileManager* file = [NSFileManager defaultManager];
    
    //文件名
    BOOL blHave = [file fileExistsAtPath:fileName];
    if (!blHave) {
        SZTLog(@"no exist file!");
        return ;
    }else {
        BOOL blDele= [file removeItemAtPath:fileName error:nil];
        if (blDele) {
            SZTLog(@"delete success");
        }else {
            SZTLog(@"delete fail");
        }
    }
}

- (void)dealloc
{
    [self isFileCompleted];
}

@end
