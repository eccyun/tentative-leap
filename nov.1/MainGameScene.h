//
//  HelloWorldLayer.h
//  nov.1
//
//  Created by eccyun on 2012/12/09.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"
#import "cocos2d.h"
#import "TentativeEngine.h"
#import "SimpleAudioEngine.h"
#import "MenuScene.h"
#import "AppDelegate.h"

// HelloWorldLayer
@interface MainGameScene : CCLayer<CCTouchDelegate>{
}

@property(nonatomic,retain)  AppController*   delegate;

@property(nonatomic)         BOOL             isCheck, isUp, imgMode;
@property(nonatomic,retain)  TentativeEngine *engine;
@property(nonatomic,retain)  CCSprite        *back_bg;
@property(nonatomic,retain)  CCLabelTTF      *msgLabel, *name_tag;
@property(nonatomic)         NSInteger        counter,line_count;
@property(nonatomic, retain) CCSprite        *center;
@property(nonatomic, retain) CCSprite        *left;
@property(nonatomic, retain) CCSprite        *right;
@property(nonatomic, retain) CCSprite        *msgWindow;
@property(nonatomic, retain) CCSprite        *hyper, *menu_image;
@property(nonatomic, retain) NSString        *message_text,*name_text;
@property(nonatomic)         ALuint           effect_int;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
