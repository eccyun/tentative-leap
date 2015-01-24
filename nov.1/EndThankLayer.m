//
//  EndThankLayer.m
//  nov.1
//
//  Created by 田島僚 on 2015/01/11.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "EndThankLayer.h"
#import "TitleLayer.h"

@implementation EndThankLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *) scene{
    CCScene *scene = [CCScene node];
    
    EndThankLayer *layer = [EndThankLayer node];
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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"ありがとうございました！"
                                                             message:@"Leap〜ときをこえて〜をプレイしていただきありがとうございました！"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
        [alertView show];
    });
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene:[TitleLayer scene] withColor:ccBLACK]];
        });
    }
}

@end