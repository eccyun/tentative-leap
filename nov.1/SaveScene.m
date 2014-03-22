//
//  SaveScene.m
//  nov.1
//
//  Created by 田島僚 on 2014/03/16.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "SaveScene.h"


@implementation SaveScene


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *) scene{
	CCScene *scene = [CCScene node];
    
    SaveScene *layer = [SaveScene node];
	[scene addChild: layer];

    // return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    if((self=[super init])){
        self.isTouchEnabled = YES;
    }
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[super dealloc];
}

-(void) onEnter{
	[super onEnter];

    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *background = [[CCSprite alloc] initWithFile:@"save_background.png"];
    background.position  = ccp(size.width/2, size.height/2);
    [self addChild:background];

    CCSprite *save_1 = [[CCSprite alloc] initWithFile:@"save_1.png"];
    save_1.position  = ccp(size.width/2 - 142.f, size.height/2 + 50.f);
    [self addChild:save_1];

    CCSprite *save_2 = [[CCSprite alloc] initWithFile:@"save_2.png"];
    save_2.position  = ccp(size.width/2, size.height/2 + 50.f);
    [self addChild:save_2];

    CCSprite *save_3 = [[CCSprite alloc] initWithFile:@"save_3.png"];
    save_3.position  = ccp(size.width/2 + 142.f, size.height/2 + 50.f);
    [self addChild:save_3];
    
    CCSprite *save_4 = [[CCSprite alloc] initWithFile:@"save_4.png"];
    save_4.position  = ccp(size.width/2 - 142.f, size.height/2 - 62.f);
    [self addChild:save_4];

    CCSprite *save_5 = [[CCSprite alloc] initWithFile:@"save_5.png"];
    save_5.position  = ccp(size.width/2, size.height/2 - 62.f);
    [self addChild:save_5];

    CCSprite *save_6 = [[CCSprite alloc] initWithFile:@"save_6.png"];
    save_6.position  = ccp(size.width/2 + 142.f, size.height/2 - 62.f);
    [self addChild:save_6];

    // 左上のウィンドウ
    NSString *save_text = @"";
    NSString *load_text = @"";
    
    if([self.function_flag isEqualToString:@"Load"]){
        save_text = @"save_off.png";
        load_text = @"load_on.png";
    }else if([self.function_flag isEqualToString:@"Save"]){
        save_text = @"save_on.png";
        load_text = @"load_off.png";
    }
    
    CCSprite *load = [[CCSprite alloc] initWithFile:load_text];
    load.position  = ccp(size.width/2 - 100.f, size.height/2 + 140.f);
    [self addChild:load];

    CCSprite *save = [[CCSprite alloc] initWithFile:save_text];
    save.position  = ccp(size.width/2 - 182.f, size.height/2 + 139.f);
    [self addChild:save];


    CCSprite *back_btn = [[CCSprite alloc] initWithFile:@"save_back.png"];
    back_btn.position  = ccp(size.width/2 + 182.f, size.height/2 - 142.f);
    [self addChild:back_btn];
    back_btn.tag = 1;

}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];

    CCSprite *back_btn = (CCSprite *)[self getChildByTag:1];
    if(location.x > back_btn.position.x-(back_btn.contentSize.width/2)&&
       location.x < back_btn.position.x+(back_btn.contentSize.width/2)&&
       location.y > back_btn.position.y-(back_btn.contentSize.height/2)&&
       location.y < back_btn.position.y+(back_btn.contentSize.height/2)){
        [[CCDirector sharedDirector] popScene];
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
