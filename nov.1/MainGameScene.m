//
//  HelloWorldLayer.m
//  nov.1
//
//  Created by eccyun on 2012/12/09.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

// Import the interfaces
#import "MainGameScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "SettingsScene.h"
#import "TitleLayer.h"
#import "LoadScene.h"
#import "SaveScene.h"

#define character_width 332

// HelloWorldLayer implementation
@implementation MainGameScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
	CCScene *scene = [CCScene node];

	MainGameScene *layer = [MainGameScene node];
	[scene addChild: layer];

	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
	CGSize size = [[CCDirector sharedDirector] winSize];

    //画面取得
	if((self=[super init])){
        self.isTouchEnabled = YES;
        self.isCheck        = NO;

        // スクリプトエンジンの初期化
        self.engine           = [[TentativeEngine alloc] init];
        self.back_bg          = [[CCSprite alloc] init];
        self.back_bg.position = ccp(size.width/2, size.height/2);
        [self addChild:self.back_bg];

        self.message_text = [[NSString alloc] init];
        self.line_count   = 0;

        if([[NSUserDefaults standardUserDefaults] integerForKey:@"quick_start_flag"] == 0){
            NSMutableArray *instruct = [self.engine readScript];
            [self doInstruct:instruct spriteSize:size];
        }else{
            NSInteger script_key = [[NSUserDefaults standardUserDefaults] integerForKey:@"quick_script_index"];

            for(int i=0; i<=script_key; i++){
                NSMutableArray *instruct = [self.engine readScript];
                [self doInstruct:instruct spriteSize:size];

                if([self.engine getReadScriptIndex] >= script_key){
                    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                    [ud setInteger:1 forKey:@"quick_start_flag"];
                    [ud synchronize];

                    break;
                }
            }
        }
        
        // クイックスタート完了
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:0 forKey:@"quick_start_flag"];
        [ud synchronize];
    }

	return self;
}

#pragma mark - instruct

