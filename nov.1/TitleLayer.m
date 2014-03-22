//
//  TitleLayer.m
//  nov.1
//
//  Created by eccyun on 2013/02/14.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TitleLayer.h"
#import "MainGameScene.h"
#import "SettingsScene.h"
#import "SimpleAudioEngine.h"
#import "LoadScene.h"
#import "SaveScene.h"

@implementation TitleLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
	CCScene *scene = [CCScene node];

	TitleLayer *layer = [TitleLayer node];
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
	CGSize size = [[CCDirector sharedDirector] winSize];
    
	if((self=[super init])){
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:0 forKey:@"script_index"];
        [ud setInteger:0 forKey:@"structure_index"];
        [ud setInteger:0 forKey:@"quick_start_flag"];
        [ud synchronize];

        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"time_leap.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"time_leap.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];

        self.isTouchEnabled = YES;

        // 背景画像
        self.back_bg          = [[CCSprite alloc] initWithFile : @"menu_background.png"];
        self.back_bg.position = ccp(size.width/2, size.height/2);
        [self addChild:self.back_bg];

        // タイトルロゴ
        self.title_logo = [[CCSprite alloc] initWithFile:@"title_logo.png"];
        self.title_logo.position = ccp(size.width/2, size.height/2+30.f);
        [self addChild:self.title_logo];

        // はじめから
        self.start_logo          = [[CCSprite alloc] initWithFile:@"menu_start_off.png"];
        self.start_logo.position = ccp(size.width/2-160.0f, size.height/6);
        [self addChild:self.start_logo];

        // つづきから
        self.restart_logo          = [[CCSprite alloc] initWithFile:@"menu_restart_off.png"];
        self.restart_logo.position = ccp(size.width/2+160.0f, size.height/6);
        [self addChild:self.restart_logo];

        // クイックスタート
        self.quick_logo          = [[CCSprite alloc] initWithFile:@"menu_quick_start_off.png"];
        self.quick_logo.position = ccp(size.width/2+8.f, size.height/6);
        [self addChild:self.quick_logo];
    }
    
	return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[super dealloc];
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];

    if(location.x > self.start_logo.position.x-(self.start_logo.contentSize.width/2)&&
       location.x < self.start_logo.position.x+(self.start_logo.contentSize.width/2)&&
       location.y > self.start_logo.position.y-(self.start_logo.contentSize.height/2)&&
       location.y < self.start_logo.position.y+(self.start_logo.contentSize.height/2)){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainGameScene scene] withColor:ccBLACK]];
    }else if(location.x > self.quick_logo.position.x-(self.quick_logo.contentSize.width/2)&&
             location.x < self.quick_logo.position.x+(self.quick_logo.contentSize.width/2)&&
             location.y > self.quick_logo.position.y-(self.quick_logo.contentSize.height/2)&&
             location.y < self.quick_logo.position.y+(self.quick_logo.contentSize.height/2)){
        // ロードシーンのインスタンスを作る
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:1 forKey:@"quick_start_flag"];
        [ud synchronize];

        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LoadScene scene] withColor:ccBLACK]];
    }else if(location.x > self.restart_logo.position.x-(self.restart_logo.contentSize.width/2)&&
             location.x < self.restart_logo.position.x+(self.restart_logo.contentSize.width/2)&&
             location.y > self.restart_logo.position.y-(self.restart_logo.contentSize.height/2)&&
             location.y < self.restart_logo.position.y+(self.restart_logo.contentSize.height/2)){
        // セーブシーンに移動
        [[CCDirector sharedDirector] pushScene:[SaveScene scene]];
    }

    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}


@end
