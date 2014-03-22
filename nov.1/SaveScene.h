//
//  SaveScene.h
//  nov.1
//
//  Created by 田島僚 on 2014/03/16.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SaveScene : CCLayer <UIAlertViewDelegate>{
    
}

@property (nonatomic, retain) NSString  *function_flag; // 機能フラグ　セーブなのかロードなのか
@property (nonatomic, retain) UIImage   *screen_capture;
@property (nonatomic)         NSInteger  save_key;
@property (nonatomic)         BOOL       isLoad;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;

@end