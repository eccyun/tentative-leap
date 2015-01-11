//
//  LogTableScene.h
//  nov.1
//
//  Created by 田島僚 on 2015/01/09.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LogTableScene : CCLayer <UITableViewDataSource, UITableViewDelegate>{
    
}

@property(nonatomic , retain) UITableView *tableView;

+(CCScene *) scene;

@end