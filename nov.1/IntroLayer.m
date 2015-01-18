//
//  IntroLayer.m
//  NovelGame
//
//  Created by eccyun on 2012/12/24.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "TitleLayer.h"
#import "SaveScene.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];

	return scene;
}


-(void) onEnter{
	[super onEnter];
    CGSize size = [[CCDirector sharedDirector] winSize];

    // 背景画像
    CCSprite *launch_image   = [[CCSprite alloc] initWithFile : @"launchImage.png"];
    launch_image.position = ccp(size.width/2, size.height/2);
    [launch_image runAction:[CCFadeIn actionWithDuration:2.f]];
    [self addChild:launch_image];

    
	[self scheduleOnce:@selector(makeTransition:) delay:4.f];
}

-(void) makeTransition:(ccTime)dt{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene] withColor:ccBLACK]];
}

@end
