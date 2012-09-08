//
//  Vector2D.mm
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "Vector2D.h"

Vector2D::Vector2D()
{
    this->x = 0.0f;
    this->y = 0.0f;
}

Vector2D::Vector2D(float x, float y)
{
    this->x = x;
    this->y = y;
}

Vector2D Vector2D::operator+(const Vector2D &a)
{
    Vector2D b(this->x + a.x, this->y +a.y);
    return b;
}

Vector2D Vector2D::operator-(const Vector2D &a)
{
    Vector2D b(this->x - a.x, this->y - a.y);
    return b;
}

Vector2D Vector2D::operator*(const float a)
{
    Vector2D b(this->x * a, this->y * a);
    return b;
}

Vector2D Vector2D::operator/(const float a)
{
    if (a == 0.0f) {
        return *this;
    } else {
        return (*this * (1.0f / a));
    }
}

float Vector2D::sequareLength()
{
    return (x*x + y*y);
}

Vector2D Vector2D::unitVector()
{
    return (*this / sqrt(this->sequareLength()));
}

float Vector2D::dotProduct(const Vector2D &a)
{
    return (x*a.x + y*a.y);
}
