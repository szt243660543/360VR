//
//  Notice.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SZTObjectAddNotification @"sztObjectAddNotice"
#define SZTObject @"sztObject"
#define SZTObjectRemoveNotification @"sztObjectRemoveNotice"

/**
 * 耳机点击事件通知
 */
/** Play typeid:100*/
#define EventSubtypeRemoteControlPlay @"EventSubtypeRemoteControlPlay"
/** Pause typeid:101*/
#define EventSubtypeRemoteControlPause @"EventSubtypeRemoteControlPause"
/** Stop typeid:102*/
#define EventSubtypeRemoteControlStop @"EventSubtypeRemoteControlStop"
/** 单击暂停键 typeid:103*/
#define EventSubtypeRemoteControlTogglePlayPause @"EventSubtypeRemoteControlTogglePlayPause"
/** 双击暂停键 typeid:104*/
#define EventSubtypeRemoteControlNextTrack @"EventSubtypeRemoteControlNextTrack"
/** 三击暂停键 typeid:105*/
#define EventSubtypeRemoteControlPreviousTrack @"EventSubtypeRemoteControlPreviousTrack"
/** 单击,再按下不放 typeid:108*/
#define EventSubtypeRemoteControlBeginSeekingForward @"EventSubtypeRemoteControlBeginSeekingForward"
/** 单击,再按下不放,再放开 typeid:109*/
#define EventSubtypeRemoteControlEndSeekingForward @"EventSubtypeRemoteControlEndSeekingForward"

