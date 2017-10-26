//
//  SZTModel.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/13.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTModel.h"

@implementation SZTModel

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        self.vectorArr = [[NSMutableArray alloc] init];
        
        // 解析数据
        [self analyticalData:path];
    }
    
    return self;
}

- (void)analyticalData:(NSString *)path
{
    NSError *error;
    
    NSString *objData = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    
    //set up storage
    NSMutableData *tempVertexData = [[NSMutableData alloc] init];
    NSMutableData *vertexData = [[NSMutableData alloc] init];
    NSMutableData *tempTextCoordData = [[NSMutableData alloc] init];
    NSMutableData *textCoordData = [[NSMutableData alloc] init];
    NSMutableData *tempNormalData = [[NSMutableData alloc] init];
    NSMutableData *normalData = [[NSMutableData alloc] init];
    NSMutableData *faceIndexData = [[NSMutableData alloc] init];
    
    //utility collections
    NSInteger uniqueIndexStrings = 0;
    NSMutableDictionary *indexStrings = [[NSMutableDictionary alloc] init];
    
    //scan through lines
    NSString *line = nil;
    NSScanner *lineScanner = [NSScanner scannerWithString:objData];
    do
    {
        //get line
        [lineScanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&line];
        NSScanner *scanner = [NSScanner scannerWithString:line];
        
        //get line type
        NSString *type = nil;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&type];
        
        if ([type isEqualToString:@"v"])
        {
            //vertex
            GLfloat coords[3];
            [scanner scanFloat:&coords[0]];
            [scanner scanFloat:&coords[1]];
            [scanner scanFloat:&coords[2]];
            [tempVertexData appendBytes:coords length:sizeof(coords)];
            
            point *pos = [[point alloc] init];
            pos.vertexPoint = GLKVector3Make(coords[0], coords[1], coords[2]);
            [self.vectorArr addObject:pos];
        }
        else if ([type isEqualToString:@"vt"])
        {
            //texture coordinate
            GLfloat coords[2];
            [scanner scanFloat:&coords[0]];
            [scanner scanFloat:&coords[1]];
            [tempTextCoordData appendBytes:coords length:sizeof(coords)];
        }
        else if ([type isEqualToString:@"vn"])
        {
            //normal
            GLfloat coords[3];
            [scanner scanFloat:&coords[0]];
            [scanner scanFloat:&coords[1]];
            [scanner scanFloat:&coords[2]];
            [tempNormalData appendBytes:coords length:sizeof(coords)];
        }
        else if ([type isEqualToString:@"f"])
        {
            //face
            int count = 0;
            NSString *indexString = nil;
            while (![scanner isAtEnd])
            {
                count ++;
                [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&indexString];
                
                NSArray *parts = [indexString componentsSeparatedByString:@"/"];
                
                GLuint fIndex = (GLuint)uniqueIndexStrings;
                NSNumber *index = indexStrings[indexString];
                if (index == nil)
                {
                    uniqueIndexStrings ++;
                    indexStrings[indexString] = @(fIndex);
                    
                    GLuint vIndex = [parts[0] intValue];
                    [vertexData appendBytes:tempVertexData.bytes + (vIndex - 1) * sizeof(GLfloat) * 3 length:sizeof(GLfloat) * 3];
                    
                    if ([parts count] > 1)
                    {
                        GLuint tIndex = [parts[1] intValue];
                        if (tIndex) [textCoordData appendBytes:tempTextCoordData.bytes + (tIndex - 1) * sizeof(GLfloat) * 2 length:sizeof(GLfloat) * 2];
                    }
                    
                    if ([parts count] > 2)
                    {
                        GLuint nIndex = [parts[2] intValue];
                        if (nIndex) [normalData appendBytes:tempNormalData.bytes + (nIndex - 1) * sizeof(GLfloat) * 3 length:sizeof(GLfloat) * 3];
                    }
                }
                else
                {
                    fIndex = (GLuint)[index unsignedLongValue];
                }
                
                if (count > 3)
                {
                    //face has more than 3 sides
                    //so insert extra triangle coords
                    [faceIndexData appendBytes:faceIndexData.bytes + faceIndexData.length - sizeof(GLuint) * 3 length:sizeof(GLuint)];
                    [faceIndexData appendBytes:faceIndexData.bytes + faceIndexData.length - sizeof(GLuint) * 2 length:sizeof(GLuint)];
                }
                
                [faceIndexData appendBytes:&fIndex length:sizeof(GLuint)];
            }
            
        }
        //TODO: more
    }
    while (![lineScanner isAtEnd]);
    
    //release temporary storage
    //copy elements
    self.elementCount = (GLuint)[faceIndexData length] / sizeof(GLuint);
    const GLuint *faceIndices = (const GLuint *)faceIndexData.bytes;
    if (self.elementCount > USHRT_MAX)
    {
        self.elementType = GL_UNSIGNED_SHORT;
        self.elementSize = sizeof(GLuint);
        self.elements = malloc([faceIndexData length]);
        memcpy(self.elements, faceIndices, [faceIndexData length]);
    }
    else if (self.elementCount > UCHAR_MAX)
    {
        self.elementType = GL_UNSIGNED_SHORT;
        self.elementSize = sizeof(GLushort);
        self.elements = malloc([faceIndexData length] / 2);
        for (GLuint i = 0; i < _elementCount; i++)
        {
            ((GLushort *)_elements)[i] = faceIndices[i];
        }
    }
    else
    {
        self.elementType = GL_UNSIGNED_BYTE;
        self.elementSize = sizeof(GLubyte);
        self.elements = malloc([faceIndexData length] / 4);
        for (GLuint i = 0; i < _elementCount; i++)
        {
            ((GLubyte *)_elements)[i] = faceIndices[i];
        }
    }
    
    //copy vertices
    self.componentCount = 3;
    self.vertexCount = (GLuint)[vertexData length] / (3 * sizeof(GLfloat));
    self.vertices = malloc([vertexData length]);
    memcpy(self.vertices, vertexData.bytes, [vertexData length]);
    
    //copy texture coords
    if ([textCoordData length])
    {
        self.texCoords = malloc([textCoordData length]);
        memcpy(self.texCoords, textCoordData.bytes, [textCoordData length]);
    }
    
    //copy normals
    if ([normalData length])
    {
        self.normals = malloc([normalData length]);
        memcpy(self.normals, normalData.bytes, [normalData length]);
    }
}

- (void)dealloc
{
    if (_vertices) {
        free(_vertices);
        _vertices = nil;
    }
    
    if (_texCoords) {
        free(_texCoords);
        _texCoords = nil;
    }
    
    if (_normals) {
        free(_normals);
        _normals = nil;
    }
    
    if (_elements) {
        free(_elements);
        _elements = nil;
    }
    
    if (_vectorArr) {
        [self.vectorArr removeAllObjects];
        self.vectorArr = nil;
    }
}

@end
