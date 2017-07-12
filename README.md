# 360 VR
This is a small VR library that can quickly help you build VR app. 
(As the project contains the ijkplayer, so the project a little big, please be patient to download!)(90Mb)

# Warning
不支持模拟器，请在真机下测试。（模拟器下会报错）

# Example Preview
![image](https://github.com/szt243660543/360VR/blob/master/VR_Example/allexample.png )   

# 如何使用sdk: SZTLibrary.h
```
    // create sdk 两种实例话sdk都可以
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    
    or
    
    self.sztLibrary = [[SZTLibrary alloc] initWithView:self.view];
```

# 1、AVPlayer播放器 - 模式切换／滤波器切换
# 2、ijkPlayer播放器
![image](https://github.com/szt243660543/360VR/blob/master/player1.png )![image](https://github.com/szt243660543/360VR/blob/master/player2.jpg )  </br>

```
// 渲染模型
typedef NS_ENUM(NSInteger, SZTRenderModel) {
    SZTVR_2D,                                   // 2d
    SZTVR_SPHERE,                               // 全景
    SZTVR_STEREO_HEMISPHERE,                    // 3D180(左右格式)
    SZTVR_STEREO_SPHERE,                        // 立体全景(上下格式)
    SZTVR_PLANE,                                // 平面
    SZTVR_DOME180,                              // 圆顶180
    SZTVR_STEREO_PLANE_LEFT_RIGHT,              // 立体平面 - 上下
    SZTVR_STEREO_PLANE_UP_DOWN,                 // 立体平面 - 左右
    SZTVR_FISHSPHERE_HIGH,                      // 960 * 2560
    SZTVR_FISHSPHERE_RETINA_HIGH,               // 1520 * 2688
    SZTVR_FISHSPHERE_MEDIUM,                    // 960 * 1920
    SZTVR_FISHSPHERE_RETINA_MEDIUM,             // 1080 * 1920
    SZTVR_3D_MODEL,                             // 3D模型
    SZTVR_CURVEDSURFACE,                        // 曲面屏幕 - 不规则曲面(5面)
    SZTVR_SECTOR,                               // 扇形曲面 - 平滑曲面
};

typedef NS_ENUM(NSInteger, SZTFilterMode) {
    SZTVR_NORMAL,           // 普通
    SZTVR_LUMINANCE,        // 像素色值亮度平均，图像黑白 (黑白效果)
    SZTVR_PIXELATE,         // 马赛克
    SZTVR_EXPOSURE,         // 曝光 (美白)
    SZTVR_DISCRETIZE,       // 离散
    SZTVR_BLUR,             // 模糊
    SZTVR_BILATERAL,        // 双边模糊
    SZTVR_HUE,              // 饱和度 
    SZTVR_POLKADOT,         // 像素圆点花样
    SZTVR_GAMMA,            // 伽马线
    SZTVR_GLASSSPHERE,      // 水晶球效果
    SZTVR_CROSSHATCH,       // 法线交叉线
};

```

# 3、单双屏切换
```
typedef NS_ENUM(NSInteger, SZTModeDisplay) {
    SZTModeDisplayNormal,   // 普通模式
    SZTModeDisplayGlass,    // 分屏模式
};


/**
 * 设置单双屏幕模式  － 默认分屏
 */
- (void)dispalyMode:(SZTModeDisplay)mode;

// 使用方法
[self.SZTLibrary dispalyMode:SZTModeDisplayNormal];

```

# 4、陀螺仪/触摸屏/陀A触
```
typedef NS_ENUM(NSInteger, SZTModeInteractive) {
    SZTModeInteractiveTouch,            // 触摸
    SZTModeInteractiveMotion,           // 陀螺仪
    SZTModeInteractiveMotionWithTouch,  // 陀螺仪和触摸
};

/**
 * 设置交互模式  － 默认陀螺仪
 */
- (void)interactiveMode:(SZTModeInteractive)mode;

// 使用方法
[self.SZTLibrary interactiveMode:SZTModeInteractiveMotion];

```

# 5、移动／缩放／旋转／贝塞尔
![image](https://github.com/szt243660543/360VR/blob/master/animation.gif )  </br>

# 6、图片加载 - 网络／本地图
![image](https://github.com/szt243660543/360VR/blob/master/IMG_5422.PNG )  </br>

# 7、Gif / APng动图加载

# 8、Obj模型加载 / MD2模型加载
![image](https://github.com/szt243660543/360VR/blob/master/objmd2.gif )  </br>

# 9、3D立体音效 - openAl

# 10、畸变矫正
![image](https://github.com/szt243660543/360VR/blob/master/jibian.jpg )  </br>

```
typedef NS_ENUM(NSInteger, SZTDistortion) {
    SZTDistortionNormal,   // 无畸变
    SZTBarrelDistortion,   // 桶形畸变模式
};

/**
 * 畸变模式 - 默认无畸变
 */
- (void)distortionMode:(SZTDistortion)mode;

// 使用方法
[self.SZTLibrary distortionMode:SZTDistortionNormal];

```

# 11、Label控件/大量弹幕

# 12、进度条控件

# 13、焦点拾取/点击拾取

# 14、输入框控件

# 15、更多高级控件


## 加入我们
我们会不定期的更新sdk，加入更多新功能，大家有新的需要或好的想法，欢迎大家加入群一起讨论。
* 邮箱 :szt243660543@sina.com
* QQ 群 :174962747
