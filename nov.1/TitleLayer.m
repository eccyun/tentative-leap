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
        [ud synchronize];

        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"time_leap.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"time_leap.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
        
        self.isTouchEnabled = YES;
        
        // 背景画像
        self.back_bg          = [[CCSprite alloc] initWithFile:@"bg_title.png"];
        self.back_bg.position = ccp(size.width/2, size.height/2);
        [self addChild:self.back_bg];

        // メニューラベル
        CCLabelTTF *title_name = [CCLabelTTF labelWithString:@"Leap 〜ときをこえて〜"
                                                  dimensions:CGSizeMake(305.0f, 180.0f)
                                                  hAlignment:UITextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:28];
        
        self.new_label  = [CCLabelTTF labelWithString:@"はじめから"
                                           dimensions:CGSizeMake(65.0f, 65.0f)
                                           hAlignment:UITextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:13];
        self.load_label = [CCLabelTTF labelWithString:@"つづきから"
                                           dimensions:CGSizeMake(65.0f, 65.0f)
                                           hAlignment:UITextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:13];
        self.opt_label  = [CCLabelTTF labelWithString:@"オプション"
                                           dimensions:CGSizeMake(65.0f, 65.0f)
                                           hAlignment:UITextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:13];

        self.new_label.position  = ccp(size.width/2-140.0f, size.height/6);
        self.load_label.position = ccp(size.width/2, size.height/6);
        self.opt_label.position  = ccp(size.width/2+140.0f, size.height/6);
        
        title_name.position = ccp(size.width/2, size.height - 180.0f);

        [self addChild:self.new_label];
        [self addChild:self.load_label];
        [self addChild:self.opt_label];
        [self addChild:title_name];
    }
    
	return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[super dealloc];
/*
    [self.back_bg dealloc];
    [self.home_btn dealloc];
    [self.new_label dealloc];
    [self.load_label dealloc];
    [self.opt_label dealloc];
*/
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];

    if(location.x > self.new_label.position.x-(self.new_label.contentSize.width/2)&&
       location.x < self.new_label.position.x+(self.new_label.contentSize.width/2)&&
       location.y > self.new_label.position.y-(self.new_label.contentSize.height/2)&&
       location.y < self.new_label.position.y+(self.new_label.contentSize.height/2)){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainGameScene scene] withColor:ccBLACK]];
    }else if(location.x > self.opt_label.position.x-(self.opt_label.contentSize.width/2)&&
             location.x < self.opt_label.position.x+(self.opt_label.contentSize.width/2)&&
             location.y > self.opt_label.position.y-(self.opt_label.contentSize.height/2)&&
             location.y < self.opt_label.position.y+(self.opt_label.contentSize.height/2)){
        [[CCDirector sharedDirector] pushScene: [SettingsScene scene]];
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
