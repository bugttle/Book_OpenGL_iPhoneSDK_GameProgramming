//
//  Particle.h
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "graphicUtil.h"

class Particle {
public:
	float x;
	float y;
	float size;
	bool activeFlag;
	float moveX;	//1フレームあたりのX軸方向の移動量
	float moveY;	//1フレームあたりのY軸方向の移動量
	int frameNumber;	//生成からの時間(フレーム数)
	int lifeSpan;		//消滅するまでの時間(フレーム数)
	
	Particle();
	void draw(GLuint texture);
	void update();	//自身の状態を更新します
};
