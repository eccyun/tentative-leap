//
//  IntroductionLayer.m
//  nov.1
//
//  Created by 田島僚 on 2014/12/29.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "IntroductionLayer.h"
#import "MainGameScene.h"

@implementation IntroductionLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
    CCScene *scene = [CCScene node];
    
    IntroductionLayer *layer = [IntroductionLayer node];
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    if((self=[super init])){
        self.count          = 0;
        self.isTouchEnabled = YES;
        
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:3.f];
    }
    
    return self;
}

- (void) displayChangeScene{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    self.count = self.count+1;

    if(self.count==1){
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.sound_name     = @"";
        
        self.isTouchEvent = YES;

        // 背景画像
        self.back_image          = [[CCSprite alloc] initWithFile : @"navigation-01-hd.png"];
        self.back_image.position = ccp(size.width/2, size.height/2);
        [self.back_image runAction:[CCFadeIn actionWithDuration:0.3f]];
        [self addChild:self.back_image];
    }else if(self.count==2){
        self.isTouchEvent = YES;

        // 背景画像
        [self.back_image runAction:[CCFadeOut actionWithDuration:0.3f]];
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:@"navigation-02-hd.png"];
        [self.back_image setTexture:tex];
        [self.back_image setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
        [self.back_image runAction:[CCFadeIn actionWithDuration:0.3f]];
    }else if(self.count==3){
        self.isTouchEvent = NO;
        [self.back_image runAction:[CCFadeOut actionWithDuration:0.3f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:1.5f];
    }else if(self.count==4){
        // 背景画像
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:@"notice-hd.png"];
        [self.back_image setTexture:tex];
        [self.back_image setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
        [self.back_image runAction:[CCFadeIn actionWithDuration:0.3f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:3.f];
    }else if(self.count==5){
        [self.back_image runAction:[CCFadeOut actionWithDuration:0.3f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:3.f];
    }else if(self.count==6){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainGameScene scene] withColor:ccBLACK]];
    }
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!self.isTouchEvent){
        return YES;
    }

    if(self.count==1){
        [self displayChangeScene];
    }else if(self.count==2){
        [self displayChangeScene];
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