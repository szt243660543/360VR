//
//  SZT_Animation3DDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_Animation3DDemo.h"
#import "SZTLibrary.h"
#import "SZTImageView.h"

@interface SZT_Animation3DDemo()
{
    
}

@property(nonatomic, strong)SZTLibrary *SZTLibrary;
@property(nonatomic, strong)SZTImageView *imgv;

@end

@implementation SZT_Animation3DDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadButton];
    
    self.SZTLibrary = [[SZTLibrary alloc] initWithController:self];
    self.SZTLibrary.fps = 30;
    
    SZTImageView * back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.SZTLibrary addSubObject:back];
    
    // 网络路径
    _imgv = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [_imgv setupTextureWithImage:[UIImage imageNamed:@"pic.jpg"]];
    [self.SZTLibrary addSubObject:_imgv];
    [_imgv setPosition:0.0 Y:0.0 Z:-15.0];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"移动" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moveAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height - 50, 50, 50)];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"旋转" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(rotateAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(120, self.view.frame.size.height - 50, 50, 50)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"缩放" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(180, self.view.frame.size.height - 50, 100, 50)];
    button3.backgroundColor = [UIColor redColor];
    [button3 setTitle:@"二次贝塞尔" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(bezierAnimation1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(290, self.view.frame.size.height - 50, 100, 50)];
    button4.backgroundColor = [UIColor redColor];
    [button4 setTitle:@"三次贝塞尔" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(bezierAnimation2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
}

- (void)moveAnimation
{
    // moveTo / moveBY
    [_imgv moveTo:1.0 PosX:5.0 posY:5.0 posZ:-10 finishBlock:^{
        [_imgv moveTo:1.0 PosX:0.0 posY:0.0 posZ:-15 finishBlock:^{
        
        }];
    }];
}

- (void)rotateAnimation
{
    [_imgv rotateTo:1.0 radiansX:50.0 radiansY:0.0 radiansZ:0.0 finishBlock:^{
        [_imgv rotateTo:1.0 radiansX:-50.0 radiansY:0.0 radiansZ:0.0 finishBlock:^{
            
        }];
    }];
}

- (void)scaleAnimation
{
    // scaleTo / scaleBY
    [_imgv setScale:0.0 Y:0.0 Z:0.0];
    [_imgv scaleTo:1.0 scaleX:1.0 scaleY:1.0 scaleZ:1.0 finishBlock:^{
        
    }];
}

- (void)bezierAnimation1
{
    Point3D pointEnd;
    pointEnd.x =-10.0;
    pointEnd.y =-15.0;
    pointEnd.z = -15.0;
    
    Point3D point1;
    point1.x = 8.0;
    point1.y = -5.0;
    point1.z = -15.0;
    
    Point3D pointEnd1;
    pointEnd1.x = 0.0;
    pointEnd1.y = 0.0;
    pointEnd1.z =-15.0;

    [_imgv bezierTo:2.0 PointEnd:pointEnd ControlPoint1:point1 finishBlock:^{
        [_imgv bezierTo:2.0 PointEnd:pointEnd1 ControlPoint1:point1 finishBlock:^{
            
        }];
    }];
}

- (void)bezierAnimation2
{
    Point3D pointEnd;
    pointEnd.x =-2.0;
    pointEnd.y =-1.0;
    pointEnd.z =-5.0;
    
    Point3D point1;
    point1.x = 10.0;
    point1.y = 10.0;
    point1.z = -3.0;
    
    Point3D point2;
    point2.x = -10.0;
    point2.y = -10.0;
    point2.z = -2.0;
    
    Point3D pointEnd1;
    pointEnd1.x = 0.0;
    pointEnd1.y = 0.0;
    pointEnd1.z =-15.0;
    
    [_imgv bezierTo:2.0 PointEnd:pointEnd ControlPoint1:point1 ControlPoint2:point2 finishBlock:^{
        [_imgv bezierTo:2.0 PointEnd:pointEnd1 ControlPoint1:point2 ControlPoint2:point1 finishBlock:^{
            
        }];
    }];
}

@end
