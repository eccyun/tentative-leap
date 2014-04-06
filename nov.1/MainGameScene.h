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
}

@property(nonatomic)         BOOL             isCheck, isUp;
@property(nonatomic,retain)  TentativeEngine *engine;
@property(nonatomic,retain)  CCSprite        *back_bg;
@property(nonatomic,retain)  CCLabelTTF      *msgLabel;
@property(nonatomic)         NSInteger        counter,line_count;
@property(nonatomic, retain) CCSprite        *center;
@property(nonatomic, retain) CCSprite        *left;
@property(nonatomic, retain) CCSprite        *right;
@property(nonatomic, retain) CCSprite        *msgWindow;
@property(nonatomic, retain) CCSprite        *hyper, *load_image, *save_image;
@property(nonatomic, retain) NSString        *message_text;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
