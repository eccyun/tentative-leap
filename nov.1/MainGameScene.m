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

	if((self=[super init])){
        self.isTouchEnabled = YES;
        // スクリプトエンジンの初期化
        self.engine              = [[TentativeEngine alloc] init];

        self.back_bg          = [[CCSprite alloc] init];
        self.back_bg.position = ccp(size.width/2, size.height/2);
        [self addChild:self.back_bg];
/*
        self.home_btn = [[CCSprite alloc] initWithFile:@"button.png"];
        self.home_btn.position = ccp(size.width-(self.home_btn.contentSize.width/2), size.height-(self.home_btn.contentSize.height/2));
        [self addChild:self.home_btn];
        self.home_btn.zOrder  = 998;
*/
        NSMutableArray *instruct = [self.engine readScript];
        [self doInstruct:instruct spriteSize:size];
    }

	return self;
}

#pragma mark - instruct

- (void)doInstruct:(NSMutableArray *)instruct spriteSize:(CGSize) size{
    for (int i=0; i<[instruct count]; i++){
        CCTexture2D         *tex        = [[CCTexture2D alloc] init];
        NSMutableDictionary *dictionary = [instruct objectAtIndex:i];

        if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# BG"]){
            if(!self.hyper){
                self.hyper          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"bg_name"]];
                self.hyper.position = ccp(size.width/2, size.height/2);
                [self addChild:self.hyper];
            }else{
                tex = [[CCTextureCache sharedTextureCache] addImage:@"BG_fan_03.jpg"];
                [self.back_bg setTexture:tex];
                [self.back_bg setTextureRect:CGRectMake(0, 0, self.hyper.contentSize.width, self.hyper.contentSize.height)];
                [self.msgLabel setString:@"[仁]すげえだろ！？"];
                [self.hyper runAction:[CCFadeOut actionWithDuration:1.0f]];
            }
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# IMG"]){
            if([[dictionary objectForKey:@"position"] isEqualToString:@"center"]){
                if(!self.center){
                    self.center          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                    self.center.position = ccp(size.width/2, size.height/2);
                    [self.center runAction:[CCFadeIn actionWithDuration:1.0f]];
                    [self addChild:self.center];
                }else{
                    [self.center runAction:[CCFadeOut actionWithDuration:1.0f]];
                    tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                    [self.center setTexture:tex];
                    [self.center setTextureRect:CGRectMake(0, 0, self.center.contentSize.width, self.center.contentSize.height)];
                    [self.center runAction:[CCFadeIn actionWithDuration:1.0f]];
                }
            }else if([[dictionary objectForKey:@"position"] isEqualToString:@"right"]){
                if(!self.right){
                    self.right          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                    self.right.position = ccp(((size.width/4)*3)+24.0f, size.height/2);
                    [self.right runAction:[CCFadeIn actionWithDuration:1.0f]];
                    [self addChild:self.right];
                }else{
                    [self.right runAction:[CCFadeOut actionWithDuration:1.0f]];
                    tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                    [self.right setTexture:tex];
                    [self.right setTextureRect:CGRectMake(0, 0, self.right.contentSize.width, self.right.contentSize.height)];
                    [self.right runAction:[CCFadeIn actionWithDuration:1.0f]];
                }
            }else if([[dictionary objectForKey:@"position"] isEqualToString:@"left"]){
                if(!self.left){
                    self.left          = [[CCSprite alloc] initWithFile:[dictionary objectForKey:@"img_name"]];
                    self.left.position = ccp(((size.width/2)/2)-24.0f, size.height/2);
                    [self.left runAction:[CCFadeIn actionWithDuration:1.0f]];
                    [self addChild:self.left];
                }else{
                    [self.left runAction:[CCFadeOut actionWithDuration:1.0f]];
                    tex = [[CCTextureCache sharedTextureCache] addImage:[dictionary objectForKey:@"img_name"]];
                    [self.left setTexture:tex];
                    [self.left setTextureRect:CGRectMake(0, 0, self.left.contentSize.width, self.left.contentSize.height)];
                    [self.left runAction:[CCFadeIn actionWithDuration:1.0f]];
                }
            }
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# MSG"]){
            // ラベルを作成する（後でテクスチャーとして使用する
            NSString *text=[[dictionary objectForKey:@"message"] stringByReplacingOccurrencesOfString: @"#BR#" withString: @"\n"];
            
            if([self.msgLabel.string isEqualToString:@""] || !self.msgLabel.string){
                self.msgWindow          = [[CCSprite alloc] initWithFile:@"msg_window.png"];
                self.msgWindow.position = ccp(size.width/2, size.height/6);
                [self addChild:self.msgWindow];
            
                self.msgLabel = [CCLabelTTF labelWithString:text
                                                 dimensions:CGSizeMake(self.msgWindow.contentSize.width-10.0f,self.msgWindow.contentSize.height)
                                                 hAlignment:UITextAlignmentLeft fontName:@"HiraKakuProN-W6" fontSize:13];            
                [self.msgLabel setAnchorPoint:ccp(0,0)];
                self.msgLabel.position = ccp(10 , size.height/self.msgWindow.position.y-10.0f);
                [self addChild:self.msgLabel];
            }else{
                [self.msgLabel setString:text];
            }
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"EOF;"]){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene] withColor:ccWHITE]];
        }else if([[dictionary objectForKey:@"instruct_name"] isEqualToString:@"# BGM"]){
            //BGM開始
            NSUserDefaults* ud           = [NSUserDefaults standardUserDefaults];
            CGFloat         volume_value = [ud floatForKey:@"volume"];
/*
            if([[dictionary objectForKey:@"action"] isEqualToString:@"LOAD"]){
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[dictionary objectForKey:@"bgm_name"] loop:YES];
            }else if([[dictionary objectForKey:@"action"] isEqualToString:@"PLAY"]){
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[dictionary objectForKey:@"bgm_name"] loop:YES];
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:volume_value];            
            }
*/
        }

        self.msgLabel.zOrder  = 998;
        self.msgWindow.zOrder = 997;
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[super dealloc];
/*
    [self.hyper dealloc];
    [self.back_bg dealloc];
    [self.msgWindow dealloc];
    
    [self.right dealloc];
    [self.center dealloc];
    [self.left dealloc];
    [self.msgLabel dealloc];
    [self.home_btn dealloc];
*/
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGSize size = [[CCDirector sharedDirector] winSize];

    if([self checkSettingsButtonCollision:touch]){
        [[CCDirector sharedDirector] pushScene: [SettingsScene scene]];
    }else{
        NSMutableArray *instruct = [self.engine readScript];
        [self doInstruct:instruct spriteSize:size];
    }
    
    return YES;
}

- (BOOL)checkSettingsButtonCollision:(UITouch*) touch{
    // タップ時の座標とホームボタンの座標をチェックしてtrueの場合　画面遷移
	CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];
    
    CGSize  size = self.home_btn.contentSize;
    CGPoint pos  = self.home_btn.position;
    
    if(location.x > pos.x-(size.width/2) && location.x < pos.x+(size.width/2)&&location.y > pos.y-(size.height/2) && location.y < pos.y+(size.height/2)){
        return YES;
    }
    return NO;
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
@end
