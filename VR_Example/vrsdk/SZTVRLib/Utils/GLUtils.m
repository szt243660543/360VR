//
//  GLUtils.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "GLUtils.h"
#import <OpenGLES/ES2/glext.h>

@implementation GLUtils

+ (GLuint)loadShader:(GLenum)type withFilepath:(NSString *)sharderFilepath
{
    NSError * error;
    
    NSString * sharderString = [NSString stringWithContentsOfFile:sharderFilepath encoding:NSUTF8StringEncoding error:&error];
    
    if (!sharderString) {
        SZTLog(@"Error: loading shader file: %@ %@", sharderFilepath, error.localizedDescription);
        
        return 0;
    }
    
    // 创建shader
    GLuint shader = glCreateShader(type);
    
    if (shader == 0) {
        SZTLog(@"Error:fail to create shader");
        return 0;
    }
    
    // 加载shader资源
    const char * shaderStringUTF8 = [sharderString UTF8String];
    GLint shaderStringLength = (GLint)[sharderString length];
    glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 编译shader
    glCompileShader(shader);
    
    // 检测编译状态
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1) {
            char * infoLog = malloc(sizeof(char) *infoLen);
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            SZTLog(@"Error compiling shader:\n%s\n", infoLog);
            
            free(infoLog);
        }
        
        glDeleteShader(shader);
        
        return 0;
    }
    
    return shader;
}

