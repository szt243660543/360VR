//
//  SZT_KeyBoardBarDemo.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/17.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_TextViewDemo.h"
#import "SZTLibrary.h"
#import "SZTTextView.h"
#import "SZTKeyBoardBar.h"
#import "SZTImageView.h"

@interface SZT_TextViewDemo ()<KeyBoardDelegate, SZTTextViewDelegate>

@property(nonatomic, strong)SZTLibrary *sztLibrary;
@property(nonatomic, strong)SZTTextView *textView;
@property(nonatomic, strong)SZTTextView *textView1;
@property(nonatomic, strong)SZTKeyBoardBar *keyBoard;

@end

@implementation SZT_TextViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    [self.sztLibrary setFocusPicking:YES];
    [self.sztLibrary distortionMode:SZTBarrelDistortion];
    
    SZTImageView *back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.sztLibrary addSubObject:back];
    
    _textView = [[SZTTextView alloc] init];
    [_textView setObjectSize:800.0 Height:200.0];
    [_textView setPosition:0.0 Y:5.0 Z:-35.0];
    _textView.delegate = self;
    _textView.lineNumber = 18;
    [self.sztLibrary addSubObject:_textView];
    
    _textView1 = [[SZTTextView alloc] init];
    [_textView1 setObjectSize:800.0 Height:200.0];
    [_textView1 setPosition:0.0 Y:10.0 Z:-35.0];
    [_textView1 HiddenShineBar:YES];
    _textView1.delegate = self;
    _textView1.lineNumber = 18;
    [self.sztLibrary addSubObject:_textView1];
    
    _keyBoard = [[SZTKeyBoardBar alloc] init];
    _keyBoard.delegate = self;
    [_keyBoard setPosition:0.0 Y:-5.0 Z:-25.0];
    [self.sztLibrary addSubObject:_keyBoard];
}

- (void)didTouchTextView:(SZTTextView *)textView
{
    if (textView == _textView) {
        [_textView HiddenShineBar:NO];
        [_textView1 HiddenShineBar:YES];
    }else{
        [_textView HiddenShineBar:YES];
        [_textView1 HiddenShineBar:NO];
    }
}

- (void)didTouchKeyString:(NSString *)string
{
    if ([string isEqualToString:@"delete"]) {
        if (!_textView.isShineBarHide) {
            [_textView removeLastText];
        }
        if (!_textView1.isShineBarHide) {
            [_textView1 removeLastText];
        }
    }else if([string isEqualToString:@"s_shift"]){
        [_keyBoard setKeyCapsLook:UpperCase];
    }else if([string isEqualToString:@"b_shift"]){
        [_keyBoard setKeyCapsLook:LowerCase];
    }else if([string isEqualToString:@"123"]){
        [_keyBoard setKeyCapsLook:NumberType];
    }else if([string isEqualToString:@"abc"]){
        [_keyBoard setKeyCapsLook:LowerCase];
    }else if ([string isEqualToString:@"return"]){
        
    }else{
        if (!_textView.isShineBarHide) {
            [_textView inputText:string];
        }
        if (!_textView1.isShineBarHide) {
            [_textView1 inputText:string];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
