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
+(CCScene *) scene{
	CCScene *scene = [CCScene node];
    
    SaveScene *layer = [SaveScene node];
	[scene addChild: layer];

    // return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    if((self=[super init])){
    }
    
	return self;
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
}

@end
