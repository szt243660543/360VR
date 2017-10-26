//
//  FishSpec.h
//  Pods
//
//  Created by SZTvr on 16/6/6.
//
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, Resolution){
    HIGH,           // 960 * 2560
    MEDIUM,         // 960 * 1920
    RETINA_HIGH,    // 1520 * 2688
    RETINA_MEDIUM,  // 1080 * 1920
};
@interface FishSpec : NSObject

@property (nonatomic , strong) NSMutableArray* pol;
@property (nonatomic , strong) NSMutableArray* invpol;
@property (nonatomic , assign) double xc;
@property (nonatomic , assign) double yc;

@property (nonatomic , assign) double c;
@property (nonatomic , assign) double d;
@property (nonatomic , assign) double e;

@property (nonatomic , assign) int width;
@property (nonatomic , assign) int height;

@property (nonatomic , assign) float factor1;
@property (nonatomic , assign) float factor2;

- (void)build:(BOOL)isLeft Resolution:(Resolution)resolution;
@end
