//
//  LoadScene.h
//  nov.1
//
//  Created by 田島僚 on 2014/02/25.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"

@interface LoadScene : CCLayer {
    
}

@property(nonatomic)         BOOL           isReturnTitle;
@property(nonatomic, retain) AppController *delegate;

+(CCScene *) scene;

@end