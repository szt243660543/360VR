//
//  BaseRenderView.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseRenderView : UIView
{
    EAGLContext *_context;

    GLint _backingWidth;
    GLint _backingHeight;
    
    GLuint m_framebuffer;
    GLuint m_colorRenderbuffer;
    GLuint m_depthRenderbuffer;
}

@property(nonatomic, assign)int screenNum;

@property(nonatomic, assign)BOOL isUsingMotion;

- (void)prepareToRener;

- (void)render;

- (void)didRener;

@end
