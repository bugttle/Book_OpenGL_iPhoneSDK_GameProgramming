//
//  EAGLView.mm
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#import "EAGLView.h"

#import "ES1Renderer.h"

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id) initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
			renderer = [[ES1Renderer alloc] init];
			
			if (!renderer)
			{
				[self release];
				return nil;
			}
		renderer.glView = self;	//ES1RendererからEAGLViewを参照できるようにします

        
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
		
		//リトライボタンを追加します
		retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		//(100.0f, 300.0f)-(220.0f, 340.0f)の位置にします
		[retryButton setFrame:CGRectMake(100.0f, 300.0f, 120.0f, 40.0f)];
		//ボタンの表面文字列はRetryにします
		[retryButton setTitle:@"Retry" forState:UIControlStateNormal];
		//ボタンが押されたらretryGameが呼ばれるように設定します
		[retryButton addTarget:self action:@selector(retryGame:) forControlEvents:UIControlEventTouchUpInside];
		//ボタンを貼付けます
		[self addSubview:retryButton];
		
		//ボタンを非表示にします
		[self hideRetryButton];
    }
	
    return self;
}

- (void) drawView:(id)sender
{
    [renderer render];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//タッチされたポイントを取得します
	UITouch* touch = [touches anyObject];
	//タッチされたポイントの画面上の座標を取得します
	CGPoint pt = [touch locationInView:self];
	//OpenGL上の座標へ変換します
	float glX = (pt.x / 320.0f) * 2.0f - 1.0f;
	float glY = (pt.y / 480.0f) * -3.0f + 1.5f;
	
	[renderer touchedAtX:glX andY:glY];
}

- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.

			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}

- (void) dealloc
{
    [renderer release];
	
    [super dealloc];
}
- (void) hideRetryButton{
	[retryButton setHidden:YES];	//リトライボタンを非表示にします
}
- (void) showRetryButton{
	[retryButton setHidden:NO];		//リトライボタンを表示します
}
- (void) retryGame:(id)sender{
	[renderer startNewGame];	//新しいゲームを開始します
}
@end
