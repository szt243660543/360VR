//
//  SZTViewController.m
//  VR_Example
//
//  Created by szt on 2017/7/11.
//  Copyright © 2017年 VR. All rights reserved.
//

#import "SZTViewController.h"
#import "SZT_AVPlayerDemo.h"
#import "SZT_IJKPlayerDemo.h"
#import "SZT_ModeDisplayDemo.h"
#import "SZT_ModeInteractiveDemo.h"
#import "SZT_Animation3DDemo.h"
#import "SZT_ImageViewDemo.h"
#import "SZT_GifDemo.h"
#import "SZT_3DModel.h"
#import "SZT_DistortionDemo.h"
#import "SZT_3DAudio.h"
#import "SZT_LabelDemo.h"
#import "SZT_TouchDemo.h"

@interface SZTViewController ()

@end

@implementation SZTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"////*****VR_SDK_Demo*****////";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"AVPlayer播放器 - 模式切换／滤波器切换";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"IJKPlayer播放器";
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"单双屏切换";
    }else if(indexPath.row == 4){
        cell.textLabel.text = @"陀螺仪/触摸屏/陀A触";
    }else if(indexPath.row == 5){
        cell.textLabel.text = @"移动／缩放／旋转／贝塞尔";
    }else if(indexPath.row == 6){
        cell.textLabel.text = @"图片加载 - 网络／本地图";
    }else if(indexPath.row == 7){
        cell.textLabel.text = @"Gif / APng动图加载";
    }else if (indexPath.row == 8){
        cell.textLabel.text = @"3D模型加载 / MD2模型加载";
    }else if (indexPath.row == 9){
        cell.textLabel.text = @"3D立体音效";
    }else if (indexPath.row == 10){
        cell.textLabel.text = @"畸变矫正";
    }else if (indexPath.row == 11){
        cell.textLabel.text = @"Label控件/大量弹幕";
    }else if (indexPath.row == 12){
        cell.textLabel.text = @"进度条控件";
    }else if (indexPath.row == 13){
        cell.textLabel.text = @"焦点拾取/点击拾取";
    }else if (indexPath.row == 14){
        cell.textLabel.text = @"输入框控件";
    }else if (indexPath.row == 15){
        cell.textLabel.text = @"更多高级控件";
    }else{
        cell.textLabel.text = @"////*****VR_SDK_Demo*****////";
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        SZT_AVPlayerDemo *avPlayer = [[SZT_AVPlayerDemo alloc] init];
        [self presentViewController:avPlayer animated:YES completion:nil];
    }else if(indexPath.row == 2){
        SZT_IJKPlayerDemo *ijkPlayer = [[SZT_IJKPlayerDemo alloc] init];
        [self presentViewController:ijkPlayer animated:YES completion:nil];
    }else if(indexPath.row == 3){
        SZT_ModeDisplayDemo *modeDisplay = [[SZT_ModeDisplayDemo alloc] init];
        [self presentViewController:modeDisplay animated:YES completion:nil];
    }else if(indexPath.row == 4){
        SZT_ModeInteractiveDemo *modeInteractive = [[SZT_ModeInteractiveDemo alloc] init];
        [self presentViewController:modeInteractive animated:YES completion:nil];
    }else if(indexPath.row == 5){
        SZT_Animation3DDemo *animation3D = [[SZT_Animation3DDemo alloc] init];
        [self presentViewController:animation3D animated:YES completion:nil];
    }else if(indexPath.row == 6){
        SZT_ImageViewDemo *imageView = [[SZT_ImageViewDemo alloc] init];
        [self presentViewController:imageView animated:YES completion:nil];
    }else if(indexPath.row == 7){
        SZT_GifDemo *gif = [[SZT_GifDemo alloc] init];
        [self presentViewController:gif animated:YES completion:nil];
    }else if(indexPath.row == 8){
        SZT_3DModel *modeldemo = [[SZT_3DModel alloc] init];
        [self presentViewController:modeldemo animated:YES completion:nil];
    }else if(indexPath.row == 9){
        SZT_3DAudio *audiodemo = [[SZT_3DAudio alloc] init];
        [self presentViewController:audiodemo animated:YES completion:nil];
    }else if(indexPath.row == 10){
        SZT_DistortionDemo *distortion = [[SZT_DistortionDemo alloc] init];
        [self presentViewController:distortion animated:YES completion:nil];
    }else if(indexPath.row == 11){
        SZT_LabelDemo *label = [[SZT_LabelDemo alloc] init];
        [self presentViewController:label animated:YES completion:nil];
    }else if (indexPath.row == 12){
        
    }else if (indexPath.row == 13){
        SZT_TouchDemo *touch = [[SZT_TouchDemo alloc] init];
        [self presentViewController:touch animated:YES completion:nil];
    }else if (indexPath.row == 14){
        
    }else if (indexPath.row == 15){
        
    }
}

- (void)dealloc
{
    
}

@end
