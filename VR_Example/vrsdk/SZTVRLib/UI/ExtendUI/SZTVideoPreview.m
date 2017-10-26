//
//  SZTVideoPreview.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/23.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTVideoPreview.h"

@interface SZTVideoPreview()<VIMVideoPlayerDelegate>
{
    NSMutableDictionary *_mutableDictionary;
    
    int _distance; // 视图移动距离
}

@property(nonatomic, strong)SZTVideo *selectVideo;
@property(nonatomic, strong)NSMutableArray *urlArr;

@end

@implementation SZTVideoPreview

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _distance = -100;
        
        _mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:20];
        _urlArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setChildUI
{
    int _num = 0;  // 加载个数

    float cutMin = self.mPY - self.height * 0.5;
    float cutMax = self.mPY + self.height * (self.showRow - 1) + (self.spacingY * self.showRow) + self.spacingY;
    
    for (int i = 0 ; i < self.buttonArr.count; i++) {
        SZTImageView * obj = self.buttonArr[i];
        _num ++;
        [obj setObjectSize:self.width Height:self.height];
        obj.cutMinY = cutMin;
        obj.cutMaxY = cutMax;
        [obj build];
        
        if (self.column * self.moveY == 0) {
            if (_num <= self.showRow * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }else{
            if (_num > self.column && _num <= (self.showRow +1) * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }
        
        [self setChildTargetBlock:obj];
    }
}

- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer
{
    [videoPlayer pause];
}

- (void)setChildTargetBlock:(SZTImageView *)imgv
{
    __weak typeof(self) weakSelf = self;
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:imgv];
    [touch willTouchCallBack:^(GLKVector3 vec) {
        [weakSelf setupVideo:imgv];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willSelectVideoPreviewChildObject:)]) {
            [weakSelf.delegate willSelectVideoPreviewChildObject:weakSelf.selectVideo];
        }
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectVideoPreviewChildObject:)]) {
            [weakSelf.delegate didSelectVideoPreviewChildObject:weakSelf.selectVideo];
        }
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLeaveVideoPreviewChildObject:)]) {
            [weakSelf.delegate didLeaveVideoPreviewChildObject:weakSelf.selectVideo];
        }
        
        [weakSelf.selectVideo removeObject];
        weakSelf.selectVideo = nil;
    }];
}

- (void)setupVideo:(SZTImageView *)imgv
{
    NSString *key_tag = [NSString stringWithFormat:@"%d",imgv.tag];
    NSURL * url = [_mutableDictionary objectForKey:key_tag];
    
    [_selectVideo removeObject];
    _selectVideo = nil;
    
    if (!_selectVideo) {
        _selectVideo = [[SZTVideo alloc] initIJKPlayerVideoWithURL:url VideoMode:SZTVR_PLANE isVideoToolBox:YES videoFrameMode:SZTVIDEO_DEFAULT];
        _selectVideo.tag = imgv.tag;
        [_selectVideo setRotate:0.0 radiansY:self.mRadians radiansZ:0.0];
        [_selectVideo setPosition:imgv.pX Y:imgv.pY Z:imgv.pZ + 1.0];
        [_selectVideo setObjectSize:self.width Height:self.height];
        [_selectVideo build];
    }
}

- (void)offsetObject
{
//    [self removeAllObject];
//    
//    [self updateObject];
    
    int _num = 0;  // 加载个数
    int _showi = self.column * self.moveY;
    if (_showi > 0) {  // 显示showRow ＋ 上下两列
        _showi -= self.column;
    }
    
    for (int i = _showi ; i < self.buttonArr.count; i++) {
        SZTImageView * obj = self.buttonArr[i];
        if (_num < (self.showRow + 2) * self.column) {
            _num ++;
        }
        
        if (self.column * self.moveY == 0) {
            if (_num <= self.showRow * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }else{
            if (_num > self.column && _num <= (self.showRow +1) * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }
    }
}

- (void)updateObject
{
    [self build];
    [self setChildUI];
    
    [self setRotate:self.mRadians X:self.mRX Y:self.mRY Z:self.mRZ];
    [self setPosition:self.mPX Y:self.mPY Z:self.mPZ];
}

- (void)addChildObject:(SZTVideo *)obj;
{
    [self loadChildVideo:obj];
}

- (void)addChildObjectsWithURL:(NSMutableArray *)urlArr
{
    [self loadChildVideos:urlArr];
}

- (void)loadChildVideo:(SZTVideo *)obj
{
    [obj build];
    
    NSString *key_tag = [NSString stringWithFormat:@"%d",obj.tag];
    [_mutableDictionary setObject:obj.url forKey:key_tag];
    
    __weak typeof(self) weakSelf = self;
    [obj didIJKPlayerFirstFrameRenderBlock:^(SZTVideo * video) {
        int tag = video.tag;
        [video screenShotByIndex:1 screenDoneblock:^(NSString *path) {
            [weakSelf setVideoFirstImageView:path Tag:tag];
        }];
        
        [video pause];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [video removeObject];
        });
    }];
}

- (void)loadChildVideos:(NSMutableArray *)urlArr
{
    _urlArr = urlArr;
    
    if (_urlArr.count <= 0) {
        _urlArr = nil;
        return;
    }
    
    SZTVideo * obj = [[SZTVideo alloc] initIJKPlayerVideoWithURL:[_urlArr firstObject] VideoMode:SZTVR_PLANE isVideoToolBox:YES videoFrameMode:SZTVIDEO_DEFAULT];
    obj.tag = (int)_urlArr.count;
    [obj build];
    
    NSString *key_tag = [NSString stringWithFormat:@"%d",obj.tag];
    [_mutableDictionary setObject:obj.url forKey:key_tag];
    
    __weak typeof(self) weakSelf = self;
    [obj didIJKPlayerFirstFrameRenderBlock:^(SZTVideo * video) {
        int tag = video.tag;
        [video screenShotByIndex:1 screenDoneblock:^(NSString *path) {
            [weakSelf setVideoFirstImageView:path Tag:tag];
        }];
        
        [video pause];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [video removeObject];
            [weakSelf reloadVideoFromArr];
        });
    }];
}

- (void)reloadVideoFromArr
{
    [self.urlArr removeObjectAtIndex:0];
    [self loadChildVideos:_urlArr];
}

- (void)setVideoFirstImageView:(NSString *)path Tag:(int)tag
{
    SZTImageView *back = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    back.textureFilter = SZT_LINEAR_MIPMAP_LINEAR;
    [back setupTextureWithImage:[UIImage imageWithContentsOfFile:path]];
    back.tag = tag;
    
    [self.buttonArr addObject:back];
    
    self.row = [self getRow];
    [self removeAllObject];
    [self updateObject];
}

- (void)removeChildObjectByIndex:(int)index
{
    [self removeAllObject];
    [self removeObjectByIndex:index];
    
    if (self.buttonArr.count <= 0) {
        if (_selectVideo) {
            [_selectVideo removeObject];
            _selectVideo = nil;
        }
    }
    
    self.row = [self getRow];
    [self updateObject];
}

- (void)dealloc
{
    SZTLog(@"SZTVideoPreview dealloc");
    
    [self removeAllObject];
    self.buttonArr = nil;
    
    if (_selectVideo) {
        [_selectVideo removeObject];
        _selectVideo = nil;
    }
}

@end