- (void)doInstruct:(NSMutableArray *)instruct spriteSize:(CGSize) size{
    for (int i=0; i<[instruct count]; i++){
        CCTexture2D         *tex        = [[CCTexture2D alloc] init];
        NSMutableDictionary *dictionary = [instruct objectAtIndex:i];

        if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# BG"]){
            self.hyper          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"bg_name"]];
            self.hyper.position = ccp(size.width/2, size.height/2);
            [self addChild:self.hyper];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# IMG"]){
            if([[dictionary objectForKey:@"position"] isEqualToString:@"center"]){
                if(!self.center){
                    self.center          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                    self.center.position = ccp(size.width/2, size.height/2);
                    [self.center runAction:[CCFadeIn actionWithDuration:0.3f]];
                    [self addChild:self.center];
                }else{
                    NSRange range = [[dictionary objectForKey:@"img_name"] rangeOfString:@"_up"];
                    if (range.location != NSNotFound || self.isUp) {
                        [self.center runAction:[CCFadeOut actionWithDuration:0.3f]];
                        tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                        [self.center setTexture:tex];
                        [self.center setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
                        [self.center runAction:[CCFadeIn actionWithDuration:0.3f]];
                        self.isUp = (self.isUp)?NO:YES;
                    }else{
                        tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                        [self.center setTexture:tex];
                        [self.center setTextureRect:CGRectMake(0, 0,tex.contentSize.width, tex.contentSize.height)];
                    }
                }
            }else if([[dictionary objectForKey:@"position"] isEqualToString:@"right"]){
                if(!self.right){
                    self.right          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                    self.right.position = ccp(((size.width/4)*3)+24.0f, size.height/2);
                    [self.right runAction:[CCFadeIn actionWithDuration:0.1f]];
                    [self addChild:self.right];
                }else{
                    [self.right runAction:[CCFadeOut actionWithDuration:0.1f]];
                    tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                    [self.right setTexture:tex];
                    [self.right setTextureRect:CGRectMake(0, 0, self.right.contentSize.width, self.right.contentSize.height)];
                    [self.right runAction:[CCFadeIn actionWithDuration:0.1f]];
                }
            }else if([[dictionary objectForKey:@"position"] isEqualToString:@"left"]){
                if(!self.left){
                    self.left          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                    self.left.position = ccp(((size.width/2)/2)-24.0f, size.height/2);
                    [self.left runAction:[CCFadeIn actionWithDuration:0.1f]];
                    [self addChild:self.left];
                }else{
                    [self.left runAction:[CCFadeOut actionWithDuration:0.1f]];
                    tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                    [self.left setTexture:tex];
                    [self.left setTextureRect:CGRectMake(0, 0, self.left.contentSize.width, self.left.contentSize.height)];
                    [self.left runAction:[CCFadeIn actionWithDuration:0.1f]];
                }
            }
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# STILL-IMG"]){
            CCSprite *still = (CCSprite *)[self getChildByTag:[[dictionary objectForKey:@"tags"] integerValue]];

            if (still) {
                // Image が既にあったら
                CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                [still setTexture:tex];
            }else{
                still     = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                still.tag = [[dictionary objectForKey:@"tags"] integerValue];

                // iPhone 5 以降との切り分けを行ったらラベルを追加
                int height = [still boundingBox].size.height;
                height     = [[CCDirector sharedDirector] winSize].height-height;

                if ([[dictionary objectForKey:@"direction"] isEqualToString:@"right"]) {
                    still.position = ccp((size.width/2)+[[dictionary objectForKey:@"x"] integerValue], (size.height-height)/2);
                }else if([[dictionary objectForKey:@"direction"] isEqualToString:@"left"]){
                    still.position = ccp((size.width/2)-[[dictionary objectForKey:@"x"] integerValue], (size.height-height)/2);
                }

                [still runAction:[CCFadeIn actionWithDuration:0.3f]];
                [self addChild:still];
            }
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# MSG"]){
            // ラベルを作成する（後でテクスチャーとして使用する
            NSString *text    = [[dictionary objectForKey:@"message"] stringByReplacingOccurrencesOfString: @"#BR#" withString: @"\n"];
            self.message_text = text;

            [[self getChildByTag:4500] removeFromParentAndCleanup:(true)];
            [[self getChildByTag:8500] removeFromParentAndCleanup:(true)];
            [[self getChildByTag:8501] removeFromParentAndCleanup:(true)];

            for(int i=0; i < self.line_count; i++){
                [[self getChildByTag:4510+i] removeFromParentAndCleanup:(true)];
            }

            self.msgWindow          = [[CCSprite alloc] initWithFile:@"message_window.png"];
            self.msgWindow.position = ccp(size.width/2, (size.height/5)+10.f);
            self.msgWindow.tag      = 4500;
            [self addChild:self.msgWindow];

            self.save_image          = [[CCSprite alloc] initWithFile:@"msg_window_save.png"];
            self.save_image.position = ccp(size.width/2+76.f, (size.height/12));
            self.save_image.tag      = 8500;
            [self addChild:self.save_image];
            self.save_image.zOrder = 1001;

            self.load_image          = [[CCSprite alloc] initWithFile:@"msg_window_load.png"];
            self.load_image.position = ccp(size.width/2+123.f, (size.height/12));
            self.load_image.tag      = 8501;
            [self addChild:self.load_image];
            self.load_image.zOrder = 1000;
            
            int len          = [text length];
            int base_length  = [text length];
            int _size        = 12;
            int _font        = @"HiraKakuProN-W6";
            int _line_height = 5;

            // テキスチャを切り出して配列で保存する
            NSMutableArray  *aLineString  = [[NSMutableArray alloc] init];  // 1行辺りのテキスチャをを
            NSString        *_string      = [[NSString alloc] init];        // 1行あたりの文字列
            NSInteger        _a_line_text = 30;
            
            // 文字情報を取得する
            for (int i=0; i<len; i++) {
                // 改行 1行あたりの文字列が30文字なので
                if(i%_a_line_text==0 && i > 0){
                    [aLineString addObject:_string];

                    // 残り文字数を更新
                    base_length = base_length - [_string length];

                    _string = [[NSString alloc] init];
                    _string = [NSString stringWithFormat:@"%@%@",_string,[text substringWithRange:NSMakeRange(i, 1)]];
                    continue;
                }

                _string = [NSString stringWithFormat:@"%@%@",_string,[text substringWithRange:NSMakeRange(i, 1)]];
            }

            // 後処理　もし残りがあれば
            if(base_length <= _a_line_text){
                [aLineString addObject:_string];
            }

            // アニメーションに向けた仕込み
            for(int i=0; i<[aLineString count]; i++){
                // ラベルの定義
                NSString   *data  = [aLineString objectAtIndex:i];

                CCLabelTTF *label = [CCLabelTTF labelWithString:data
                                                     dimensions:CGSizeMake(_size*[data length],_size)
                                                     hAlignment:NSTextAlignmentLeft fontName:_font fontSize:_size];
                [label setAnchorPoint:ccp(0,0)];
                label.tag = 4510+i;

                // iPhone 5 以降との切り分けを行ったらラベルを追加
                if([[CCDirector sharedDirector] winSize].width == 480.f){
                    label.position = ccp(48 , ((size.height/2)-self.msgWindow.position.y-10.f)-(_size*i)-(_line_height*i));
                }else{
                    label.position = ccp(93 , ((size.height/2)-self.msgWindow.position.y-10.f)-(_size*i)-(_line_height*i));
                }
                label.zOrder  = 1000;
                [self addChild:label];

                // テキスチャのセット
                NSMutableArray *textureMap = [[NSMutableArray alloc] init];

                for(int k=1; k<=[data length]; k++){
                    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:label.texture rect:CGRectMake(0,0, _size*k,_size)];
                    [textureMap addObject:frame];
                }

                float delay = 0.05f;

                NSMutableArray *dummyMap = [[NSMutableArray alloc] init];
                [dummyMap addObject:[CCSpriteFrame frameWithTexture:label.texture rect:CGRectMake(0,0,1,1)]];

                CCAnimation *animation = [CCAnimation animationWithSpriteFrames:textureMap delay:delay];
                CCAnimation *dummy     = [CCAnimation animationWithSpriteFrames:dummyMap delay:delay];
                
                // アクションの定義
                id _action         = [CCAnimate actionWithAnimation:animation];
                id actionDelayTime = [CCDelayTime actionWithDuration:1.5f*i];
                id dummyAnimation  = [CCAnimate actionWithAnimation:dummy];
                
                id callFunc   = [CCCallFunc actionWithTarget:self selector:@selector(isAnimationCheck)];
                id callFunced = [CCCallFunc actionWithTarget:self selector:@selector(isAnimationChecked)];

                if(i==0){
                    id sequence;

                    if(1==[aLineString count]){
                        sequence = [CCSequence actions: callFunc, _action, callFunced, nil];
                    }else{
                        sequence = [CCSequence actions: callFunc, _action, nil];
                    }

                    [label runAction:sequence];
                }else{
                    id sequence = [CCSequence actions: dummyAnimation, actionDelayTime, _action, callFunced, nil];
                    [label runAction:sequence];
                }
            }
            
            self.line_count = [aLineString count];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# WHITE;"]){
            [super onEnterTransitionDidFinish];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.5 scene:[MainGameScene scene] withColor:ccWHITE]];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# BLACK;"]){
            [super onEnterTransitionDidFinish];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.5 scene:[MainGameScene scene] withColor:ccBLACK]];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# REMOVE;"]){
            [self removeAllChildrenWithCleanup:YES];

            // 除去して次に送る
            NSMutableArray *instruct = [self.engine readScript];
            [self doInstruct:instruct spriteSize:size];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"LOADING;"]){
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:[[ud objectForKey:@"structure_index"] integerValue]+1 forKey:@"structure_index"];
            [ud setInteger:0 forKey:@"script_index"];
            [ud synchronize];

            // ロード処理
            [super onEnterTransitionDidFinish];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene:[LoadScene scene] withColor:ccBLACK]];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"EOF;"]){
            [super onEnterTransitionDidFinish];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene] withColor:ccWHITE]];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# BGM"]){
            //BGM開始
            CGFloat         volume_value = 1.f;

            if([[dictionary objectForKey:@"action"] isEqualToString:@"LOAD"]){
                [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[dictionary objectForKey:@"bgm_name"]];
            }else if([[dictionary objectForKey:@"action"] isEqualToString:@"PLAY"]){
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[dictionary objectForKey:@"bgm_name"] loop:YES];
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:volume_value];
            }else if([[dictionary objectForKey:@"action"] isEqualToString:@"STOP"]){
                [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
            }else if([[dictionary objectForKey:@"action"] isEqualToString:@"RESUME"]){
                [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            }
        }

        self.msgWindow.zOrder  = 997;
    }
}

