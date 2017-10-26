//
//  CameraViewController.m
//  SZTVR_SDK
//
//  Created by szt on 2017/4/27.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "CameraViewController.h"
#import "DeviceManager.h"
#import "RenderEngine.h"
#import "LocalCameraUtil.h"

@interface CameraViewController ()

@property (nonatomic , strong)LocalCameraUtil *cameraUtil;

@property(nonatomic, strong)UIView *renderView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.renderView = [[RenderEngine sharedRenderEngine] renderView:self.view.frame];
    [self.view addSubview:self.renderView];

    [[RenderEngine sharedRenderEngine] openLocalCamera];
    
//    [self loadControlPoint];
    
    [self loadModel];
}

- (void)loadControlPoint
{
    int count = 12;
    
    float angle = 360/count;
    
    for(int i = 0; i < count; i++)
    {
        float displacement1 = 40.0*sin(2*ES_PI/count*i);
        float displacement2 = 40.0*cos(2*ES_PI/count*i);
        
        SZTLabel *label = [[SZTLabel alloc] init];
        label.tag = count - i;
        label.lineNumber = 2.0;
        label.isOpaque = YES;
        [label setText:[NSString stringWithFormat:@"%d",label.tag]];
        [label setObjectSize:50.0 Height:50.0];
        
        [label setPosition:displacement1 Y:0.0 Z:displacement2];
        [label setRotate:0.0 radiansY:180.0 + i *angle radiansZ:0.0];
        [[RenderEngine sharedRenderEngine] addSubObject:label];
        
        SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:label];
        
        [touch willTouchCallBack:^(GLKVector3 vec) {
            SZTLog(@"will touch");
        }];
        
        [touch didTouchCallback:^(GLKVector3 vec) {
            SZTLog(@"did touch");
        }];
        
        [touch endTouchCallback:^(GLKVector3 vec) {
            SZTLog(@"end touch");
        }];
    }
}

- (void)loadModel
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tz.obj" ofType:nil];
    SZTObjModel * obj1 = [[SZTObjModel alloc] initWithPath:path];
    [obj1 setupTextureWithImage:[UIImage imageNamed:@"tz.jpg"]];
    [[RenderEngine sharedRenderEngine] addSubObject:obj1];
    [obj1 setPosition:10.0 Y:-10.0 Z:-25.0];
    
    [obj1 rotateTo:2.0*120 radiansX:0.0 radiansY:-360.0*120 radiansZ:0.0 finishBlock:^{
        
    }];
}

#pragma mark - Simple Editor

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
