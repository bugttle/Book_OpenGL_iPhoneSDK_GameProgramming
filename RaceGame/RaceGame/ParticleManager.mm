//
//  ParticleManager.mm
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "ParticleManager.h"

ParticleManager::ParticleManager(int capacity, int particleLifeSpan)
{
    this->capacity = capacity;
    
    particle = new Particle * [capacity];
    
    for (int i = 0; i < capacity; i++) {
        particle[i] = new Particle();
        particle[i]->lifeSpan = particleLifeSpan;
    }
}

/* パーティクルの削除 */
ParticleManager::~ParticleManager()
{
    for (int i = 0; i < capacity; i++) {
        delete particle[i];
    }
    delete particle;
}

void ParticleManager::add(float x, float y, float size, float moveX, float moveY)
{
    for (int i = 0; i < capacity; i++) {
        if (!particle[i]->isActive) {
            particle[i]->isActive = true;
            particle[i]->x = x;
            particle[i]->y = y;
            particle[i]->size = size;
            particle[i]->moveX = moveX;
            particle[i]->moveY = moveY;
            particle[i]->frameNumber = 0;
            break;
        }
    }
}

void ParticleManager::draw(GLuint texture)
{
    
}

void ParticleManager::update()
{
    for (int i = 0; i < capacity; i++) {
        if (particle[i]->isActive) {
            particle[i]->update();
        }
    }
}
