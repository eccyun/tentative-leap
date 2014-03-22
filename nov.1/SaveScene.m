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
+ (CCScene *) scene{
	CCScene *scene = [CCScene node];
    
    SaveScene *layer = [SaveScene node];
	[scene addChild: layer];

    // return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    if((self=[super init])){
        self.isTouchEnabled = YES;
        self.save_key       = 0;
    }
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[super dealloc];
}

-(void) onEnter{
	[super onEnter];

    [self renderingSaveWindow];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *background = [[CCSprite alloc] initWithFile:@"save_background.png"];
    background.position  = ccp(size.width/2, size.height/2);
    [self addChild:background];

    CCSprite *save_1 = [[CCSprite alloc] initWithFile:@"save_1.png"];
    save_1.position  = ccp(size.width/2 - 142.f, size.height/2 + 50.f);
    [self addChild:save_1];
    save_1.tag = 201;

    CCSprite *save_2 = [[CCSprite alloc] initWithFile:@"save_2.png"];
    save_2.position  = ccp(size.width/2, size.height/2 + 50.f);
    [self addChild:save_2];
    save_2.tag = 202;

    CCSprite *save_3 = [[CCSprite alloc] initWithFile:@"save_3.png"];
    save_3.position  = ccp(size.width/2 + 142.f, size.height/2 + 50.f);
    [self addChild:save_3];
    save_3.tag = 203;

    CCSprite *save_4 = [[CCSprite alloc] initWithFile:@"save_4.png"];
    save_4.position  = ccp(size.width/2 - 142.f, size.height/2 - 62.f);
    [self addChild:save_4];
    save_4.tag = 204;

    CCSprite *save_5 = [[CCSprite alloc] initWithFile:@"save_5.png"];
    save_5.position  = ccp(size.width/2, size.height/2 - 62.f);
    [self addChild:save_5];
    save_5.tag = 205;

    CCSprite *save_6 = [[CCSprite alloc] initWithFile:@"save_6.png"];
    save_6.position  = ccp(size.width/2 + 142.f, size.height/2 - 62.f);
    [self addChild:save_6];
    save_6.tag = 206;

    // 左上のウィンドウ
    NSString *save_text = @"";
    NSString *load_text = @"";
    
    if([self.function_flag isEqualToString:@"Load"]){
        save_text = @"save_off.png";
        load_text = @"load_on.png";
    }else if([self.function_flag isEqualToString:@"Save"]){
        save_text = @"save_on.png";
        load_text = @"load_off.png";
    }
    
    CCSprite *load = [[CCSprite alloc] initWithFile:load_text];
    load.position  = ccp(size.width/2 - 100.f, size.height/2 + 140.f);
    [self addChild:load];

    CCSprite *save = [[CCSprite alloc] initWithFile:save_text];
    save.position  = ccp(size.width/2 - 182.f, size.height/2 + 139.f);
    [self addChild:save];


    CCSprite *back_btn = [[CCSprite alloc] initWithFile:@"save_back.png"];
    back_btn.position  = ccp(size.width/2 + 182.f, size.height/2 - 142.f);
    [self addChild:back_btn];
    back_btn.tag = 1;

    [self renderingSaveWindow];
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];

    CCSprite *back_btn = (CCSprite *)[self getChildByTag:1];
    CCSprite *save_1   = (CCSprite *)[self getChildByTag:201];
    CCSprite *save_2   = (CCSprite *)[self getChildByTag:202];
    CCSprite *save_3   = (CCSprite *)[self getChildByTag:203];
    CCSprite *save_4   = (CCSprite *)[self getChildByTag:204];
    CCSprite *save_5   = (CCSprite *)[self getChildByTag:205];
    CCSprite *save_6   = (CCSprite *)[self getChildByTag:206];

    BOOL      alert_flag = NO;
    
    if(location.x > back_btn.position.x-(back_btn.contentSize.width/2)&&
       location.x < back_btn.position.x+(back_btn.contentSize.width/2)&&
       location.y > back_btn.position.y-(back_btn.contentSize.height/2)&&
       location.y < back_btn.position.y+(back_btn.contentSize.height/2)){
        [[CCDirector sharedDirector] popScene];
        return YES;
    }else if(location.x > save_1.position.x-(save_1.contentSize.width/2)&&
             location.x < save_1.position.x+(save_1.contentSize.width/2)&&
             location.y > save_1.position.y-(save_1.contentSize.height/2)&&
             location.y < save_1.position.y+(save_1.contentSize.height/2)){
        self.save_key = 1;
        alert_flag    = YES;
    }else if(location.x > save_2.position.x-(save_2.contentSize.width/2)&&
             location.x < save_2.position.x+(save_2.contentSize.width/2)&&
             location.y > save_2.position.y-(save_2.contentSize.height/2)&&
             location.y < save_2.position.y+(save_2.contentSize.height/2)){
        self.save_key = 2;
        alert_flag    = YES;
    }else if(location.x > save_3.position.x-(save_3.contentSize.width/2)&&
             location.x < save_3.position.x+(save_3.contentSize.width/2)&&
             location.y > save_3.position.y-(save_3.contentSize.height/2)&&
             location.y < save_3.position.y+(save_3.contentSize.height/2)){
        self.save_key = 3;
        alert_flag    = YES;
    }else if(location.x > save_4.position.x-(save_4.contentSize.width/2)&&
             location.x < save_4.position.x+(save_4.contentSize.width/2)&&
             location.y > save_4.position.y-(save_4.contentSize.height/2)&&
             location.y < save_4.position.y+(save_4.contentSize.height/2)){
        self.save_key = 4;
        alert_flag    = YES;
    }else if(location.x > save_5.position.x-(save_5.contentSize.width/2)&&
             location.x < save_5.position.x+(save_5.contentSize.width/2)&&
             location.y > save_5.position.y-(save_5.contentSize.height/2)&&
             location.y < save_5.position.y+(save_5.contentSize.height/2)){
        self.save_key = 5;
        alert_flag    = YES;
    }else if(location.x > save_6.position.x-(save_6.contentSize.width/2)&&
             location.x < save_6.position.x+(save_6.contentSize.width/2)&&
             location.y > save_6.position.y-(save_6.contentSize.height/2)&&
             location.y < save_6.position.y+(save_6.contentSize.height/2)){
        self.save_key = 6;
        alert_flag    = YES;

    }

    if(alert_flag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                        message:@"セーブしますか？"
                                                       delegate:self
                                              cancelButtonTitle:@"いいえ"
                                              otherButtonTitles:@"はい", nil];
        [alert show];
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

