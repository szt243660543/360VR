//
//  SZT_AlertViewDemo.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_LabelDemo.h"
#import "SZTLibrary.h"
#import "SZTLabel.h"

#define ColorRBG(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RandomColor ColorRBG(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))

#define RandomNumber(from, to) (int)(from + (arc4random() % (to - from + 1)))

@interface SZT_LabelDemo ()

@property(nonatomic, strong)SZTLibrary * sztLibrary;

@end

@implementation SZT_LabelDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    
    [self danmu];
}

- (void)danmu
{
    for (int i = 0; i < 100; i++) {
        SZTLabel *label = [[SZTLabel alloc] init];
        label.fontColor = RandomColor;
        label.lineNumber = 12.0;
        [label setText:[NSString stringWithFormat:@"VRSDK_弹幕_%d",i]];
        [label setObjectSize:300.0 Height:30.0];
        
        [label setPosition:RandomNumber(-10, 40) Y:RandomNumber(-10, 10) Z:RandomNumber(-25, -10)];
        [self.sztLibrary addSubObject:label];
        
        [label moveTo:40.0 PosX:-100.0 posY:label.pY posZ:label.pZ finishBlock:^{
            [label removeObject];
        }];
    }
}


@end
