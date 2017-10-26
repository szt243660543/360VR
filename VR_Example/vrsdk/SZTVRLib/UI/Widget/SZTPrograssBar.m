//
//  SZTPrograssBar.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/10/12.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTPrograssBar.h"
#import "Shader_Progress.h"

@implementation SZTPrograssBar

- (void)changeFilter:(SZTFilterMode)filterMode
{
    self.filterMode = filterMode;
    
    [self resetProgram];
    
    self.program = [[SZTProgram alloc] init];
    
    [self.program loadShaders:ProgressVertexShaderString FragShader:ProgressFragmentShaderString isFilePath:NO];
}

- (void)resetProgram
{
    if (self.program) [self.program destory];
    self.program = nil;
}

- (void)seekTo:(float)ratio Dir:(AXIS)dir
{
    self.ratio = ratio;
    self.dir = dir;
}

- (void)progressBarData
{
    glUniformMatrix4fv(self.program.MMatrixHandle, 1, 0, self.mModelMatrix.m);
    
    switch (self.dir) {
        case X:{
            float p_min = - self.objSize.width/100.0;
            glUniform1f([self.program uniformIndex:@"uStartPosition"], p_min);
            float p_current = p_min + self.ratio * self.objSize.width /50.0;
            glUniform1f([self.program uniformIndex:@"uLpos"], p_current);
            glUniform1f([self.program uniformIndex:@"uisDirX"], 0.0);
        }
            break;
        case Y:{
            float p_min = - self.objSize.height /100.0;
            glUniform1f([self.program uniformIndex:@"uStartPosition"], p_min);
            
            float p_current = p_min + self.ratio * self.objSize.height/50.0;
            glUniform1f([self.program uniformIndex:@"uLpos"], p_current);
            glUniform1f([self.program uniformIndex:@"uisDirX"], 2.0);
        }
            break;
        default:
            break;
    }
}


@end
