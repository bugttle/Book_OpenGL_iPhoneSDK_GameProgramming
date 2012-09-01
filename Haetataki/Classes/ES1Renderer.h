//
//  ES1Renderer.h
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AVFoundation/AVFoundation.h>

#import "graphicUtil.h"
#import "MyTarget.h"

#import "EAGLView.h"
#import "ParticleSystem.h"

//標的の数を指定します
#define TARGET_NUM 10
#define GAME_INTERVAL 60

@class EAGLView;	//EAGLViewというクラスが存在することを宣言しておきます

@interface ES1Renderer : NSObject <ESRenderer>
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	//テクスチャ
	GLuint bgTexture;	//背景用テクスチャ
	GLuint targetTexture;	//標的用テクスチャ
	GLuint numberTexture;	//数字用のテクスチャ
	GLuint gameOverTexture;	//ゲームオーバー用テクスチャ
	GLuint particleTexture;	//パーティクル用のテクスチャ
	
	
	//標的の状態を表す変数
	MyTarget* target[TARGET_NUM];
	
	int score;	//点数
	
	NSDate* startTime;	//ゲーム開始時刻
	bool gameOverFlag;	//ゲームオーバかどうかを管理するフラグ
	
	EAGLView* glView;	//EAGLViewにアクセスできるようにするための変数
	
	AVAudioPlayer *hitSound;	//標的を叩いたとき用のサウンド
	AVAudioPlayer *bgmSound;	//BGM用のサウンド
	
	ParticleSystem *particleSystem;
}
@property (nonatomic, assign) EAGLView *glView;
- (void) render;
- (void) renderMain;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;
- (void) loadTextures;		//テクスチャの読み込みを行う関数
- (void) deleteTextures;	//読み込んだテクスチャを破棄する関数
- (void) touchedAtX:(float)x andY:(float)y;	//画面上がタッチされたときに呼ばれる関数
- (void) startNewGame;		//新しいゲームを開始する時に呼ぶ関数
@end
