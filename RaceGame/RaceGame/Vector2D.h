//
//  Vector2D.h
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#ifndef __RaceGame__Vector2D__
#define __RaceGame__Vector2D__

class Vector2D
{
public:
    float x;
    float y;
    
    // methods
    Vector2D();
    Vector2D(float x, float y);
    
    Vector2D operator+(const Vector2D &a);
    Vector2D operator-(const Vector2D &a);
    Vector2D operator*(const float a);
    Vector2D operator/(const float a);
    
    float sequareLength();
    Vector2D unitVector();
    float dotProduct(const Vector2D &a);
};

#endif /* defined(__RaceGame__Vector2D__) */
