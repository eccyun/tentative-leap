//
//  TitleLayer.h
//  nov.1
//
//  Created by eccyun on 2013/02/14.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TitleLayer : CCLayer {
    CCSprite *_back_bg;
    CCSprite *_home_btn;

    CCLabelTTF *_new_label;
    CCLabelTTF *_load_label;
    CCLabelTTF *_opt_label;
}

@property (nonatomic, retain)CCLabelTTF *new_label;
@property (nonatomic, retain)CCLabelTTF *load_label;
@property (nonatomic, retain)CCLabelTTF *opt_label;

@property (nonatomic, retain)CCSprite *back_bg;
@property (nonatomic, retain)CCSprite *home_btn;

+(CCScene *) scene;

@end
