//
//  SZTGif.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/30.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTGif.h"
#import "GLUtils.h"
#import "SZTObject3D.h"
#import <ImageIO/ImageIO.h>
#import "FileDownloadUtil.h"
#import "FileTool.h"
#import "SZTBitmapTexture.h"

@interface SZTGif()
{
    SZTTexture * _texture;
    SZTBitmapTexture * _gifTexture;
    
    UInt64 lastTime;
    BOOL isFirstIn;
    int times;
    BOOL _isRemove;
    BOOL _isSettingSize;
    float _totalTime;
    BOOL _isApng;
    BOOL _isPlay;
}

// 序列帧数组
@property(nonatomic, strong)NSMutableArray * gifImagesArr;
// 帧间隔数组
@property(nonatomic, strong)NSMutableArray * frameDelayTimes;
// 帧图片
@property(nonatomic, weak)UIImage *frameImage;

@property (nonatomic , assign)int index;

@end

@implementation SZTGif

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isRemove = false;
        self.index = 0;
        isFirstIn = true;
        self.repeatTimes = 1;
        times = 1;
        self.isFlip = YES;
        self.speed = 1.0;
        _isPlay = true;
        
        [self changeDisplayMode:SZTVR_PLANE];
    }
    
    return self;
}

- (void)setupGifWithFileUrl:(NSString *)fileUrl
{
    _isApng = false;
    [self setupTexture];
    __weak typeof(self) weakSelf = self;
    [FileTool downLoadWithFileName:fileUrl hasExist:^(NSString * fileName) {
        [weakSelf readyToDecode:fileName];
    } finishDownload:^(NSString * fileName) {
        [weakSelf readyToDecode:fileName];
    }];
}

- (void)setupGifWithGifName:(NSString *)gifName
{
    _isApng = false;
    NSString *fileName = [[NSBundle mainBundle] pathForResource:gifName ofType:nil];
    [self setupTexture];
    [self readyToDecode:fileName];
}

- (void)setupGifWithGifPath:(NSString *)pathName
{
    _isApng = false;
    [self readyToDecode:pathName];
}

- (void)setupGifViewWithFrames:(NSArray *)frameNames playTime:(float)time
{
    if (self.gifImagesArr) {
        self.gifImagesArr = nil;
    }
    
    self.gifImagesArr = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_queue_create("loadGif", NULL);
    dispatch_group_t group = dispatch_group_create();
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_async(group, queue, ^{
        for (NSString * frameName in frameNames) {
            UIImage *image = [UIImage imageNamed:frameName];
            [weakSelf.gifImagesArr addObject:image];
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setPlayTime:time];
        [self changePlayTime];
        [self readyToRender];
    });
}

- (void)setupApngWithApngName:(NSString *)apngName playTime:(float)time
{
    _isApng = true;
    NSString *fileName = [[NSBundle mainBundle] pathForResource:apngName ofType:nil];
    [self setupTexture];
    [self setPlayTime:time];
    [self changePlayTime];
    
    [self readyToDecode:fileName];
}

- (void)setupApngWithApngPath:(NSString *)path playTime:(float)time
{
    _isApng = true;
    [self setupTexture];
    [self setPlayTime:time];
    [self changePlayTime];
    
    [self readyToDecode:path];
}

- (void)setupApngWithApngUrl:(NSString *)fileUrl playTime:(float)time
{
    _isApng = true;
    [self setupTexture];
    [self setPlayTime:time];
    [self changePlayTime];
    
    __weak typeof(self) weakSelf = self;
    [FileTool downLoadWithFileName:fileUrl hasExist:^(NSString * fileName) {
        [weakSelf readyToDecode:fileName];
    } finishDownload:^(NSString * fileName) {
        [weakSelf readyToDecode:fileName];
    }];
}

- (void)setupTexture
{
    if (_gifTexture) return;
    
    _gifTexture = [[SZTBitmapTexture alloc] init];
}

- (void)downLoad:(NSString *)fileUrl
{
    FileDownloadUtil *download = [[FileDownloadUtil alloc] init];
    [download downloadWithUrl:fileUrl];

    [download setDownloadBlockParam:^(NSString * fileName) {
        [self readyToDecode:fileName];
    }];
}

