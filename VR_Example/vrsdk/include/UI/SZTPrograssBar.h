//
//  SZTPrograssBar.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/10/12.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

// 进度条的模式只能为: SZTVR_PLANE

#import "SZTImageView.h"

@interface SZTPrograssBar : SZTImageView

@property(nonatomic, assign)float ratio;

@property(nonatomic, assign)AXIS dir;

/**
 * 设置进度条的进度, value值在0 ~ 1之间。
*/
- (void)seekTo:(float)ratio Dir:(AXIS)dir;

@end
