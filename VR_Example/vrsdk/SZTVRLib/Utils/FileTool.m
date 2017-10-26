//
//  FileTool.m
//  SztFramework
//
//  Created by szt on 16/5/10.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "FileTool.h"
#import <ImageIO/ImageIO.h>
#import "sys/utsname.h"
#import "FileDownloadUtil.h"

@implementation FileTool 

+ (void)copyFileToPath:(NSString *)fileName
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    
    NSString *Path =[doucumentsDirectiory stringByAppendingPathComponent:fileName];
    NSFileManager *file = [NSFileManager defaultManager];
    if ([file fileExistsAtPath:Path])
    {
        SZTLog(@"存在 %@",Path);
    }
    else //若沙盒中没有
    {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        [fileManager copyItemAtPath:bundle toPath:Path error:&error];
        
        SZTLog(@"写入没有%d",[fileManager copyItemAtPath:bundle toPath:Path error:&error]);
    }
}

+ (void)checkBundleVersion:(void (^)(void))isEqual noEqual:(void (^)(void))noEqual
{
    // 沙盒中的版本号 与 当前的版本号做对比
    // 读取沙盒的版本
    NSString * lastVersion= [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    // 读取info.plist
    NSDictionary * info = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = info[@"CFBundleShortVersionString"];
    
    // 字符串比对
    if ([currentVersion isEqualToString:lastVersion])
    {
        isEqual();
    }
    else
    {
        // 信息存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleVersion"];
        // 马上同步到沙盒中
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        noEqual();
    }
}

+ (void)downloadFile:(NSString *)urlName block:(void (^)(NSString *))block
{
    __block NSString *fileName;
    dispatch_queue_t queue = dispatch_queue_create("DownLoad", NULL);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        fileName = [[self createFilePathWithName:@"Downloaded"] stringByAppendingPathComponent:[urlName lastPathComponent]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileName]){
            
            SZTLog(@"本地存在,直接读取");
        }else{
            
            SZTLog(@"本地不存在,网上下载");
            
            NSURL *url = [NSURL URLWithString:urlName];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            // 将NSData类型对象data写入文件，文件名为fileName
            [data writeToFile:fileName atomically:YES];
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        block(fileName);
    });
}

+ (NSDictionary *)ConvertLyricsToTextAndTime:(NSString *)filePath
{
    NSMutableDictionary *dic;
    
    // 文件存在
    if ([filePath length])
    {
        NSString *lyc = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        NSMutableArray * _musictime = [[NSMutableArray alloc]init];
        NSMutableArray * _lyrics = [[NSMutableArray alloc]init];
        NSMutableArray * _t = [[NSMutableArray alloc]init];
        
        NSArray *arr = [lyc componentsSeparatedByString:@"\n"];
        
        for (NSString *item in arr) {
            if ([item length] && [item rangeOfString:@"["].location != NSNotFound && [item rangeOfString:@"]"].location) {
                NSRange startrange = [item rangeOfString:@"["];
                NSRange stoprange = [item rangeOfString:@"]"];
                
                NSString *content = [item substringWithRange:NSMakeRange(startrange.location+1, stoprange.location - startrange.location-1)];
                
                if ([content length] == 8) {
                    // 分
                    NSString *minute = [content substringWithRange:NSMakeRange(0, 2)];
                    // 秒
                    NSString *second = [content substringWithRange:NSMakeRange(3, 2)];
                    // 毫秒
                    NSString *mm = [content substringWithRange:NSMakeRange(6, 2)];
                    
                    NSString *time = [NSString stringWithFormat:@"%@:%@.%@",minute, second, mm];
                    
                    NSNumber *total = [NSNumber numberWithInteger:[minute integerValue] * 60 + [second integerValue]];
                    [_t addObject:total];
                    
                    NSString *lyric = [item substringFromIndex:10];
                    [_musictime addObject:time];
                    [_lyrics addObject:lyric];
                }
            }
        }
        
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_t, @"Time",_lyrics,@"Lyrics",nil];
    }
    
    return dic;
}

