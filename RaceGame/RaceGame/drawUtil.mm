//
//  drawUtil.cpp
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "drawUtil.h"

void drawSquare()
{
    drawSquare(255, 0, 0, 255);
}

void drawSquare(int red, int green, int blue, int alpha)
{
	drawSquare(0.0f, 0.0f, red, green, blue, alpha);
}

void drawSquare(float x, float y, int red, int green, int blue, int alpha)
{
	drawRectangle(x, y, 1.0f, 1.0f, red, green, blue, alpha);
}

void drawRectangle(float x, float y, float width, float height, int red, int green, int blue, int alpha)
{
    const GLfloat squareVertices[] = {
        -0.5f*width + x, -0.5f*height + y,
         0.5f*width + x, -0.5f*height + y,
        -0.5f*width + x,  0.5f*height + y,
         0.5f*width + x,  0.5f*height + y,
    };
    
    const GLubyte squareColors[] = {
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
    };
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void drawTexture(float x, float y, float width, float height, GLuint texture, int red, int green, int blue, int alpha)
{
	drawTexture(x, y, width, height, texture, 0.0f, 0.0f, 1.0f, 1.0f, red, green, blue, alpha);
}

void drawTexture(float x, float y, float width, float height, GLuint texture, float u, float v, float tex_width, float tex_height, int red, int green, int blue, int alpha)
{
    const GLfloat squareVertices[] = {
        -0.5f*width + x, -0.5f*height + y,
         0.5f*width + x, -0.5f*height + y,
        -0.5f*width + x,  0.5f*height + y,
         0.5f*width + x,  0.5f*height + y,
    };
    
    const GLubyte squareColors[] = {
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
        (GLubyte)red, (GLubyte)green, (GLubyte)blue, (GLubyte)alpha,
    };
    
    const GLfloat texCoords[] = {
        u,           v+tex_height,
        u+tex_width, v+tex_height,
        u,           v,
        u+tex_width, v,
    };
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisable(GL_TEXTURE_2D);
}

void drawNumber(float x, float y, float width, float height, GLuint texture, int number, int red, int green, int blue, int alpha)
{
    float u = (float)(number % 4) * 0.25f;
    float v = (float)(number / 4) * 0.25f;
    
    drawTexture(x, y, width, height, texture, u, v, 0.25f, 0.25f, red, green, blue, alpha);
}

void drawNumbers(float x, float y, float width, float height, GLuint texture, int number, int figures, int red, int green, int blue, int alpha)
{
    float totalWidth = width * (float)figures;
    float rightX = x + (totalWidth * 0.5f);
    float fig1X = rightX - width * 0.5f;
    
    for (int i = 0; i < figures; i++) {
        float figNX = fig1X - (float)i * width;
        int numberToDraw = number / (int)pow(10.0, (double)i) % 10;
        drawNumber(figNX, y, width, height, texture, numberToDraw, 255, 255, 255, 255);
    }
}

void drawCircle(float x, float y, int divides, float radius, int red, int green, int blue, int alpha)
{
    GLfloat vertices[divides * 3 * 2];
    
    int vertexId = 0;
    for (int i = 0; i < divides; i++) {
        float theta1 = 2.0f / (float)divides * (float)i * M_PI;
        float theta2 = 2.0f / (float)divides * (float)(i+1) * M_PI;
        
        vertices[vertexId++] = x;
        vertices[vertexId++] = y;
        
        vertices[vertexId++] = x + cos(theta1) * radius;
        vertices[vertexId++] = y + sin(theta1) * radius;
        
        vertices[vertexId++] = x + cos(theta2) * radius;
        vertices[vertexId++] = y + sin(theta2) * radius;
    }
    
    glColor4ub(red, green, blue, alpha);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glDrawArrays(GL_TRIANGLES, 0, divides * 3);
}

void drawCircle(Vector2D center, int divides, float radius, int red, int green, int blue, int alpha)
{
    drawCircle(center.x, center.y, divides, radius, red, green, blue, alpha);
}

GLuint loadTexture(NSString *fileName)
{
    CGImageRef image = [UIImage imageNamed:fileName].CGImage;
    if (!image) {
        NSLog(@"ERROR: %@ not found", fileName);
        return 0;
    }

    size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);

    GLubyte* imageData = (GLubyte *)malloc(width * height * 4);
	CGContextRef imageContext = CGBitmapContextCreate(imageData, width, height, 8, width * 4,CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(imageContext, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), image);
	CGContextRelease(imageContext);

    // テクスチャの生成
    GLuint texture;
    glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	free(imageData);

    return texture;
}
