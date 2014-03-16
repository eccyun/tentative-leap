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

    CCSprite *background = [[CCSprite alloc] initWithFile:@"save_ background.png"];
    background.position  = ccp(size.width/2, size.height/2);
    [self addChild:background];

}

@end
