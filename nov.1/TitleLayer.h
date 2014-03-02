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
}

@property (nonatomic, retain)CCLabelTTF *new_label;
@property (nonatomic, retain)CCLabelTTF *load_label;
@property (nonatomic, retain)CCLabelTTF *opt_label;

@property (nonatomic, retain)CCSprite *back_bg;
@property (nonatomic, retain)CCSprite *title_logo;

@property (nonatomic, retain)CCSprite *start_logo;
@property (nonatomic, retain)CCSprite *restart_logo;
@property (nonatomic, retain)CCSprite *quick_logo;

+(CCScene *) scene;

@end