- (void) isAnimationCheck{
    self.isCheck = YES;
}

- (void) isAnimationChecked{
    self.isCheck = NO;
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

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // タップ時の座標とホームボタンの座標をチェックしてtrueの場合　画面遷移
	CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];

    if(location.x > self.load_image.position.x-(self.load_image.contentSize.width/2)&&
       location.x < self.load_image.position.x+(self.load_image.contentSize.width/2)&&
       location.y > self.load_image.position.y-(self.load_image.contentSize.height/2)&&
       location.y < self.load_image.position.y+(self.load_image.contentSize.height/2)){
        
        // セーブシーンに移動
        CCScene   *scene        = [SaveScene scene];
        SaveScene *saveScene    = [scene.children objectAtIndex:0];
        saveScene.function_flag = @"Load";
        
        [[CCDirector sharedDirector] pushScene:scene];
        return YES;
    }else if(location.x > self.save_image.position.x-(self.save_image.contentSize.width/2)&&
             location.x < self.save_image.position.x+(self.save_image.contentSize.width/2)&&
             location.y > self.save_image.position.y-(self.save_image.contentSize.height/2)&&
             location.y < self.save_image.position.y+(self.save_image.contentSize.height/2)){
        // セーブシーンに移動
        CCScene   *scene         = [SaveScene scene];
        SaveScene *saveScene     = [scene.children objectAtIndex:0];
        saveScene.function_flag  = @"Save";

        // リサイズの幅と高さを取得
        CGFloat ratio  = size.width/400.f;
        CGFloat width  = 400.f;
        CGFloat height = size.height/ratio;

        UIImage *image           = [self resizeImage:[self getCurrentScreenCapture] rect:CGRectMake(0.f, 0.f, width, height)];
        width                    = 267.f;
        height                   = 205.f;
        saveScene.screen_capture = [self croppingImage:image imageRect:CGRectMake((image.size.width/2.f)-(width/2.f), image.size.height-height, width, height)];

        if([self.message_text length] > 20){
            saveScene.save_text = [NSString stringWithFormat:@"%@...",[self.message_text substringWithRange:NSMakeRange(0, 20)]];
        }else{
            saveScene.save_text = [NSString stringWithFormat:@"%@...",self.message_text];
        }

        [[CCDirector sharedDirector] pushScene:scene];

        return YES;
    }

    if(self.isCheck){

        [[self getChildByTag:4500] stopAllActions];
        [[self getChildByTag:4500] removeFromParentAndCleanup:(true)];
        [[self getChildByTag:8500] removeFromParentAndCleanup:(true)];
        [[self getChildByTag:8501] removeFromParentAndCleanup:(true)];

        for(int i=0; i < self.line_count; i++){
            [[self getChildByTag:4510+i] stopAllActions];
            [[self getChildByTag:4510+i] removeFromParentAndCleanup:(true)];
        }

        self.msgWindow          = [[CCSprite alloc] initWithFile:@"message_window.png"];
        self.msgWindow.position = ccp(size.width/2, (size.height/5)+10.f);
        self.msgWindow.tag      = 4500;
        [self addChild:self.msgWindow];
        
        self.save_image          = [[CCSprite alloc] initWithFile:@"msg_window_save.png"];
        self.save_image.position = ccp(size.width/2+76.f, (size.height/12));
        self.save_image.tag      = 8500;
        [self addChild:self.save_image];
        self.save_image.zOrder = 1001;
        
        self.load_image          = [[CCSprite alloc] initWithFile:@"msg_window_load.png"];
        self.load_image.position = ccp(size.width/2+123.f, (size.height/12));
        self.load_image.tag      = 8501;
        [self addChild:self.load_image];
        self.load_image.zOrder = 1000;
        
        self.isCheck = NO;

        int len          = [self.message_text length];
        int base_length  = [self.message_text length];
        int _size        = 12;
        int _font        = @"HiraKakuProN-W6";
        int _line_height = 5;

        // テキスチャを切り出して配列で保存する
        NSMutableArray  *aLineString  = [[NSMutableArray alloc] init];  // 1行辺りのテキスチャをを
        NSString        *_string      = [[NSString alloc] init];        // 1行あたりの文字列
        NSInteger        _a_line_text = 30;
        
        // 文字情報を取得する
        for (int i=0; i<len; i++) {
            // 改行 1行あたりの文字列が30文字なので
            if(i%_a_line_text==0 && i > 0){
                [aLineString addObject:_string];
                
                // 残り文字数を更新
                base_length = base_length - [_string length];
                
                _string = [[NSString alloc] init];
                _string = [NSString stringWithFormat:@"%@%@",_string,[self.message_text substringWithRange:NSMakeRange(i, 1)]];
                continue;
            }

            _string = [NSString stringWithFormat:@"%@%@",_string,[self.message_text substringWithRange:NSMakeRange(i, 1)]];
        }
        
        
        // 後処理　もし残りがあれば
        if(base_length <= _a_line_text){
            [aLineString addObject:_string];
        }

        // アニメーションに向けた仕込み
        for(int i=0; i<[aLineString count]; i++){
            // ラベルの定義
            NSString   *data  = [aLineString objectAtIndex:i];
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:data
                                                 dimensions:CGSizeMake(_size*[data length],_size)
                                                 hAlignment:NSTextAlignmentLeft fontName:_font fontSize:_size];
            [label setAnchorPoint:ccp(0,0)];
            label.tag = 4510+i;

            // iPhone 5 以降との切り分けを行ったらラベルを追加
            if([[CCDirector sharedDirector] winSize].width == 480.f){
                label.position = ccp(48 , ((size.height/2)-self.msgWindow.position.y-10.f)-(_size*i)-(_line_height*i));
            }else{
                label.position = ccp(93 , ((size.height/2)-self.msgWindow.position.y-10.f)-(_size*i)-(_line_height*i));
            }
            
            label.zOrder  = 1000;
            [self addChild:label];
        }

        return YES;
    }
    
    NSMutableArray *instruct = [self.engine readScript];
    [self doInstruct:instruct spriteSize:size];

    self.msgWindow.zOrder  = 997;
    
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


