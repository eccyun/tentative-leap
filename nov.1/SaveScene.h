//
//  SaveScene.h
//  nov.1
//
//  Created by 田島僚 on 2014/03/16.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SaveScene : CCLayer {
    
}

@property (nonatomic, retain) NSString *function_flag; // 機能フラグ　セーブなのかロードなのか


// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;

@end