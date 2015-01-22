//
//  EndingLayer.m
//  nov.1
//
//  Created by 田島僚 on 2014/12/31.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "EndingLayer.h"
#import "LoadScene.h"

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
        self.img_count      = 0;
        self.delegate       = (AppController *)[[UIApplication sharedApplication] delegate];
        [self.delegate refreshPlayer];
        
        //オーディオプレイヤー初期化
        AVAudioPlayer *audioPlayer = (AVAudioPlayer *)self.delegate.bgmMap[@"leap-ending.mp3"];
        audioPlayer.currentTime    = 0.f;
        audioPlayer.volume         = 1.f;
        audioPlayer.numberOfLoops  = 0;
        [audioPlayer play];

        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:2.f];
    }
    
    return self;
}

- (void) displayChangeScene{
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.count = self.count+1;
    
    // 終了処理
    if(self.img_count==10){
        //オーディオプレイヤー初期化
        AVAudioPlayer *audioPlayer = (AVAudioPlayer *)self.delegate.bgmMap[@"leap-ending.mp3"];
        [audioPlayer stop];
        audioPlayer.currentTime = 0.f;
        audioPlayer.volume      = 0.f;

        CCScene   *scene        = [LoadScene scene];
        LoadScene *loadScene    = [scene.children objectAtIndex:0];
        loadScene.isReturnTitle = NO;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene:scene withColor:ccBLACK]];
        
        return;
    }

    if(self.count==1){
        self.img_count = self.img_count+1;
        // 背景画像
        self.back_image          = [[CCSprite alloc] initWithFile : @"ending-1.png"];
        self.back_image.position = ccp(size.width/2, size.height/2);
        [self.back_image runAction:[CCFadeIn actionWithDuration:2.f]];
        [self addChild:self.back_image];
        
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:9.f];
    }else if(self.count%2!=0){
        self.img_count = self.img_count+1;

        // 背景画像
        CCTexture2D *tex = [[CCTexture2D alloc] init];
        tex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"ending-%ld.png", (long)self.img_count]];
        [self.back_image setTexture:tex];
        [self.back_image setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
        [self.back_image runAction:[CCFadeIn actionWithDuration:2.f]];

        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:9.f];
     }else{
        [self.back_image runAction:[CCFadeOut actionWithDuration:2.f]];
        [self performSelector:@selector(displayChangeScene) withObject:nil afterDelay:4.5f];
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