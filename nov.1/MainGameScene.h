//
//  HelloWorldLayer.h
//  nov.1
//
//  Created by eccyun on 2012/12/09.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "TentativeEngine.h"

// HelloWorldLayer
@interface MainGameScene : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>{
    CCSprite *_hyper;
    CCSprite *_back_bg;
    CCSprite *_msgWindow;

    CCSprite *_right;
    CCSprite *_center;
    CCSprite *_left;
    
    NSInteger _counter;
    CCLabelTTF *_msgLabel;

    TentativeEngine *_engine;

    CCSprite *_home_btn;
}

@property(nonatomic, retain) CCSprite        *home_btn;
@property(nonatomic,retain)  TentativeEngine *engine;
@property(nonatomic,retain)  CCSprite        *back_bg;
@property(nonatomic,retain)  CCLabelTTF      *msgLabel;
@property(nonatomic)         NSInteger        counter;
@property(nonatomic, retain) CCSprite        *center;
@property(nonatomic, retain) CCSprite        *left;
@property(nonatomic, retain) CCSprite        *right;
@property(nonatomic, retain) CCSprite        *msgWindow;
@property(nonatomic, retain) CCSprite        *hyper;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