- (void)readyToDecode:(NSString *)fileName
{
//    [self getGifDecodeInfo:fileName];
//    [self readyToRender];
    
    // 异步处理
    dispatch_queue_t queue = dispatch_queue_create("DecodeGif", NULL);
    dispatch_group_t group = dispatch_group_create();
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_async(group, queue, ^{
        // 解序列帧
        [weakSelf getGifDecodeInfo:fileName];
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf readyToRender];
    });
}

- (void)readyToRender
{
    if (!self.gifImagesArr) return;
    
    self.frameImage = self.gifImagesArr[0];
    
    if (!_isSettingSize) {
        CGImageRef cgImageRef = [self.frameImage CGImage];
        [self setObjectSize:CGImageGetWidth(cgImageRef) Height:CGImageGetHeight(cgImageRef)];
    }
    

    for (int i = 0 ; i < self.gifImagesArr.count; i++) {
        _texture = [_gifTexture createTextureWithImage:self.gifImagesArr[i] TextureFilter:self.textureFilter ByTextureID:i];
    }
    
    [self addGifObserver];
}

- (void)setObjectSize:(float)width Height:(float)height
{
    [super setObjectSize:width Height:height];
    
    _isSettingSize = true;
}

/*
 * 解压gif获取序列帧信息
 *
 */
- (BOOL)getGifDecodeInfo:(NSString *)fileName
{
    NSMutableArray *info = [FileTool decodeGifWithGifPath:fileName isApng:_isApng];
    if (info == nil) return false;
    
    self.gifImagesArr = info[0];
    
    BOOL isChange= [self changePlayTime];
    if (!isChange) {
        self.frameDelayTimes = info[1];
    }
    
    return true;
}

- (void)updateTexture
{
    long long recordTime = [FileTool getDateTimeTOMilliSeconds:[NSDate date]];
    if (isFirstIn) {
        isFirstIn = false;
        lastTime = recordTime;
    }
    
    long long delayTimes = (recordTime - lastTime);
    if (self.index >= self.frameDelayTimes.count) {
        return;
    }
    
    if (delayTimes >= [self.frameDelayTimes[self.index] floatValue] * 1000) {
        isFirstIn = true;
        self.index += self.speed;
    }
    
    [self setupImage];
}

- (void)setupImage
{
    if (self.index >= self.gifImagesArr.count) {
        if (times < self.repeatTimes) {
            times += 1;
            self.index = 0;
        }else{
            times = 1;
            self.index = 0;
            if (gifDidFinished) {
                gifDidFinished(self);
            }
        }
    }else{
        if (self.index >= self.gifImagesArr.count) {
            return;
        }
    }
}

- (void)setPlayTime:(float)time
{
    _totalTime = time;
}

- (BOOL)changePlayTime
{
    if (_totalTime) {
        float eachTime = (float)_totalTime/self.gifImagesArr.count;
        
        self.frameDelayTimes = nil;
        self.frameDelayTimes = [NSMutableArray array];
        
        for (int i = 0; i < self.gifImagesArr.count; i++) {
            [self.frameDelayTimes addObject:[NSNumber numberWithFloat:eachTime]];
        }
        
        return true;
    }else{
        return false;
    }

    return true;
}

- (void)pause
{
    _isPlay = false;
}

- (void)play
{
    _isPlay = true;
}

- (void)resume
{
    self.index = 0;
    _isPlay = true;
}

#pragma mark render
- (void)renderToFbo:(int)index
{
    if (!_isRemove) {
        [super renderToFbo:index];
    
        if (self.isRenderMonocular && index == 1) {
            return;
        }
        
        if (_isPlay) {
            [self updateTexture];
        }
        
        if (_texture) {
            [_texture updateTexture:self.program.uSamplerLocal ByTextureID:self.index];
        }else{
            return;
        }
        
        // draw
        [self drawElements:index];
    }
}

- (void)gifDidFinishedCallback:(gifDidFinishedBlockParam)block
{
    gifDidFinished = block;
}

- (void)addGifObserver
{
    [super addObserver];
}

- (void)addObserver
{
    // nil
}

- (void)removeObject
{
    _isRemove = true;
    
    [super removeObject];
}

- (void)destory
{
    [super destory];
    
    [self removeObject];
    if (_texture) [_texture destory];
}

- (void)dealloc
{
    [self destory];
}

@end
