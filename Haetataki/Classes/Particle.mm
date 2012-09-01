//
//  Particle.mm
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "Particle.h"

Particle::Particle(){
	this->x = 0.0f;
	this->y = 0.0f;
	this->size = 1.0f;
	this->activeFlag = false;	//初期状態では非アクティブ(未使用)
	this->moveX = 0.0f;
	this->moveY = 0.0f;
	this->frameNumber = 0;
	this->lifeSpan = 60;	//初期状態では寿命を60フレームにします
}

void Particle::draw(GLuint texture){
	//現在のフレームが、寿命の間のどの位置にあるのかを計算します
	float lifePercentage = (float)frameNumber / (float)lifeSpan;
	
	int alpha;
	if(lifePercentage <= 0.5f){	//まだ寿命が半分以上のこっている場合
		//フェードインします
		alpha = (int)round(lifePercentage * 2.0f * 255.0f);
	}else{
		//フェードアウトします
		alpha = 255 - (int)round(lifePercentage * 2.0f * 255.0f);
	}
	
	drawTexture(x, y, size, size, texture, 255, 255, 255, alpha);
}

void Particle::update(){
	frameNumber++;	//フレームを数えます
	
	//寿命に達していたら非アクティブにします
	if(frameNumber >= lifeSpan) activeFlag = false;
	
	x += moveX;
	y += moveY;
}
