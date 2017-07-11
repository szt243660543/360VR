# 360 VR
This is a small VR library that can quickly help you build VR app. 
(As the project contains the ijkplayer, so the project alittle big, please be patient to download!)(90Mb)

# Example Preview
![image](https://github.com/szt243660543/360VR/blob/master/VR_Example/allexample.png )   


# avplayer example
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create sdk 两种实例话sdk都可以
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    // self.sztLibrary = [[SZTLibrary alloc] initWithView:self.view];
    
    
    // add avplayer to sdk 
    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:itemPath];
    //    NSURL *url = [NSURL URLWithString:@"http://vrkongfu.oss-cn-hangzhou.aliyuncs.com/movie/111mobile.mp4"];
    
    self.sztVideo = [[SZTVideo alloc] initAVPlayerVideoWithURL:url VideoMode:SZTVR_SPHERE];
    self.sztVideo.delegate = self;
    [self.sztLibrary addSubObject:self.sztVideo];
}
```


# 图片加载 - 网络／本地图
![image](https://github.com/szt243660543/360VR/blob/master/IMG_5422.PNG )  </br>


## 加入我们
我们会不定期的更新sdk，加入更多新功能，大家有新的需要或好的想法，欢迎大家加入群一起讨论。
* 邮箱 :szt243660543@sina.com
* QQ 群 :174962747
