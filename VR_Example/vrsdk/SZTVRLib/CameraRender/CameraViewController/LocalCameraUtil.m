//
//  LocalCameraUtil.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/20.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "LocalCameraUtil.h"
#import "RenderEngine.h"
#import "DeviceManager.h"
#import "ImageTool.h"
#import "FileTool.h"

@interface LocalCameraUtil() <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t mProcessQueue;
    dispatch_queue_t videoDataHandleQueue;
}

@property (nonatomic , strong) AVCaptureSession *mCaptureSession;
@property (nonatomic , strong) AVCaptureDeviceInput *mCaptureDeviceInput;
@property (nonatomic , strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;
@property (nonatomic , strong) AVCaptureStillImageOutput *mStillImageOutput;
@property (nonatomic , strong) AVCaptureConnection *mVideoConnection;

@end

@implementation LocalCameraUtil

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupCaptureSession];
        
        [self setupVideoInput];
        
        [self setupVideoDataOutput];
        
        [self setupCaptureStillImageOutput];
    }
    
    return self;
}

- (BOOL)setupCaptureSession
{
    if (!self.mCaptureSession) {
        self.mCaptureSession = [[AVCaptureSession alloc] init];
        
        // default capture
        [self setCaptureSessionPreset:SessionPreset1920x1080];
        
        if (!self.mCaptureSession){
            return NO;
        }
    }
    
    return YES;
}

- (void)setCaptureSessionPreset:(SZTSessionPreset)sessionPreset
{
    switch (sessionPreset) {
        case SessionPreset640x480:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset640x480;
            [RenderEngine sharedRenderEngine].renderView.captureWidth = 480.0;
            [RenderEngine sharedRenderEngine].renderView.captureHeight = 640.0;
            break;
        case SessionPreset1280x720:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
            [RenderEngine sharedRenderEngine].renderView.captureWidth = 720.0;
            [RenderEngine sharedRenderEngine].renderView.captureHeight = 1280.0;
            break;
        case SessionPreset1920x1080:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
            [RenderEngine sharedRenderEngine].renderView.captureWidth = 1080.0;
            [RenderEngine sharedRenderEngine].renderView.captureHeight = 1920.0;
            break;
        case SessionPreset3840x2160:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset3840x2160;
            [RenderEngine sharedRenderEngine].renderView.captureWidth = 2160.0;
            [RenderEngine sharedRenderEngine].renderView.captureHeight = 3840.0;
            break;
        default:
            break;
    }
}

- (BOOL)setupVideoInput
{
    BOOL success;
    AVCaptureDevice *videoDevice = [DeviceManager backCamera];
    
    AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    if ((success = [self.mCaptureSession canAddInput:videoIn]))
    {
        [self.mCaptureSession addInput:videoIn];
    }
    
    videoDataHandleQueue = dispatch_queue_create("video data handle", DISPATCH_QUEUE_SERIAL);
    if (!videoDataHandleQueue) {
        return NO;
    }
    
    return success;
}

- (BOOL)setupVideoDataOutput
{
    BOOL success = NO;
    if (self.mCaptureSession){
        
        self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:YES];
        
        //        [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        mProcessQueue = dispatch_get_main_queue();
        [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mProcessQueue];
        
        if ((success = [self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput])) {
            [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
        }
        
        AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    return success;
}

- (BOOL)setupCaptureStillImageOutput
{
    BOOL success = NO;
    
    //建立 AVCaptureStillImageOutput
    self.mStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,nil];
    [self.mStillImageOutput setOutputSettings:outputSettings];
    
    if ((success = [self.mCaptureSession canAddOutput:self.mStillImageOutput])) {
        [self.mCaptureSession addOutput:self.mStillImageOutput];
    }
    
    self.mVideoConnection = [self.mStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.mVideoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    
    return success;
}

- (void)startRunning
{
    [self.mCaptureSession startRunning];
}

- (void)stopRunning
{
    [self.mCaptureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    [[RenderEngine sharedRenderEngine].renderView displayCameraSampleBuffer:sampleBuffer];
}

- (void)takePhotosByIndex:(int)index screenDoneblock:(void (^)(NSString *))block
{
    //撷取影像（包含拍照音效）
    [self.mStillImageOutput captureStillImageAsynchronouslyFromConnection:self.mVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

        //完成撷取时的处理程序(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

            //取得的静态影像
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            UIImage *imageN = [ImageTool imageRotate:image rotation:UIImageOrientationRight];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *imageName = [NSString stringWithFormat:@"takePhotoes_%d.png", index];
                NSString *pngPath = [[FileTool createFilePathWithName:@"Downloaded"] stringByAppendingPathComponent:imageName];
                [UIImagePNGRepresentation(imageN) writeToFile:pngPath atomically:YES];

                dispatch_async(dispatch_get_main_queue(), ^{
                    block(pngPath);
                });
            });

        }
    }];
}

@end
