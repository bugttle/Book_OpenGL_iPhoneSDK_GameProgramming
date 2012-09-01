//
//  MyTarget.h
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "graphicUtil.h"

class MyTarget {
public:
	float angle;	//標的の角度
	float x,y;	//標的の位置
	float size;	//標的のサイズ
	float speed;	//標的の移動速度
	float turnAngle;	//標的の旋回の角度
	
	MyTarget(float x, float y, float angle, float size, float speed, float turnAngle);
	void move();
	void doWarp();	//ワープ処理をします
	bool isPointInside(float x, float y);	//ポイントがあたり判定の範囲内かを返します
	void draw(GLuint texture);	//標的を描画します
};
