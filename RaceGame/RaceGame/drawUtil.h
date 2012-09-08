//
//  drawUtil.h
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#ifndef __RaceGame__drawUtil__
#define __RaceGame__drawUtil__

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Vector2D.h"

void drawSquare();
void drawSquare(int red, int green, int blue, int alpha);
void drawSquare(float x, float y, int red, int green, int blue, int alpha);

void drawRectangle(float x, float y, float width, float height, int red, int green, int blue, int alpha);

void drawTexture(float x, float y, float width, float height, GLuint texture, int red, int green, int blue, int alpha);
void drawTexture(float x, float y, float width, float height, GLuint texture, float u, float v, float tex_width, float tex_height, int red, int green, int blue, int alpha);

void drawCircle(float x, float y, int divides, float radius, int red, int green, int blue, int alpha);
void drawCircle(Vector2D center, int divides, float radius, int red, int green, int blue, int alpha);

void drawNumber(float x, float y, float width, float height, GLuint texture, int number, int red, int green, int blue, int alpha);
void drawNumbers(float x, float y, float width, float height, GLuint texture, int number, int figures, int red, int green, int blue, int alpha);

GLuint loadTexture(NSString *fileName);


#endif /* defined(__RaceGame__drawUtil__) */
