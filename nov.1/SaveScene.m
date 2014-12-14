//
//  SaveScene.m
//  nov.1
//
//  Created by 田島僚 on 2014/03/16.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "SaveScene.h"
#import "LoadScene.h"

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
        self.isLoad         = NO;
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

    CCSprite *background = [[CCSprite alloc] initWithFile:@"save_background.png"];
    background.position  = ccp(size.width/2, size.height/2);
    [self addChild:background];

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

    BOOL alert_flag = NO;

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
        NSString *message = @"";
        
        if([self.function_flag isEqualToString:@"Save"]){
            message = @"セーブしますか？";
        }else if([self.function_flag isEqualToString:@"Load"]){
            NSString *save_flag_key = [NSString stringWithFormat:@"save_%d_flag",  self.save_key];

            // セーブ済みのものじゃない場合、処理を止める
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:save_flag_key] isEqualToString:@"saved"]){
                return YES;
            }

            message = @"ロードしますか？";
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                        message:message
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

    NSInteger load_key = [ud integerForKey:@"last_select_save_data"];
    
    //  UDから引っ張る
    for (int i=1; i<=6; i++){
        NSString *image_key     = [NSString stringWithFormat:@"save_%d_image", i];
        NSString *save_flag_key = [NSString stringWithFormat:@"save_%d_flag",  i];

        NSString *text_key      = [NSString stringWithFormat:@"save_%d_text", i];
        NSString *date_key      = [NSString stringWithFormat:@"save_%d_date", i];
        
        // 破棄処理
        [[self getChildByTag:6000+i] removeFromParentAndCleanup:(true)];
        [[self getChildByTag:6800+i] removeFromParentAndCleanup:(true)];

        // セーブウィンドウ 描画
        [[self getChildByTag:200+i] removeFromParentAndCleanup:(true)];
        
        CCSprite *save   = [[CCSprite alloc] initWithFile:(load_key==i)?@"save_light.png":@"save.png"];
        
        // 表示位置調整
        if(i == 1){
            save.position    = ccp(size.width/2 - 142.f, size.height/2 + 50.f);
        }else if(i == 2){
            save.position  = ccp(size.width/2, size.height/2 + 50.f);
        }else if(i == 3){
            save.position  = ccp(size.width/2 + 142.f, size.height/2 + 50.f);
        }else if(i == 4){
            save.position  = ccp(size.width/2 - 142.f, size.height/2 - 62.f);
        }else if(i == 5){
            save.position  = ccp(size.width/2, size.height/2 - 62.f);
        }else if(i == 6){
            save.position  = ccp(size.width/2 + 142.f, size.height/2 - 62.f);
        }
        
        [self addChild:save];
        save.tag = 200+i;
        
        // セーブフラグがたってるウィンドウはレンダリングを開始する
        if([[ud objectForKey:save_flag_key] isEqualToString:@"saved"]){
            NSData     *imageData  = [ud objectForKey:image_key];

            // テキストの書き出しの部分
            CCLabelTTF *text_label = [[CCLabelTTF alloc] init];
            if((CCLabelTTF *)[self getChildByTag:6500+i]){
                // 更新
                text_label = (CCLabelTTF *)[self getChildByTag:6500+i];
                [text_label setString:[ud objectForKey:text_key]];
            }else{
                // 初期化
                text_label = [CCLabelTTF labelWithString:[ud objectForKey:text_key]
                                              dimensions:CGSizeMake(134.f, 20.f)
                                              hAlignment:NSTextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:10];
                [text_label setAnchorPoint:ccp(0,0)];
                text_label.zOrder   = 10001;
                text_label.tag      = 6500+i;
            }

            // 保存日
            CCLabelTTF *date_text = [[CCLabelTTF alloc] init];
            if((CCLabelTTF *)[self getChildByTag:6600+i]){
                // 更新
                date_text = (CCLabelTTF *)[self getChildByTag:6600+i];
                [date_text setString:[ud objectForKey:date_key]];
            }else{
                date_text = [CCLabelTTF labelWithString:[ud objectForKey:date_key]
                                             dimensions:CGSizeMake(134.f, 10.f)
                                             hAlignment:NSTextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:10];
                [date_text setAnchorPoint:ccp(0,0)];
                date_text.zOrder   = 10001;
                date_text.tag      = 6600+i;
            }

            CCSprite *frame = [CCSprite spriteWithFile:@"save_frame.png"];
            frame.zOrder    = 10000;

            CCSprite *cap   = [CCSprite spriteWithCGImage:[[UIImage imageWithData:imageData] CGImage] key:[NSString stringWithFormat:@"save_%d", i]];
            cap.zOrder      = 9999;
            cap.tag         = 6000+i;
            
            if(i == 1){
                cap.position        = ccp(size.width/2 - 142.f, size.height/2 + 50.f);
                text_label.position = ccp(size.width/2-208.f, size.height/2+5.f);
                date_text.position  = ccp(size.width/2-208.f, size.height/2+30.f);
            }else if(i == 2){
                cap.position        = ccp(size.width/2, size.height/2 + 50.f);
                text_label.position = ccp(size.width/2-66.f, size.height/2+5.f);
                date_text.position  = ccp(size.width/2-66.f, size.height/2+30.f);
            }else if(i == 3){
                cap.position        = ccp(size.width/2 + 142.f, size.height/2 + 50.f);
                text_label.position = ccp(size.width/2+76.f, size.height/2+5.f);
                date_text.position  = ccp(size.width/2+76.f, size.height/2+30.f);
            }else if(i == 4){
                cap.position        = ccp(size.width/2 - 142.f, size.height/2 - 62.f);
                text_label.position = ccp(size.width/2-208.f, size.height/2-107.f);
                date_text.position  = ccp(size.width/2-208.f, size.height/2-82.f);
            }else if(i == 5){
                cap.position        = ccp(size.width/2, size.height/2 - 62.f);
                text_label.position = ccp(size.width/2-66.f, size.height/2-107.f);
                date_text.position  = ccp(size.width/2-66.f, size.height/2-82.f);
            }else if(i == 6){
                cap.position  = ccp(size.width/2 + 142.f, size.height/2 - 62.f);
                text_label.position = ccp(size.width/2+76.f, size.height/2-107.f);
                date_text.position  = ccp(size.width/2+76.f, size.height/2-82.f);
            }

            frame.position = cap.position;
            frame.tag      = 6800+i;

            [self addChild:cap];
            [self addChild:frame];

            // 配置されてなかったら、ラベルを貼付けする
            if(!(CCLabelTTF *)[self getChildByTag:6500+i]){
                [self addChild:text_label];
            }
            if(!(CCLabelTTF *)[self getChildByTag:6600+i]){
                [self addChild:date_text];
            }
        }
    }
    
}

