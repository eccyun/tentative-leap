//
//  SceneManager.h
//  NovelGame
//
//  Created by eccyun on 2012/12/24.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TentativeEngine : NSObject{
    NSInteger  _scriptReadIndex, _structureIndex;
    NSArray   *_scriptArray;
}

@property (nonatomic, retain) NSArray   *scriptArray;
@property (nonatomic, assign) NSInteger  scriptReadIndex, structureIndex;


- (NSMutableArray *)readScript;
+ (NSArray *)scriptFileReader;

@end
