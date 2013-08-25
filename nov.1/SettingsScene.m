//
//  SettingsScene.m
//  nov.1
//
//  Created by eccyun on 2013/02/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SettingsScene.h"


@implementation SettingsScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
	CCScene *scene = [CCScene node];

	SettingsScene *layer      = [SettingsScene node];
	[scene addChild: layer];

    // ボリュームバー
    SettingsParts* parts = [SettingsParts node];
    [scene addChild: parts];
    
	// return the scene
	return scene;
}

-(id) init{
	CGSize size = [[CCDirector sharedDirector] winSize];

	if((self=[super init])){
        if (size.width == 568.0f) {
            self.bg_image          = [[CCSprite alloc] initWithFile:@"bg_settings_5.png"];
        } else {
            self.bg_image          = [[CCSprite alloc] initWithFile:@"bg_settings.png"];
        }

        self.bg_image.position = ccp(size.width/2, size.height/2);
        [self addChild:self.bg_image];

		CCLabelTTF *label         = [CCLabelTTF labelWithString:@"オプション" fontName:@"HiraKakuProN-W6" fontSize:18];
		label.position            = ccp(60.0f, size.height-60.0f);
        label.anchorPoint         = CGPointZero;
        [self addChild: label];

        CCLabelTTF *vol = [CCLabelTTF labelWithString:@"BGMボリューム" fontName:@"HiraKakuProN-W6" fontSize:12];
		vol.position    =  ccp(80.0f, size.height-90.0f);
        vol.anchorPoint = CGPointZero;
        [self addChild: vol];

        CCLabelTTF *se = [CCLabelTTF labelWithString:@"S　E" fontName:@"HiraKakuProN-W6" fontSize:12];
		se.position    =  ccp(80.0f, size.height-130.0f);
        se.anchorPoint = CGPointZero;
        [self addChild: se];
    }
    
	return self;
}


- (void) dealloc{
	[super dealloc];
    [self.bg_image dealloc];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
}


#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}


@end
