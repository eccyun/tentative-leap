//
//  SettingsParts.h
//  nov.1
//
//  Created by eccyun on 2013/02/25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsParts : CCLayer {
    BOOL      _volume_collision;
    BOOL      _se_collision;

    CCSprite* _volume_bar;
    CCSprite* _volume_bar_btn;
    
    CCSprite* _se_bar;
    CCSprite* _se_bar_btn;

    CCSprite *_home_btn;

    CCSprite *_under_home_btn;
    CCSprite *_under_save_btn;
    CCSprite *_under_settings_btn;
}

@property (nonatomic, retain) CCSprite*  home_btn, *under_home_btn, *under_save_btn, *under_settings_btn;
@property (nonatomic, retain) CCSprite*  volume_bar;
@property (nonatomic, retain) CCSprite*  volume_bar_btn;
@property (nonatomic, retain) CCSprite*  se_bar;
@property (nonatomic, retain) CCSprite*  se_bar_btn;

@property (nonatomic, assign) BOOL       volume_collision;
@property (nonatomic, assign) BOOL       se_collision;

@end
