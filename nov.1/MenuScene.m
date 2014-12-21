//
//  MenuLayer.m
//  nov.1
//
//  Created by 田島僚 on 2014/12/21.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "SaveScene.h"
#import "SimpleAudioEngine.h"
#import "LoadScene.h"

@implementation MenuScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *) scene{
    CCScene *scene = [CCScene node];
    
    MenuScene *layer = [MenuScene node];
    [scene addChild: layer];

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    if((self=[super init])){
        self.isTouchEnabled = YES;
    }
    
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    [super dealloc];
}

-(void) onEnter{
    [super onEnter];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *background = [[CCSprite alloc] initWithFile:@"menu_bg.png"];
    background.position  = ccp(size.width/2, size.height/2);
    [self addChild:background];

    CCSprite *menu = [[CCSprite alloc] initWithFile:@"msg_menu.png"];
    menu.position  = ccp(size.width/2 - 182.f, size.height/2 + 129.f);
    [self addChild:menu];

    CCSprite *back_game = [[CCSprite alloc] initWithFile:@"back_game.png"];
    back_game.position  = ccp(size.width/2, size.height/2 + 69.f);
    [self addChild:back_game];
    back_game.tag = 2;

    CCSprite *save_btn = [[CCSprite alloc] initWithFile:@"menu_save.png"];
    save_btn.position  = ccp(size.width/2, size.height/2 + 9.f);
    [self addChild:save_btn];
    save_btn.tag = 3;

    CCSprite *load_btn = [[CCSprite alloc] initWithFile:@"menu_load.png"];
    load_btn.position  = ccp(size.width/2, size.height/2 -51.f);
    [self addChild:load_btn];
    load_btn.tag = 4;

    CCSprite *back_title = [[CCSprite alloc] initWithFile:@"back_title.png"];
    back_title.position  = ccp(size.width/2, size.height/2 - 101.f);
    [self addChild:back_title];
    back_title.tag = 5;
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    // タップ時の座標とホームボタンの座標をチェックしてtrueの場合　画面遷移
    CGPoint location = [touch locationInView:[touch view]];
    location         = [[CCDirector sharedDirector] convertToGL:location];
    
    CCSprite *back_game  = (CCSprite *)[self getChildByTag:2];
    CCSprite *save_btn   = (CCSprite *)[self getChildByTag:3];
    CCSprite *load_btn   = (CCSprite *)[self getChildByTag:4];
    CCSprite *back_title = (CCSprite *)[self getChildByTag:5];
    
    if(location.x > back_game.position.x-(back_game.contentSize.width/2)&&
       location.x < back_game.position.x+(back_game.contentSize.width/2)&&
       location.y > back_game.position.y-(back_game.contentSize.height/2)&&
       location.y < back_game.position.y+(back_game.contentSize.height/2)){
        // ゲーム本編に戻る
        [[CCDirector sharedDirector] popScene];
        return YES;
    }else if(location.x > save_btn.position.x-(save_btn.contentSize.width/2)&&
             location.x < save_btn.position.x+(save_btn.contentSize.width/2)&&
             location.y > save_btn.position.y-(save_btn.contentSize.height/2)&&
             location.y < save_btn.position.y+(save_btn.contentSize.height/2)){
        // セーブ画面へ
        CCScene   *scene         = [SaveScene scene];
        SaveScene *saveScene     = [scene.children objectAtIndex:0];
        saveScene.function_flag  = @"Save";
        saveScene.screen_capture = self.screen_capture;

        if([self.save_text length] > 20){
            saveScene.save_text = [NSString stringWithFormat:@"%@...",[self.save_text substringWithRange:NSMakeRange(0, 20)]];
        }else{
            saveScene.save_text = [NSString stringWithFormat:@"%@...",self.save_text];
        }

        [[CCDirector sharedDirector] pushScene:scene];
        return YES;
    }else if(location.x > load_btn.position.x-(load_btn.contentSize.width/2)&&
             location.x < load_btn.position.x+(load_btn.contentSize.width/2)&&
             location.y > load_btn.position.y-(load_btn.contentSize.height/2)&&
             location.y < load_btn.position.y+(load_btn.contentSize.height/2)){
        // ロード画面へ
        CCScene   *scene        = [SaveScene scene];
        SaveScene *saveScene    = [scene.children objectAtIndex:0];
        saveScene.function_flag = @"Load";

        [[CCDirector sharedDirector] pushScene:scene];
        return YES;
    }else if(location.x > back_title.position.x-(back_title.contentSize.width/2)&&
             location.x < back_title.position.x+(back_title.contentSize.width/2)&&
             location.y > back_title.position.y-(back_title.contentSize.height/2)&&
             location.y < back_title.position.y+(back_title.contentSize.height/2)){
        // ゲームタイトルへ
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                        message:@"ゲームを終了しますか？\n保存していないデータはクイックスタートから再開出来ます。"
                                                       delegate:self
                                              cancelButtonTitle:@"いいえ"
                                              otherButtonTitles:@"はい", nil];
        [alert show];
        return YES;
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        // ゲーム終了
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];

        CCScene   *scene        = [LoadScene scene];
        LoadScene *loadScene    = [scene.children objectAtIndex:0];
        loadScene.isReturnTitle = YES;
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene: scene withColor:ccBLACK]];
    }
}

@end