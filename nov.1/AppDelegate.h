//
//  AppDelegate.h
//  nov.1
//
//  Created by eccyun on 2012/12/09.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>{
	UIWindow               *window_;
	UINavigationController *navController_;
	CCDirectorIOS	       *director_;// weak ref
}

@property (nonatomic, retain) UIWindow               *window;
@property (readonly)          UINavigationController *navController;
@property (readonly)          CCDirectorIOS          *director;
@property (nonatomic, retain) NSString               *sound_name;

@property (nonatomic, retain) NSDictionary *bgmMap;
@property (nonatomic, retain) NSDictionary *effectsMap;

- (void) refreshPlayer;

@end