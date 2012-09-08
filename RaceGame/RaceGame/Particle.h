//
//  Particle.h
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#ifndef __RaceGame__Particle__
#define __RaceGame__Particle__

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

class Particle
{
public:
    float x;
    float y;
    float size;
    bool isActive;
    float moveX;
    float moveY;
    int frameNumber;
    int lifeSpan;
    
    // methods
    Particle();
    void draw(GLuint texture);
    void update();
};

#endif /* defined(__RaceGame__Particle__) */
