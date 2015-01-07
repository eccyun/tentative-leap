//
//  EndingLayer.m
//  nov.1
//
//  Created by 田島僚 on 2014/12/31.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "EndingLayer.h"


@implementation EndingLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
    CCScene *scene = [CCScene node];
    
    EndingLayer *layer = [EndingLayer node];
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    if((self=[super init])){
        self.count          = 0;
        self.delegate       = (AppController *)[[UIApplication sharedApplication] delegate];

        //オーディオプレイヤー初期化
        AVAudioPlayer *audioPlayer = (AVAudioPlayer *)self.delegate.bgmMap[@""];
        audioPlayer.volume         = 1.f;
        [audioPlayer play];

        [self displayChangeScene];
    }
    
    return self;
}

- (void) displayChangeScene{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    self.count = self.count+1;
    
    if(self.count==1){
        self.isTouchEvent = YES;
        
        // 背景画像
        self.back_image          = [[CCSprite alloc] initWithFile : @"navigation-01-hd.png"];
        self.back_image.position = ccp(size.width/2, size.height/2);
        [self.back_image runAction:[CCFadeIn actionWithDuration:0.3f]];
        [self addChild:self.back_image];
    }else if(self.count==2){
        self.isTouchEvent = YES;
        
        // 背景画像
        CCTexture2D *tex = [[CCTexture2D alloc] init];
        [self.back_image runAction:[CCFadeOut actionWithDuration:0.3f]];
        tex = [[CCTextureCache sharedTextureCache] addImage:@"navigation-02-hd.png"];
        [self.back_image setTexture:tex];
        [self.back_image setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
        [self.back_image runAction:[CCFadeIn actionWithDuration:0.3f]];
    }else if(self.count==3){
        self.isTouchEvent = NO;
        [self.back_image runAction:[CCFadeOut actionWithDuration:0.3f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:1.5f];
    }else if(self.count==4){
        // 背景画像
        CCTexture2D *tex = [[CCTexture2D alloc] init];
        tex              = [[CCTextureCache sharedTextureCache] addImage:@"notice-hd.png"];
        [self.back_image setTexture:tex];
        [self.back_image setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
        [self.back_image runAction:[CCFadeIn actionWithDuration:0.3f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:3.f];
    }else if(self.count==5){
        [self.back_image runAction:[CCFadeOut actionWithDuration:0.3f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:3.f];
    }else if(self.count==6){
        
    }
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

@end