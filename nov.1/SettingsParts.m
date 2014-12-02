//
//  SettingsParts.m
//  nov.1
//
//  Created by eccyun on 2013/02/25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SettingsParts.h"
#import "SimpleAudioEngine.h"

@implementation SettingsParts

static CGFloat minValue = 245.0f;
static CGFloat maxValue = 483.0f;
static CGFloat difValue = 0.0f;

- (id)init{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    minValue = (size.width == 568.0f)?size.width/2-49.0f:size.width/2-24.0f;
    maxValue = (size.width == 568.0f)?size.width/2+189.0f:size.width/2+164.0f;
    difValue = maxValue-minValue;

    if(self= [super init]){
        self.isTouchEnabled = YES;

        NSString*       bar_name = (size.width == 568.0f)?@"settings_bar_5.png":@"settings_bar.png";
        NSUserDefaults* ud       = [NSUserDefaults standardUserDefaults];
        
        // ボリュームバーボタンの位置
        CGFloat         volume_value = [ud floatForKey:@"volume"];
        CGFloat         vol_posX     = difValue*(volume_value/100)+minValue;

        // 効果音バーボタンの位置
        CGFloat         se_value = [ud floatForKey:@"se"];
        CGFloat         se_posX  = difValue*(se_value/100)+minValue;

        // volume
        self.volume_bar           = [[CCSprite alloc] initWithFile:bar_name];
        self.volume_bar.position  = ccp(size.width/2+70.0f, size.height-79.0f);
        
        self.volume_bar_btn = [[CCSprite alloc] initWithFile:@"btn_bar.png"];
        self.volume_bar_btn.position  = ccp(vol_posX, size.height-79.0f);
        
        [self addChild:self.volume_bar];
        [self addChild:self.volume_bar_btn];

        // 効果音
        self.se_bar = [[CCSprite alloc] initWithFile:bar_name];
        self.se_bar.position  = ccp(size.width/2+70.0f, size.height-119.0f);
        
        self.se_bar_btn = [[CCSprite alloc] initWithFile:@"btn_bar.png"];
        self.se_bar_btn.position  = ccp(se_posX, size.height-119.0f);
        
        [self addChild:self.se_bar];
        [self addChild:self.se_bar_btn];

        self.volume_collision = NO;
        self.se_collision     = NO;

        // ホームボタンの追加
        self.home_btn          = [[CCSprite alloc] initWithFile:@"button.png"];
        self.home_btn.position = ccp(size.width-(self.home_btn.contentSize.width/2), size.height-(self.home_btn.contentSize.height/2));
        self.home_btn.zOrder   = 998;
        [self addChild:self.home_btn];

        self.under_home_btn          = [[CCSprite alloc] initWithFile:@"btn_gureh2_home.png"];
        self.under_home_btn.position = ccp(size.width/2-95.0f, size.height/9);
        [self addChild:self.under_home_btn];

        self.under_save_btn          = [[CCSprite alloc] initWithFile:@"btn_gureh2_save.png"];
        self.under_save_btn.position = ccp(size.width/2, size.height/9);
        [self addChild:self.under_save_btn];

        self.under_settings_btn      = [[CCSprite alloc] initWithFile:@"btn_gureh2_settings.png"];
        self.under_settings_btn.position = ccp(size.width/2+95.0f, size.height/9);
        [self addChild:self.under_settings_btn];

    }
    
    return self;
}

- (void) dealloc{
    [self.volume_bar release];
    [self.volume_bar_btn release];
    [self.se_bar release];
    [self.se_bar_btn release];
    
	[super dealloc];
}

-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{ 
    // バーの確認
    if([self checkSpriteCollision:touch targetSprite:self.volume_bar_btn])self.volume_collision = YES;
    if([self checkSpriteCollision:touch targetSprite:self.se_bar_btn])self.se_collision = YES;

    // ホームボタンの判定
    if([self checkSpriteCollision:touch targetSprite:self.home_btn])[[CCDirector sharedDirector] popScene];
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];

    CCSprite *checkerSprite = [[CCSprite alloc] init];

    if(self.volume_collision) checkerSprite = self.volume_bar_btn;
    if(self.se_collision)     checkerSprite = self.se_bar_btn;

    if(minValue > location.x){
        checkerSprite.position = ccp(minValue, checkerSprite.position.y);
    }else if(maxValue < location.x){
        checkerSprite.position = ccp(maxValue, checkerSprite.position.y);
    }else if(minValue < location.x && maxValue > location.x){
        checkerSprite.position = ccp(location.x, checkerSprite.position.y);
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    // 変更を保存する
    if(self.volume_collision){
        self.volume_collision = NO;
        CGFloat value = ((self.volume_bar_btn.position.x-minValue)/difValue)*100;
        [ud setFloat:value/2 forKey:@"volume"];
        [ud synchronize];
    }

    if(self.se_collision){
        self.se_collision = NO;
        CGFloat value = ((self.se_bar_btn.position.x-minValue)/difValue)*100;
        [ud setFloat:value/2 forKey:@"se"];
        [ud synchronize];
    }
}

- (BOOL)checkSpriteCollision:(UITouch*) touch targetSprite: (CCSprite*) sprite{
    // タップ時の座標とホームボタンの座標をチェックしてtrueの場合　画面遷移
	CGPoint location = [touch locationInView:[touch view]];
	location         = [[CCDirector sharedDirector] convertToGL:location];
    
    CGSize  size = sprite.contentSize;
    CGPoint pos  = sprite.position;
    
    
    if(location.x > pos.x-(size.width/2) && location.x < pos.x+(size.width/2)&&location.y > pos.y-(size.height/2) && location.y < pos.y+(size.height/2)){
        return YES;
    }
    return NO;
}

@end
