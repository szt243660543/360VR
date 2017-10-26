//
//  SZTStorageBar.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/10/15.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTRenderObject.h"

@protocol SZTStorageBarDelegate <NSObject>

- (void)didSelectObjectByIndex:(int)index;

@end

@interface SZTStorageBar : SZTRenderObject

- (void)setupTextureWithImage:(UIImage *)image;

- (void)addChildsWithImages:(NSMutableArray *)imageArr;

@property(nonatomic, strong)SZTImageView *mainButton;

@property(nonatomic, weak)id <SZTStorageBarDelegate> delegate;

@end
