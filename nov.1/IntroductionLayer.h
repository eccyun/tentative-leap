//
//  IntroductionLayer.h
//  nov.1
//
//  Created by 田島僚 on 2014/12/29.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IntroductionLayer : CCLayer {
    
}

@property(nonatomic) NSInteger count;
@property (nonatomic, retain)CCSprite *back_image;
@property (nonatomic) BOOL isTouchEvent;

@end
