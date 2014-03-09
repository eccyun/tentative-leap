//
//  LoadScene.m
//  nov.1
//
//  Created by 田島僚 on 2014/02/25.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "LoadScene.h"
#import "MainGameScene.h"

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
    if((self=[super init])){
    }

	return self;
}

-(void) onEnter{
	[super onEnter];

    CGSize size = [[CCDirector sharedDirector] winSize];

    // 背景画像
    self.logo_image          = [[CCSprite alloc] initWithFile:@"load_logo.png"];
    self.logo_image.position = ccp(size.width-(self.logo_image.contentSize.width/2+10.f), size.height/10+15.f);
    [self addChild:self.logo_image];

	[self scheduleOnce:@selector(makeTransition:) delay:5.f];
}

-(void) makeTransition:(ccTime)dt{
    [super onEnterTransitionDidFinish];
    // [self.logo_image removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainGameScene scene] withColor:ccBLACK]];
}


/*
 次のシナリオへと遷移する
 */

- (void)performComplete{
    [super onEnterTransitionDidFinish];

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