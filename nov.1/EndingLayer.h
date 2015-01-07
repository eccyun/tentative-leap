//
//  EndingLayer.h
//  nov.1
//
//  Created by 田島僚 on 2014/12/31.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"

@interface EndingLayer : CCLayer {
    
}

@property(nonatomic) NSInteger count;
@property (nonatomic, retain)CCSprite *back_image;
@property (nonatomic) BOOL isTouchEvent;
@property(nonatomic,retain)  AppController*   delegate;

@end
