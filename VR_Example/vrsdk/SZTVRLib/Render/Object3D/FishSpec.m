//
//  FishSpec.m
//  Pods
//
//  Created by SZTvr on 16/6/6.
//
//
#import "FishSpec.h"

@implementation FishSpec

-(NSMutableArray *)pol
{
    if (!_pol) {
        _pol = [NSMutableArray array];
    }
    
    return _pol;
}

-(NSMutableArray *)invpol
{
    if (!_invpol) {
        _invpol = [NSMutableArray array];
    }
    
    return _invpol;
}

-(void)build:(BOOL)isLeft Resolution:(Resolution)resolution{
    switch (resolution) {
        case HIGH:{
            _xc = isLeft?669.113:682.103;
            _width = 1280;
            _factor1 = 0.7f;
            _factor2 = 1.0f;
            [self setupCameraProperty:isLeft];
        }
            break;
        case RETINA_HIGH:
            [self setupRetina_High_CameraProperty:isLeft];
            break;
        case MEDIUM:{
            _xc = isLeft?490.053769:488.260160;
            _width = 960;
            _factor1 = 0.7f;
            _factor2 = 0.75f;
            [self setupCameraProperty:isLeft];
        }
            break;
        case RETINA_MEDIUM:
            [self setupRetina_Medium_CameraProperty:isLeft];
            break;
        default:
            break;
    }
}

- (void)setupCameraProperty:(BOOL)isLeft
{
    [self.pol addObject:isLeft?@"-4.112142e+002":@"-4.088413e+002"];
    [self.pol addObject:@"0.000000e+000"];
    [self.pol addObject:isLeft?@"8.031053e-004":@"8.361239e-004"];
    [self.pol addObject:isLeft?@"1.354979e-007":@"-3.045934e-008"];
    [self.pol addObject:isLeft?@"4.082667e-010":@"6.487498e-010"];
    
    //_invpol[length__invpol++] = 9.0;
    [self.invpol addObject:isLeft?@"626.357865":@"619.278343"];
    [self.invpol addObject:isLeft?@"399.770322":@"383.020314"];
    [self.invpol addObject:isLeft?@"49.257831":@"30.769810"];
    [self.invpol addObject:isLeft?@"66.453461":@"58.741116"];
    [self.invpol addObject:isLeft?@"31.135458":@"28.171159"];
    [self.invpol addObject:isLeft?@"14.895897":@"9.795883"];
    [self.invpol addObject:isLeft?@"14.141212":@"12.180508"];
    [self.invpol addObject:isLeft?@"7.046863":@"8.00801"];
    [self.invpol addObject:isLeft?@"1.197045":@"1.675540"];
    
    _yc = isLeft?480:480;
    _c = isLeft?0.999649:0.999811;
    _d = isLeft?-0.000100:0.000165;
    _e = isLeft?-0.000030:0.000010;
    _height = 960;
}

- (void)setupRetina_High_CameraProperty:(BOOL)isLeft
{
    _yc = 777.652966;
    _xc = 658.409780;
    
    _width = 1344;
    _height = 1520;
    
    _factor1 = 1.0f;
    _factor2 = 1.0f;
    
    _c = 0.999997;
    _d = -0.000007;
    _e = 0.000295;
    
    [self.pol addObject:@"-4.746453e+02"];
    [self.pol addObject:@"0.000000e+00"];
    [self.pol addObject:@"1.029687e-03"];
    [self.pol addObject:@"-1.889939e-06"];
    [self.pol addObject:@"5.848928e-09"];
    [self.pol addObject:@"-7.910497e-12"];
    [self.pol addObject:@"4.819704e-15"];
    
    [self.invpol addObject:@"688.255450"];
    [self.invpol addObject:@"352.958304"];
    [self.invpol addObject:@"-86.342405"];
    [self.invpol addObject:@"19.240077"];
    [self.invpol addObject:@"58.648634"];
    [self.invpol addObject:@"-9.748540"];
    [self.invpol addObject:@"-40.362454"];
    [self.invpol addObject:@"21.033764"];
    [self.invpol addObject:@"36.602854"];
    [self.invpol addObject:@"-10.902732"];
    [self.invpol addObject:@"-20.615508"];
    [self.invpol addObject:@"0.648954"];
    [self.invpol addObject:@"5.866987"];
    [self.invpol addObject:@"1.497042"];
}

- (void)setupRetina_Medium_CameraProperty:(BOOL)isLeft
{
//    [self.pol addObject:@"-3.423164e+02"];
//    [self.pol addObject:@"0.000000e+00"];
//    [self.pol addObject:@"1.416588e-03"];
//    [self.pol addObject:@"-1.878745e-06"];
//    [self.pol addObject:@"3.704945e-09"];
//    
//    //_invpol[length__invpol++] = 12.0;
//    [self.invpol addObject:@"495.356915"];
//    [self.invpol addObject:@"271.887404"];
//    [self.invpol addObject:@"-16.272007"];
//    [self.invpol addObject:@"41.751162"];
//    [self.invpol addObject:@"21.021358"];
//    [self.invpol addObject:@"-6.357267"];
//    [self.invpol addObject:@"10.157503"];
//    [self.invpol addObject:@"11.491055"];
//    [self.invpol addObject:@"-3.282946"];
//    [self.invpol addObject:@"-3.107430"];
//    [self.invpol addObject:@"0.879494"];
//    [self.invpol addObject:@"0.530432"];
//    
//    _yc = 553.159735;
//    _xc = 471.450822;
//    
//    _c = 0.999550;
//    _d = 0.000004;
//    _e = 0.000071;
//    
//    _width = 960;
//    _height = 1080;
//    
//    _factor1 = 1.0f;
//    _factor2 = 1.0f;
    
    [self.pol addObject:@"-3.375280e+02"];
    [self.pol addObject:@"0.000000e+00"];
    [self.pol addObject:@"1.831860e-03"];
    [self.pol addObject:@"-3.740333e-06"];
    [self.pol addObject:@"4.545340e-09"];
    
    //_invpol[length__invpol++] = 12.0;
    [self.invpol addObject:@"543.685698"];
    [self.invpol addObject:@"340.375569"];
    [self.invpol addObject:@"-62.254012"];
    [self.invpol addObject:@"26.065714"];
    [self.invpol addObject:@"88.833031"];
    [self.invpol addObject:@"-93.695091"];
    [self.invpol addObject:@"-55.134848"];
    [self.invpol addObject:@"221.388278"];
    [self.invpol addObject:@"145.513123"];
    [self.invpol addObject:@"-175.143729"];
    [self.invpol addObject:@"-244.652056"];
    [self.invpol addObject:@"-107.253179"];
    [self.invpol addObject:@"-16.674877"];
    
    _yc = 1080 * 0.5;
    _xc = 960 * 0.5;
    
    _c = 1.001500;
    _d = -0.000476;
    _e = 0.000464;
    
    _width = 960;
    _height = 1080;
    
    _factor1 = 1.0f;
    _factor2 = 1.0f;//0.89f;
}

- (void)dealloc
{
    _pol = nil;
    _invpol = nil;
}

@end
