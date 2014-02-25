//
//  SceneManager.m
//  NovelGame
//
//  Created by eccyun on 2012/12/24.
//
//

#import "TentativeEngine.h"

@implementation TentativeEngine

/* スクリプトファイルの一覧 */
static struct{
    NSString *fileName;
}FileList[] = {
    {@"script01.txt"}
};

- (id)init{
    self = [super init];
    if(self){
        // メンバの初期化
        self.structureIndex  = 0;
        self.scriptReadIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"script_index"] integerValue];
        self.scriptArray     = [[NSArray alloc] init];
        
        [self scriptFileReader];
    }
    
    return self;
}

- (NSMutableArray *)readScript{
    NSMutableArray  *ret = [[NSMutableArray alloc] init];
    NSMutableArray  *tmp = [[NSMutableArray alloc] init];
    NSInteger        i = 0;

    // 命令を受け取る
    while(true){
        NSString *data = [self.scriptArray objectAtIndex:self.scriptReadIndex];
        // STOPの場合一旦離脱する
        if([data isEqualToString:@"LOADING;"]){
            NSMutableDictionary *set = [[NSMutableDictionary alloc] init];
            [set setValue:@"LOADING;" forKey:@"instruct_name"];
            [ret insertObject:set atIndex:0];
            break;
        }

        if([data isEqualToString:@"EOF;"]){
            NSMutableDictionary *set = [[NSMutableDictionary alloc] init];
            [set setValue:@"EOF;" forKey:@"instruct_name"];
            [ret insertObject:set atIndex:0];
            return ret;
        }

        if([data isEqualToString:@"STOP;"]){
            self.scriptReadIndex++;
            i++;
            break;
        }

        [tmp insertObject:[self.scriptArray objectAtIndex:self.scriptReadIndex] atIndex:i];
        self.scriptReadIndex++;
        i++;

        if([data isEqualToString:@"# WHITE;"]){
            break;
        }
    }

    // 命令をパースする
    for(int k=0; k < [tmp count]; k++){
        NSString *instruct = [tmp objectAtIndex:k];
        NSArray  *split    = [instruct componentsSeparatedByString:@":"];

        NSMutableDictionary *set           = [[NSMutableDictionary alloc] init];
        NSString            *instruct_name = [split objectAtIndex:0];

        if([instruct_name isEqualToString:@"# BG"]){
            [set setValue:instruct_name forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"bg_name"];
        }else if([instruct_name isEqualToString:@"# IMG"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"img_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"position"];
        }else if([instruct_name isEqualToString:@"# MSG"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"message"];
        }else if([instruct_name isEqualToString:@"# BGM"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"bgm_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"action"];
        }else if([instruct_name isEqualToString:@"# WHITE;"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:self.scriptReadIndex forKey:@"script_index"];
            [ud synchronize];
        }

        [ret insertObject:set atIndex:k];
    }

    return ret;
}

- (void)scriptFileReader{
  /******************************************
    method name : scriptFileReader
    args        :
    remarks     : スクリプトファイル取得用関数
   ******************************************/
    
    NSString *path       = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FileList[self.structureIndex].fileName];
    NSString *scriptText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    // 参照スクリプトの更新
    self.scriptArray = [scriptText componentsSeparatedByString:@"\n"];
    self.structureIndex++;
}


@end