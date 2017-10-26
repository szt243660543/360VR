//
//  SZTPVRUtil.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface SZTPVRUtil : NSObject

+ (GLuint)SZGLLoadTexture:(NSString*)imagePath;

@end
