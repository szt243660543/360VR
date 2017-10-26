//
//  SZTVideoTexture.h
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTTexture.h"
#if USE_IJK_PLAYER
#import <IJKMediaFramework/IJKMediaFramework.h>
#endif

@interface SZTVideoTexture : SZTTexture

/**
 * 创建视频纹理
 * @param playeritem 视频资源管理集
 * @return 纹理对象
 */
- (SZTTexture *)createWithAVPlayerItem:(AVPlayerItem *)playeritem;

/**
 * 创建视频纹理
 * @param player ijk播放器
 * @return 纹理对象
 */
#if USE_IJK_PLAYER
- (SZTTexture *)createWithIJKPlayer:(id<IJKMediaPlayback>)player;
#endif

/**
 * 销毁
 */
- (void)destory;

// 截屏
- (void)screenShotByIndex:(int)index VideoTag:(int)tag screenDoneblock:(void (^)(NSString *))block;

@end