+ (NSMutableArray *)readPlistFromLocal:(NSString *)filePath
{
    NSMutableArray *array;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        SZTLog(@"本地存在");
        array = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    else
    {
        SZTLog(@"不存在");
    }
    
    return array;
}

/**将int值转成钟表时间*/
+ (NSString*)TimeformatFromSeconds:(int)seconds
{
    int totalm = seconds/(60);
    int h = totalm/(60);
    int m = totalm%(60);
    int s = seconds%(60);
    if (h == 0) {
        return  [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}

// 将时间戳转换为NSDate类型
+ (NSDate *)getDateTimeFromMilliSeconds:(long long)miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

// 将NSDate类型的时间转换为时间戳,从1970/1/1开始
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval * 1000;
    return totalMilliseconds;
}

+ (NSString *)createFilePathWithName:(NSString *)filePathName
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,filePathName];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        return createPath;
    } else {
        return createPath;
    }
}

+ (NSMutableArray *)decodeGifWithGifPath:(NSString *)path isApng:(BOOL)isApng
{
    NSMutableArray * data = [NSMutableArray array];
    
    CFURLRef _url = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
    NSMutableArray *gifImagesArr = [NSMutableArray array];
    NSMutableArray *frameDelayTimes = [NSMutableArray array];
    
    // 获取资源
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(_url, NULL);
    size_t frameCount = CGImageSourceGetCount(gifSource);
    
    for (size_t i = 0; i < frameCount; i++) {
        CGImageRef cgimg = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *uiimg = [UIImage imageWithCGImage:cgimg];
        [gifImagesArr addObject:uiimg];
        CGImageRelease(cgimg);
        
        if (!isApng) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
            NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
            [frameDelayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        }
    }
    
    [data addObject:gifImagesArr];
    if (!isApng) {
        [data addObject:frameDelayTimes];
    }
    [data addObject:frameDelayTimes];
    
    if (gifSource) {
        CFRelease(gifSource);
    }
    
    if (gifImagesArr.count == 0) {
        return nil;
    }
    
    return data;
}

+ (NSString *)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

#pragma download
+ (void)downLoadWithFileName:(NSString *)fileUrl hasExist:(void (^)(NSString *))existFileName finishDownload:(void (^)(NSString *))downloadFileName
{
    NSString * fileName = [[FileTool createFilePathWithName:@"Downloaded"] stringByAppendingPathComponent:[fileUrl lastPathComponent]];
    NSFileManager *file = [NSFileManager defaultManager];
    
    if ([file fileExistsAtPath:fileName]) // 存在
    {
        SZTLog(@"存在本地文件:%@",fileName);
        if (![FileDownloadUtil checkFileNameIntegrated:[fileUrl lastPathComponent]]) {
            SZTLog(@"文件缺失");
            [self downLoad:fileUrl finishDownload:^(NSString *name) {
                downloadFileName(name);
            }];
        }else{
            existFileName(fileName);
        }
    }else // 网络请求
    {
        SZTLog(@"网络请求");
        [self downLoad:fileUrl finishDownload:^(NSString *name) {
            downloadFileName(name);
        }];
    }
}

+ (void)downLoad:(NSString *)fileUrl finishDownload:(void (^)(NSString *))downloadFileName
{
    FileDownloadUtil *download = [[FileDownloadUtil alloc] init];
    [download downloadWithUrl:fileUrl];
    
    [download setDownloadBlockParam:^(NSString * fileName) {
        downloadFileName(fileName);
    }];
}

+ (float)readCacheSize
{
    NSString *cachePath = [self createFilePathWithName:@"Downloaded"];
    return [self folderSizeAtPath:cachePath];
}

+ (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0 * 1024.0);
}

+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

+ (void)clearFile:(void (^)(float))cleared
{
    dispatch_queue_t queue = dispatch_queue_create("clearFile", NULL);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSString *cachePath = [self createFilePathWithName:@"Downloaded"];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        
        for (NSString * p in files)
        {
            NSError * error = nil;
            //获取文件全路径
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:&error];
            }
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        cleared([self readCacheSize]);
    });
}

@end