+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment isFilePath:(BOOL)isfile
{
    GLuint vertShader, fragShader;
    
    // Create and compile vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER content:shaderVertex isFilePath:isfile]) {
        SZTLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER content:shaderFragment isFilePath:isfile]) {
        SZTLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // 连接vertex和fragment shader成一个完整的program
    GLuint _glProgram = glCreateProgram();
    glAttachShader(_glProgram, vertShader);
    glAttachShader(_glProgram, fragShader);
    
    // Link program.
    if (![self linkProgram:_glProgram]) {
        SZTLog(@"Failed to link program: %d", _glProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_glProgram) {
            glDeleteProgram(_glProgram);
            _glProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_glProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_glProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return _glProgram;
}

+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type content:(NSString *)content  isFilePath:(BOOL)isfile
{
    GLint status;
    const GLchar *source;
    
    if (isfile) {
        source = (GLchar *)[[NSString stringWithContentsOfFile:content encoding:NSUTF8StringEncoding error:nil] UTF8String];
    }else{
        source = (GLchar *)[content UTF8String];
    }
    
    if (!source) {
        SZTLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        SZTLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

+ (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        SZTLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

+ (GLuint)setupTextureWithFileName:(NSString *)fileName TextureFilter:(SZTTextureFilter)textureFilter
{
    UIImage *image = [UIImage imageNamed:fileName];
    
    if (!image) {
        SZTLog(@"Fail to load image from path:%@",fileName);
        return -1;
    }
    
    return [self setupTextureWithImage:image TextureFilter:textureFilter];
}

+ (GLuint)setupTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter
{
    CGImageRef cgImageRef = [image CGImage];
    if (!cgImageRef) {
        SZTLog(@"Fail to load image!");
        return -1;
    }
    
    GLuint width = [self NextPot:(GLuint)CGImageGetWidth(cgImageRef)];
    GLuint height = [self NextPot:(GLuint)CGImageGetHeight(cgImageRef)];
    CGRect rect = CGRectMake(0, 0, width, height);
    
    GLubyte *imageData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGColorSpaceRelease(colorSpace);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextDrawImage(context, rect, cgImageRef);
    CGContextRelease(context);
    
    GLuint texture_id;
    glGenTextures(1, &texture_id);
    glBindTexture(GL_TEXTURE_2D, texture_id);
    
    [self setGLTextureMinFilter:textureFilter];
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    glGetError();
    glBindTexture(GL_TEXTURE_2D, 0);
    
    free(imageData);
    
    return texture_id;
}

+ (void)setGLTextureMinFilter:(SZTTextureFilter)textureFilter
{
    switch (textureFilter) {
        case SZT_LINEAR:
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            break;
        case SZT_NEAREST:
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            break;
        case SZT_LINEAR_MIPMAP_LINEAR:
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            break;
        case SZT_LINEAR_MIPMAP_NEAREST:
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
            break;
        case SZT_NEAREST_MIPMAP_LINEAR:
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_LINEAR);
            break;
        case SZT_NEAREST_MIPMAP_NEAREST:
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
            break;
        default:
            break;
    }
}

+ (int)NextPot:(int)n
{
    n--;
    n |= n >> 1; n |= n >> 2;
    n |= n >> 4; n |= n >> 8;
    n |= n >> 16;
    n++;
    
    return n;
}

+ (GLKMatrix4)GetRotateEulerMatrix:(float)x Y:(float)y Z:(float)z
{
    x *= (float)(M_PI / 180.0f);
    y *= (float)(M_PI / 180.0f);
    z *= (float)(M_PI / 180.0f);
    float cx = (float) cos(x);
    float sx = (float) sin(x);
    float cy = (float) cos(y);
    float sy = (float) sin(y);
    float cz = (float) cos(z);
    float sz = (float) sin(z);
    float cxsy = cx * sy;
    float sxsy = sx * sy;
    GLKMatrix4 matrix;
    matrix.m[0] = cy * cz;
    matrix.m[1] = -cy * sz;
    matrix.m[2] = sy;
    matrix.m[3] = 0.0f;
    matrix.m[4] = cxsy * cz + cx * sz;
    matrix.m[5] = -cxsy * sz + cx * cz;
    matrix.m[6] = -sx * cy;
    matrix.m[7] = 0.0f;
    matrix.m[8] = -sxsy * cz + sx * sz;
    matrix.m[9] = sxsy * sz + sx * cz;
    matrix.m[10] = cx * cy;
    matrix.m[11] = 0.0f;
    matrix.m[12] = 0.0f;
    matrix.m[13] = 0.0f;
    matrix.m[14] = 0.0f;
    matrix.m[15] = 1.0f;
    
    return matrix;
}

+ (GLKMatrix4)calculateMatrixFromQuaternion:(CMQuaternion*)quaternion orientation:(UIInterfaceOrientation)orientation
{
    GLKMatrix4 sensor = [GLUtils getRotationMatrixFromQuaternion:quaternion];
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            sensor = [GLUtils remapCoordinateSystem:sensor.m X:AXIS_MINUS_Y Y:AXIS_X];
            break;
        case UIInterfaceOrientationLandscapeRight:
            sensor = [GLUtils remapCoordinateSystem:sensor.m X:AXIS_Y Y:AXIS_MINUS_X];
            break;
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown://not support now
        default:
            break;
    }

    return sensor;
}

+(GLKMatrix4)remapCoordinateSystem:(float*)inR X:(int)X Y:(int)Y{
    return [GLUtils remapCoordinateSystemImpl:inR X:X Y:Y];
}

+ (GLKMatrix4)updateDeviceOrientation:(UIInterfaceOrientation)orientation
{
    GLKMatrix4 displayFromDevice = [self GetRotateEulerMatrix:0.0 Y:0.0 Z:-90.0];
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            displayFromDevice = [self GetRotateEulerMatrix:0.0 Y:0.0 Z:90.0];
            break;
        case UIInterfaceOrientationLandscapeRight:
            displayFromDevice = [self GetRotateEulerMatrix:0.0 Y:0.0 Z:-90.0];
            break;
        case UIInterfaceOrientationUnknown:
            break;
        case UIInterfaceOrientationPortrait:
            break;
        case UIInterfaceOrientationPortraitUpsideDown://not support now
            break;
        default:
            break;
    }
    
    return displayFromDevice;
}

/** Helper function to convert a rotation vector to a rotation matrix.
 *  Given a rotation vector (presumably from a ROTATION_VECTOR sensor), returns a
 *  9  or 16 element rotation matrix in the array R.  R must have length 9 or 16.
 *  If R.length == 9, the following matrix is returned:
 * <pre>
 *   /  R[ 0]   R[ 1]   R[ 2]   \
 *   |  R[ 3]   R[ 4]   R[ 5]   |
 *   \  R[ 6]   R[ 7]   R[ 8]   /
 *</pre>
 * If R.length == 16, the following matrix is returned:
 * <pre>
 *   /  R[ 0]   R[ 1]   R[ 2]   0  \
 *   |  R[ 4]   R[ 5]   R[ 6]   0  |
 *   |  R[ 8]   R[ 9]   R[10]   0  |
 *   \  0       0       0       1  /
 *</pre>
 *  @param rotationVector the rotation vector to convert
 *  @param R an array of floats in which to store the rotation matrix
 */
+ (GLKMatrix4)getRotationMatrixFromQuaternion:(CMQuaternion*)quaternion{
    
    float q0 = quaternion->w;
    float q1 = quaternion->x;
    float q2 = quaternion->y;
    float q3 = quaternion->z;
    
    float sq_q1 = 2 * q1 * q1;
    float sq_q2 = 2 * q2 * q2;
    float sq_q3 = 2 * q3 * q3;
    float q1_q2 = 2 * q1 * q2;
    float q3_q0 = 2 * q3 * q0;
    float q1_q3 = 2 * q1 * q3;
    float q2_q0 = 2 * q2 * q0;
    float q2_q3 = 2 * q2 * q3;
    float q1_q0 = 2 * q1 * q0;
    
    float r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
    r0 = 1 - sq_q2 - sq_q3;
    r1 = q1_q2 - q3_q0;
    r2 = q1_q3 + q2_q0;
    r3 = 0.0f;
    
    r4 = q1_q2 + q3_q0;
    r5 = 1 - sq_q1 - sq_q3;
    r6 = q2_q3 - q1_q0;
    r7 = 0.0f;
    
    r8 = q1_q3 - q2_q0;
    r9 = q2_q3 + q1_q0;
    r10 = 1 - sq_q1 - sq_q2;
    r11 = 0.0f;
    
    r12 = r13 = r14 = 0.0f;
    r15 = 1.0f;
    
    return GLKMatrix4Make(r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);
}

+(GLKMatrix4) remapCoordinateSystemImpl:(float*)inR X:(int)X Y:(int)Y {
    /*
     * X and Y define a rotation matrix 'r':
     *
     *  (X==1)?((X&0x80)?-1:1):0    (X==2)?((X&0x80)?-1:1):0    (X==3)?((X&0x80)?-1:1):0
     *  (Y==1)?((Y&0x80)?-1:1):0    (Y==2)?((Y&0x80)?-1:1):0    (Y==3)?((X&0x80)?-1:1):0
     *                              r[0] ^ r[1]
     *
     * where the 3rd line is the vector product of the first 2 lines
     *
     */
    GLKMatrix4 outMatrix4 = GLKMatrix4Identity;
    
    if ((X & 0x7C)!=0 || (Y & 0x7C)!=0)
        return outMatrix4;   // invalid parameter
    if (((X & 0x3)==0) || ((Y & 0x3)==0))
        return outMatrix4;   // no axis specified
    if ((X & 0x3) == (Y & 0x3))
        return outMatrix4;   // same axis specified
    
    // Z is "the other" axis, its sign is either +/- sign(X)*sign(Y)
    // this can be calculated by exclusive-or'ing X and Y; except for
    // the sign inversion (+/-) which is calculated below.
    int Z = X ^ Y;
    
    // extract the axis (remove the sign), offset in the range 0 to 2.
    const int x = (X & 0x3)-1;
    const int y = (Y & 0x3)-1;
    const int z = (Z & 0x3)-1;
    
    // compute the sign of Z (whether it needs to be inverted)
    const int axis_y = (z+1)%3;
    const int axis_z = (z+2)%3;
    if (((x^axis_y)|(y^axis_z)) != 0)
        Z ^= 0x80;
    
    const Boolean sx = (X>=0x80);
    const Boolean sy = (Y>=0x80);
    const Boolean sz = (Z>=0x80);
    
    float* outR = malloc(sizeof(float) * 16);
    
    // Perform R * r, in avoiding actual muls and adds.
    const int rowLength = 4; // 4 * 4
    for (int j=0 ; j<3 ; j++) {
        const int offset = j*rowLength;
        for (int i=0 ; i<3 ; i++) {
            if (x==i)   outR[offset+i] = sx ? -inR[offset+0] : inR[offset+0];
            if (y==i)   outR[offset+i] = sy ? -inR[offset+1] : inR[offset+1];
            if (z==i)   outR[offset+i] = sz ? -inR[offset+2] : inR[offset+2];
        }
    }
    
    outR[3] = outR[7] = outR[11] = outR[12] = outR[13] = outR[14] = 0;
    outR[15] = 1;
    outMatrix4 = GLKMatrix4MakeWithArray(outR);
    free(outR);
    return outMatrix4;
}

@end