# pragma mark -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(self.isLoad){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LoadScene scene] withColor:ccBLACK]];
        return;
    }
    
    // キーの定義
    NSString *script_key    = [NSString stringWithFormat:@"save_%d_script", self.save_key];
    NSString *structure_key = [NSString stringWithFormat:@"save_%d_structure", self.save_key];
    NSString *image_key     = [NSString stringWithFormat:@"save_%d_image", self.save_key];
    NSString *save_flag_key = [NSString stringWithFormat:@"save_%d_flag",  self.save_key];
    NSString *save_text_key = [NSString stringWithFormat:@"save_%d_text",  self.save_key];
    NSString *save_date_key = [NSString stringWithFormat:@"save_%d_date",  self.save_key];
    
    if([self.function_flag isEqualToString:@"Save"]){
        if(buttonIndex == 1){
            NSInteger script_index    = [[NSUserDefaults standardUserDefaults] integerForKey:@"quick_script_index"];
            NSInteger structure_index = [[NSUserDefaults standardUserDefaults] integerForKey:@"quick_structure_index"];

            // クイックスタート完了
            NSData          *imageData = UIImagePNGRepresentation(self.screen_capture);
            NSDate          *_date     = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSString *_date_text = [formatter stringFromDate:_date];

            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:script_index forKey:script_key];
            [ud setInteger:structure_index forKey:structure_key];
            [ud setObject:imageData forKey:image_key];
            [ud setObject:@"saved" forKey:save_flag_key];
            [ud setObject:self.save_text forKey:save_text_key];
            [ud setObject:_date_text forKey:save_date_key];
            [ud setInteger:self.save_key forKey:@"last_select_save_data"];
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
        if(buttonIndex == 1){
            // ロードシーンのインスタンスを作る
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:[ud integerForKey:structure_key] forKey:@"quick_structure_index"];
            [ud setInteger:[ud integerForKey:script_key] forKey:@"quick_script_index"];
            [ud setInteger:1 forKey:@"quick_start_flag"];
            [ud setInteger:self.save_key forKey:@"last_select_save_data"];
            [ud synchronize];

            self.isLoad        = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                            message:@"ロードしました！"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"確認", nil];
            [alert show];
            
        }
    }
}

@end