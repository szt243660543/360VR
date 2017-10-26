//
//  SZTVideoData.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#if USE_IJK_PLAYER
#import <IJKMediaFramework/IJKMediaFramework.h>
#endif

@interface SZTVideoData : NSObject

@property (nonatomic, assign)BOOL isijkPlayer;

/**
 * 实例化视频资源管理集
 * @param playerItem 视频资源
 */
- (instancetype)initWithPlayerItem:(AVPlayerItem*)playerItem;

/**
 * 实例化视频资源
 * @param player IJK播放器
 */
#if USE_IJK_PLAYER
- (instancetype)initWithIJKPlayer:(id<IJKMediaPlayback>)player;
#endif

/**
 * @return 返回输出的pixel
 */
- (CVPixelBufferRef)copyPixelBuffer;

- (void)lockPixelBuffer;

- (void)unlockPixelBuffer;

@end
