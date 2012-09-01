//
//  MyTarget.mm
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "MyTarget.h"

//コンストラクタ
MyTarget::MyTarget(float x, float y, float angle, float size, float speed, float turnAngle){
	this->x = x;
	this->y = y;
	this->angle = angle;
	this->size = size;
	this->speed = speed;
	this->turnAngle = turnAngle;
}

//標的を移動させます
void MyTarget::move(){
	float theta = this->angle / 180.0 * 3.14;
	this->x = this->x + cos(theta) * this->speed;
	this->y = this->y + sin(theta) * this->speed;
}

//画面外でのワープ処理を行います
void MyTarget::doWarp(){
	if(this->x >= 2.0f) this->x -= 4.0f;
	if(this->x <= -2.0f) this->x += 4.0f;
	if(this->y >= 2.5f) this->y -= 5.0f;
	if(this->y <= -2.5f) this->y += 5.0f;
}

//ポイントがあたり判定の範囲内かを返します
bool MyTarget::isPointInside(float x, float y){
	//標的とタッチされたポイントとの距離を計算します
	float dX = x - this->x;
	float dY = y - this->y;
	float distance = sqrt(dX*dX + dY*dY);
	
	if(distance <= this->size * 0.5f){
		return true;
	}else{
		return false;
	}
}

//標的を描画します
void MyTarget::draw(GLuint texture){
	glPushMatrix();
	glTranslatef(this->x, this->y, 0.0f);
	glRotatef(this->angle, 0.0f, 0.0f, 1.0f);
	glScalef(this->size, this->size, 1.0f);
	drawTexture(0.0f, 0.0f, 1.0f, 1.0f, texture, 255, 255, 255, 255);
	glPopMatrix();
}
