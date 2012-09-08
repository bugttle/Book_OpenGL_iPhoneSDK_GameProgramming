//
//  Particle.mm
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "Particle.h"

Particle::Particle()
{
    this->x = 0.0f;
    this->y = 0.0f;
    this->size = 1.0f;
    this->activeFlag = false;
    this->moveX = 0.0f;
    this->moveY = 0.0f;
    this->frameNumber = 0;
    this->lifeSpan = 60;
}

void Particle::draw(GLuint texture)
{
    float lifePercentage = (float)frameNumber / (float)lifeSpan;
    
    int alpha = (int)round(lifePercentage * 2.0f * 255.0f);
    alpha = (lifePercentage <= 0.5f) ? alpha : 255 - alpha;

    drawTexture(x, y, size, size, texture, 255, 255, 255, alpha);
}

void Particle::update()
{
    frameNumber++;
    
    if (frameNumber >= lifeSpan) {
        activeFlag = false;
    }
    
    x += moveX;
    y += moveY;
}
