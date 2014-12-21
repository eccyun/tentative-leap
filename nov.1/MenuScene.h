//
//  MenuLayer.h
//  nov.1
//
//  Created by 田島僚 on 2014/12/21.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuScene : CCLayer <UIAlertViewDelegate> {

}

@property (nonatomic, retain) UIImage   *screen_capture;
@property (nonatomic, retain) NSString  *save_text;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;

@end