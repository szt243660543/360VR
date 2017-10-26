//
//  SZTParticle3D.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/9.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTObject3D.h"

@interface SZTParticle3D : SZTObject3D
{
    GLuint _particleBuffer;
}

- (void)setupVBO_Render:(int)particleCount;

@property(nonatomic ,assign)int particleCount;

@end
