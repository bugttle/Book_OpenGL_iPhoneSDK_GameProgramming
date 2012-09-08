//
//  VertexBufferObjectManager.h
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#ifndef __RaceGame__VertexBufferObjectManager__
#define __RaceGame__VertexBufferObjectManager__

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

class VertexBufferObjectManager
{
public:
    GLfloat *vertices;  // 頂点座標
    GLfloat *texCoords;  // テクスチャ
    int vCount;
    int tCount;
    int pCount;
    GLuint vbo;
    GLuint texture;
    
    // methods
    void alloc(int size);
    void dealloc();
    void bufferData();
    void draw();
    void loadFromFile(NSString *filePath);
};

#endif /* defined(__RaceGame__VertexBufferObjectManager__) */
