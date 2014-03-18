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
	[self scheduleOnce:@selector(makeTransition:) delay:0.5f];
}

-(void) makeTransition:(ccTime)dt{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene] withColor:ccBLACK]];
}

@end
