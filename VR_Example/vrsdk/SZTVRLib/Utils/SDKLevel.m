//
//  SDKLevel.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2017/2/8.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SDKLevel.h"

// 请求路径
#define URL @"http://api.360looker.com/v2/sdk/check"
// SDK等级
#define LEVEL @"1"

#define POSTKEY @"KEY_OF_CREATWATERMARK"

@interface SDKLevel()

@end

@implementation SDKLevel
SingletonM(SDKLevel)

- (void)checkLevel
{
    [self createWaterMark];
    
    return;
    
    if ((int)[[NSUserDefaults standardUserDefaults] valueForKey:POSTKEY] == 1) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST"; //设置请求方法
    
    // 设置请求体
    NSString *param = [NSString stringWithFormat:@"bundleid=%@&vid=%@",BundleID, LEVEL];
    // 把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

// 接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    int value;
    
    if([result rangeOfString:@"1"].location !=NSNotFound){
        value = 1;
    }else{
        value = 0;
        [self createWaterMark];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:POSTKEY];
    [userDefaults synchronize];
}
// 数据传完之后调用此方法
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}

// 网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    SZTLog(@"%@",[error localizedDescription]);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:1 forKey:POSTKEY];
}

// 创建水印
- (void)createWaterMark
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_logo.vrkongfu" ofType:nil]];
    UIImage *paceholderImg = [UIImage imageWithData:data];

    SZTImageView *waterMark = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [waterMark setupTextureWithUrl:@"http://vrkongfu.oss-cn-hangzhou.aliyuncs.com/kf_logo.png" Paceholder:paceholderImg];
    [waterMark setObjectSize:800.0 Height:800.0];
    [waterMark setPosition:0.0 Y:-20.0 Z:0.0];
    [waterMark setRotate:-90.0 radiansY:0.0 radiansZ:0.0];
    [waterMark build];
}

@end
