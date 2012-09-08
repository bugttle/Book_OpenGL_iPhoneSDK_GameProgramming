//
//  ParticleManager.h
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#ifndef __RaceGame__ParticleManager__
#define __RaceGame__ParticleManager__

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Particle.h"

class ParticleManager
{
private:
    Particle **particle;
    int capacity;
public:
    ParticleManager(int capacity, int particleLifeSpan);
    ~ParticleManager();
    void add(float x, float y, float size, float moveX, float moveY);
    void draw(GLuint texture);
    void update();
};

#endif /* defined(__RaceGame__ParticleManager__) */
