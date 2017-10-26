//
//  SZTBaseUIView.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/31.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTBaseObject.h"

@interface SZTBaseCollectionView : SZTBaseObject

@property(nonatomic, strong)UIColor *backgroundColor;

/**
 * 子控件之间的间距X,Y
 */
@property(nonatomic, assign)int spacingX;
@property(nonatomic, assign)int spacingY;

/**
 * 子控件之间的宽高
 */
@property(nonatomic, assign)float width;
@property(nonatomic, assign)float height;

/**
 * 每列按钮的数量
 */
@property(nonatomic, assign)int column;

/**
 * 每行按钮的数量
 */
@property(nonatomic, assign)int row;

/**
 * 当前界面显示行数量
 */
@property(nonatomic, assign)int showRow;

@property(nonatomic, assign)float showDistance;

/** 每个子控件的rect */
- (void)setChildObjectRect:(float)width Height:(float)height;

- (void)setPosition:(float)x Y:(float)y Z:(float)z;

- (void)setRotate:(float)radians X:(float)x Y:(float)y Z:(float)z;

- (void)setScale:(float)x Y:(float)y Z:(float)z;

/** all child objects move without noMoveObject**/
- (void)moveAnimate:(float)time X:(float)x Y:(float)y Z:(float)z noMoveObject:(SZTImageView *)obj block:(void (^)(void))block;

/** get current row*/
- (int)getRow;

- (void)removeAllObject;
- (void)removeObjectByIndex:(int)index;

@property(nonatomic, assign)float mPX;
@property(nonatomic, assign)float mPY;
@property(nonatomic, assign)float mPZ;

@property(nonatomic, assign)float mRadians;
@property(nonatomic, assign)float mRX;
@property(nonatomic, assign)float mRY;
@property(nonatomic, assign)float mRZ;

@property(nonatomic, assign)int moveY;
@property(nonatomic, strong)SZTImageView *backGroundView;
@property(nonatomic, strong)NSMutableArray *buttonArr;

@end
