//
//  SZT_3DModel.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_3DModel.h"
#import "SZTLibrary.h"
#import "SZTMD2Model.h"
#import "SZTImageView.h"
#import "SZTObjModel.h"

@interface SZT_3DModel ()
{
    SZTImageView *imageV;
    SZTImageView *imageV1;
}

@property(nonatomic, strong)SZTLibrary * sztLibrary;

@end

@implementation SZT_3DModel

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadButton];
    
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"MD2" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(110, self.view.frame.size.height - 50, 100, 50)];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"Obj" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)click
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Squelette.md2" ofType:nil];
    SZTMD2Model * obj1 = [[SZTMD2Model alloc] initWithPath:path];
    [obj1 setupTextureWithImage:[UIImage imageNamed:@"Squelette.jpg"]];
    [self.sztLibrary addSubObject:obj1];
    [obj1 setPosition:10.0 Y:-10.0 Z:-75.0];
    [obj1 setRotate:-90 radiansY:0 radiansZ:-90];
}

- (void)click1
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cole.obj" ofType:nil];
    SZTObjModel * obj1 = [[SZTObjModel alloc] initWithPath:path];
    [obj1 setupTextureWithImage:[UIImage imageNamed:@"cole.jpeg"]];
    [self.sztLibrary addSubObject:obj1];
    [obj1 setPosition:-10.0 Y:0.0 Z:-20.0];
    
    [obj1 rotateTo:2.0*120 radiansX:0.0 radiansY:360.0*120 radiansZ:0.0 finishBlock:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
