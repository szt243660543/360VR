//
//  YUVTexture.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUVData.h"

@interface YUVTexture : NSObject

- (void)renderTextureBuffer:(YUVData *)yuvData;

@end