# pragma mark -

- (void) renderingSaveWindow{
    CGSize          size = [[CCDirector sharedDirector] winSize];
    NSUserDefaults *ud   = [NSUserDefaults standardUserDefaults];

    // キャッシュの破棄
    [[CCTextureCache sharedTextureCache] removeAllTextures];

    for (int i=1; i<=6; i++){
        NSString *image_key     = [NSString stringWithFormat:@"save_%d_image", i];
        NSString *save_flag_key = [NSString stringWithFormat:@"save_%d_flag",  i];

        // 破棄処理
        [[self getChildByTag:6000+i] removeFromParentAndCleanup:(true)];

        // セーブフラグがたってるウィンドウはレンダリングを開始する
        if([[ud objectForKey:save_flag_key] isEqualToString:@"saved"]){
            NSData* imageData = [ud objectForKey:image_key];

            CCSprite *cap = [CCSprite spriteWithCGImage:[[UIImage imageWithData:imageData] CGImage] key:[NSString stringWithFormat:@"save_%d", i]];
            cap.zOrder    = 9999;
            cap.tag       = 6000+i;

            if(i == 1){
                cap.position  = ccp(size.width/2 - 142.f, size.height/2 + 50.f);
            }else if(i == 2){
                cap.position  = ccp(size.width/2, size.height/2 + 50.f);
            }else if(i == 3){
                cap.position  = ccp(size.width/2 + 142.f, size.height/2 + 50.f);
            }else if(i == 4){
                cap.position  = ccp(size.width/2 - 142.f, size.height/2 - 62.f);
            }else if(i == 5){
                cap.position  = ccp(size.width/2, size.height/2 - 62.f);
            }else if(i == 6){
                cap.position  = ccp(size.width/2 + 142.f, size.height/2 - 62.f);
            }
            [self addChild:cap];
        }
        
    }
    
}

# pragma mark -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // キーの定義
    NSString *script_key    = [NSString stringWithFormat:@"save_%d_script", self.save_key];
    NSString *structure_key = [NSString stringWithFormat:@"save_%d_structure", self.save_key];
    NSString *image_key     = [NSString stringWithFormat:@"save_%d_image", self.save_key];
    NSString *save_flag_key = [NSString stringWithFormat:@"save_%d_flag",  self.save_key];

    if([self.function_flag isEqualToString:@"Save"]){
        if(buttonIndex == 1){
            NSInteger script_index    = [[NSUserDefaults standardUserDefaults] integerForKey:@"quick_script_index"];
            NSInteger structure_index = [[NSUserDefaults standardUserDefaults] integerForKey:@"quick_structure_index"];

            // クイックスタート完了
            NSData *imageData = UIImagePNGRepresentation(self.screen_capture);

            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:script_index forKey:script_key];
            [ud setInteger:structure_index forKey:structure_key];
            [ud setObject:imageData forKey:image_key];
            [ud setObject:@"saved" forKey:save_flag_key];
            [ud synchronize];
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                            message:@"セーブしました！"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"確認", nil];
            [alert show];

            [self renderingSaveWindow];
        }
    }else if([self.function_flag isEqualToString:@"Load"]){
        
    }
}

@end