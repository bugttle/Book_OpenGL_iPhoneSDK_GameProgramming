//
//  ES1Renderer.mm
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#import "ES1Renderer.h"

//0.000から1.000までの値のランダムな小数を返します
#define randF() ((float)(rand() % 1001) * 0.001f)

@implementation ES1Renderer
@synthesize glView;

// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		srand(time(nil));		//rand()の種を初期化します
		
		[self loadTextures];	//テクスチャを読み込みます
		
		//サウンドを読み込みます
		//効果音用のAVAudioPlayerを生成します
		NSString *hitSoundFilePath = [[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"wav"];  
		NSURL *hitSoundFileUrl = [NSURL fileURLWithPath:hitSoundFilePath];  
		hitSound = [[AVAudioPlayer alloc] initWithContentsOfURL:hitSoundFileUrl error:nil];
		[hitSound prepareToPlay];
		
		//BGM用のAVAudioPlayerを生成します
		NSString *bgmFilePath = [[NSBundle mainBundle] pathForResource:@"master1" ofType:@"caf"];  
		NSURL *bgmFileUrl = [NSURL fileURLWithPath:bgmFilePath];  
		bgmSound = [[AVAudioPlayer alloc] initWithContentsOfURL:bgmFileUrl error:nil];
		[bgmSound setNumberOfLoops:-1];
		[bgmSound play];
		
		[self startNewGame];	//新しいゲームを開始します
		
		//パーティクルシステムを初期化します 
		particleSystem = new ParticleSystem(300, 30);
	}
	
	return self;
}
//新しいゲームを開始します
- (void) startNewGame{
	//標的の状態の初期値を設定します
	for(int i=0; i<TARGET_NUM; i++){
		//標的の初期座標は(-1.0〜1.0, -1.0〜1.0)の中のランダムな地点にします
		float x = randF() * 2.0f - 1.0f;
		float y = randF() * 2.0f - 1.0f;
		
		//角度をランダムに設定します
		float angle = (float)(rand() % 360);	
		
		//標的の大きさを0.25〜0.50の間でランダムに決定します
		float size = randF() * 0.25f + 0.25f;	
		
		//標的の移動速度を0.01〜0.02の間でランダムに決定します
		float speed = randF() * 0.01f + 0.01f;	
		
		//標的の旋回角度を-2.0〜2.0の間でランダムに決定します
		float turnAngle = randF() * 4.0f - 2.0f;	
		target[i] = new MyTarget(x,y,angle,size,speed,turnAngle);
	}
	
	score = 0;	//スコアを0にする
	startTime = [[NSDate date] retain];	//開始時刻を記録します
	gameOverFlag = false;	//ゲームオーバ状態ではない
	
	[glView hideRetryButton];	//リトライボタンを非表示にします
}

//使用するテクスチャを読み込みます
- (void) loadTextures{
	bgTexture = loadTexture(@"circuit.png");	//背景用テクスチャ
	if(bgTexture == 0) NSLog(@"bgTextureの読み込みに失敗しました。");
	targetTexture = loadTexture(@"fly.png");	//標的用テクスチャ
	if(targetTexture == 0) NSLog(@"targetTextureの読み込みに失敗しました。");
	numberTexture = loadTexture(@"number_texture.png");	//数字用テクスチャ
	if(numberTexture == 0) NSLog(@"numberTextureの読み込みに失敗しました。");
	gameOverTexture = loadTexture(@"game_over.png");
	if(gameOverTexture == 0) NSLog(@"gameOverTextureの読み込みに失敗しました。");
	particleTexture = loadTexture(@"particle_blue.png");
	if(particleTexture == 0) NSLog(@"particleTextureの読み込みに失敗しました。");
}

