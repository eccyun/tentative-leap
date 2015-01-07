//
//  AppDelegate.m
//  nov.1
//
//  Created by eccyun on 2012/12/09.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "MainGameScene.h"
#import "IntroLayer.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    [window_ setMultipleTouchEnabled:YES];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [IntroLayer scene]];

    
	
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];

    self.bgmMap = @{@"aruku_theme.mp3" : [self getPlayer:@"aruku_theme.mp3"],
                    @"bar_theme.mp3"   : [self getPlayer:@"bar_theme.mp3"],
                    @"confessions.mp3" : [self getPlayer:@"confessions.mp3"],
                    @"end-loop.mp3"    : [self getPlayer:@"end-loop.mp3"],
                    @"fest-leap.mp3"   : [self getPlayer:@"fest-leap.mp3"],
                    @"mary_theme.mp3"  : [self getPlayer:@"mary_theme.mp3"],
                    @"on-a-bench.mp3"  : [self getPlayer:@"on-a-bench.mp3"],
                    @"road_theme.mp3"  : [self getPlayer:@"road_theme.mp3"],
                    @"time-leap.mp3"   : [self getPlayer:@"time-leap.mp3"],
                    @"shoot.mp3"       : [self getPlayer:@"shoot.mp3"],
                    @"bell-leap.mp3"   : [self getPlayer:@"bell-leap.mp3"],
                    @"leap-ending.mp3" : [self getPlayer:@"leap-ending.mp3"],
                    @"forest.mp3"      : [self getPlayer:@"forest.mp3"],};
    
    self.effectsMap = @{
                        @"shoot_effect.mp3" : [self getPlayer:@"shoot_effect.mp3"],
                        @"watch_alert.mp3"  : [self getPlayer:@"watch_alert.mp3"]
                        };
	return YES;
}

- (AVAudioPlayer *) getPlayer : (NSString *)file_name{
    NSArray  *split      = [file_name componentsSeparatedByString:@"."];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath   = [mainBundle pathForResource:[split objectAtIndex:0] ofType:[NSString stringWithFormat:@".%@",[split objectAtIndex:1]]];
    NSURL    *fileUrl    = [NSURL fileURLWithPath:filePath];
    NSError  *error      = nil;

    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    player.currentTime   = 0.f;
    player.volume        = 0.f;
    player.numberOfLoops = -1;
    
    [player prepareToPlay];
    
    return player;
}

- (void) refreshPlayer{
    for(NSString* player in self.bgmMap) {
        AVAudioPlayer *audioPlayer = (AVAudioPlayer *)self.bgmMap[player];
        [audioPlayer stop];
        
        audioPlayer.currentTime = 0.f;
        audioPlayer.volume      = 0.f;
    }

    for(AVAudioPlayer* player in self.effectsMap) {
        AVAudioPlayer *audioPlayer = (AVAudioPlayer *)self.effectsMap[player];
        [audioPlayer stop];

        audioPlayer.currentTime = 0.f;
        audioPlayer.volume      = 1.f;
    }
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}

@end

