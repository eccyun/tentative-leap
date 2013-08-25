//
//  SettingsScene.h
//  nov.1
//
//  Created by eccyun on 2013/02/21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SettingsParts.h"

@interface SettingsScene : CCLayer {
    CCSprite *_bg_image;
}


@property (nonatomic, retain) CCSprite  *bg_image;

+(CCScene *) scene;

@end