- (void) render
{
    // This application only creates a single context which is already set current at this point.
	// This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
    
	// This application only creates a single default framebuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, 0.5f, -0.5f);
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
	
	[self renderMain];	//ゲームの内容を描画します
    
	// This application only creates a single color renderbuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
- (void) renderMain{
	//経過時間を取得します
	int passedTime = (int)floor(-[startTime timeIntervalSinceNow]);
	int remainTime = GAME_INTERVAL - passedTime;	//残り時間を計算します
	if(remainTime < 0) remainTime = 0;	//残り時間がマイナスにならないようにします
	
	if(remainTime <= 0){
		//ゲームオーバ前からゲームオーバ状態に切り替わった瞬間に一回だけ呼ばれるようにします
		if(gameOverFlag == false){
			gameOverFlag = true;	//ゲームオーバー状態にします
			[glView showRetryButton];	//Retryボタンを表示します
		}
	}
	
	//すべての標的を一匹ずつ動かしていきます
	for(int i=0; i<TARGET_NUM; i++){
		//ランダムなタイミングで方向転換させるようにします
		if(rand() % 100 == 0){	//100回に1回の確率で方向転換させます
			//旋回する角度を-2.0〜2.0の間でランダムに設定します
			target[i]->turnAngle = randF() * 4.0f - 2.0f;	
		}
		
		//ここで標的を旋回させます
		target[i]->angle = target[i]->angle + target[i]->turnAngle;
		
		//ここで標的を動かします
		target[i]->move();
		
		//ワープ処理
		target[i]->doWarp();
		
		//パーティクルを使って軌跡を描画します
		float moveX = (randF() - 0.5f) * 0.01f;
		float moveY = (randF() - 0.5f) * 0.01f;
		particleSystem->add(target[i]->x, target[i]->y, 0.1f, moveX, moveY);
	}
	
	//1.背景を描画します
    drawTexture(0.0f, 0.0f, 2.0f, 3.0f, bgTexture, 255, 255, 255, 255);
	
	//パーティクルを描画します 
	particleSystem->update(); //各パーティクルを動かします
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE); particleSystem->draw(particleTexture);
	glDisable(GL_BLEND);
	
	//2.標的を描画します
	//すべての標的を一匹ずつ描画していきます
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE);
	for(int i=0; i<TARGET_NUM; i++){
		target[i]->draw(targetTexture);
	}
	
	//3.点数を描画します
	drawNumbers(-0.5f, 1.25f, 0.125f, 0.125f, numberTexture, score, 8 , 255, 255, 255, 255);
	
	//4.残り時間を描画します
	drawNumbers(0.5f, 1.2f, 0.4f, 0.4f, numberTexture, remainTime, 2, 255, 255, 255, 255);
	
	//5.ゲームオーバーの状態になっていたらゲームオーバーのロゴを表示します
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	if(gameOverFlag){
		drawTexture(0.0f, 0.0f, 2.0f, 0.5f, gameOverTexture, 255, 255, 255, 255);
	}
	
	glDisable(GL_BLEND);
}

- (void) touchedAtX:(float)x andY:(float)y{
	NSLog(@"%f,%f がタッチされました",x,y);
	
	if(gameOverFlag == false){
		//全ての標的を一匹ずつ調べていきます
		for(int i=0; i<TARGET_NUM; i++){
			//タッチされた位置との距離が標的のサイズ（半径）より小さければあたったことにします
			if(target[i]->isPointInside(x, y)){
				
				for(int j=0; j<40; j++){
					float moveX = (randF() - 0.5f) * 0.05f;
					float moveY = (randF() - 0.5f) * 0.05f;
					particleSystem->add(target[i]->x, target[i]->y, 0.2f, moveX, moveY);
				}
				
				//標的をランダムな位置に移動します
				float dist = 2.0f; //画面の中央から2.0fはなれた円周上の
				float theta = (float)(rand() % 360) / 180.0 * 3.14;	//適当な位置
				target[i]->x = cos(theta) * dist;
				target[i]->y = sin(theta) * dist;
				
				score = score + 100;	//100点追加します
				NSLog(@"現在 %d点",score);
				
				//効果音を巻き戻して再生します
				[hitSound setCurrentTime:0.0f];
				[hitSound play];
				
				
			}
		}
	}
}
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) dealloc
{
	[self deleteTextures];	//テクスチャを解放します
	
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}

	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}
//使用したテクスチャをすべて破棄します
- (void) deleteTextures{
	glDeleteTextures(1, &bgTexture);
	glDeleteTextures(1, &targetTexture);
	glDeleteTextures(1, &numberTexture);
	glDeleteTextures(1, &gameOverTexture);
	glDeleteTextures(1, &particleTexture);
}
@end
