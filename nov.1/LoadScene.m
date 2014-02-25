//
//  LoadScene.m
//  nov.1
//
//  Created by 田島僚 on 2014/02/25.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "LoadScene.h"


@interface LoadScene ()

@property(nonatomic, retain) CCSprite *logo_image;

@end

@implementation LoadScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
	CCScene *scene = [CCScene node];

    LoadScene *layer = [LoadScene node];
	[scene addChild: layer];

    // return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    CGSize size = [[CCDirector sharedDirector] winSize];

    if((self=[super init])){
        // 背景画像
        self.logo_image          = [[CCSprite alloc] initWithFile:@"aohige_logo.png"];
        self.logo_image.position = ccp(size.width-(self.logo_image.contentSize.width/2), size.height/10);
        [self addChild:self.logo_image];
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