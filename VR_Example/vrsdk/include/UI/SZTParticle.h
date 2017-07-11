//
//  SZTParticle.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/9.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTRenderObject.h"

@interface SZTParticle : SZTRenderObject

- (instancetype)initWithParticleCount:(int)particleCount;

- (void)setupTextureWithImage:(UIImage *)imageName;

@property(nonatomic ,assign)int particleCount;

@end