-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)runTextAnimation : (NSString *) text dimensions : (CGSize) size isFirstRender : (BOOL) flag{
    //文字数を確認
    int len = [text length];
    
    if(flag){
        // ラベルを作成する（後でテクスチャーとして使用する）
        self.msgLabel = [CCLabelTTF labelWithString:text
                                         dimensions:size
                                         hAlignment:UITextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:13];
        [self.msgLabel setAnchorPoint:ccp(0,0)];
        // self.msgLabel.position = ccp(10 , size.height/self.msgWindow.position.y-10.0f);
        
        // 表示位置を決定する
        self.msgLabel.position =  ccp(10 , (size.height/2)+self.msgWindow.position.y-20.f);
        
        // NSlayerの子要素にlabel表示を追加
        [self addChild:self.msgLabel];
    }else{
        [self.msgLabel setString:text];
    }
    
    //追加可能な配列NSMutableArrayを定義する
    NSMutableArray *animFrames = [[NSMutableArray alloc] init];
	
	//文字数毎にラベルで作成したテクスチャーから表示範囲を決定、アニメーションフレーム配列に格納する
	for (int i=1; i<=len; i++) {
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:self.msgLabel.texture rect:CGRectMake(0,0,13*i,13)];
		[animFrames addObject:frame];
	}
    
	//アニメーションを定義（NSArrayの中身を順に表示する）
	float delay = 0.1f;
	CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:delay];
	
	//idつけてアクション定義
	id action1 = [CCAnimate actionWithAnimation:animation];
    
	//アクション実行
	[self.msgLabel runAction:action1];
}


- (UIImage *) getCurrentScreenCapture{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
    [rtx beginWithClear:0 g:0 b:0 a:1.0f];
    [[[CCDirector sharedDirector] runningScene] visit];
    [rtx end];
    
    return [rtx getUIImage];
}

//UIImageをリサイズするクラス
- (UIImage*)resizeImage:(UIImage *)img rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);

    [img drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)croppingImage:(UIImage *)imageToCrop imageRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage   *cropped  = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return cropped;
}

@end
