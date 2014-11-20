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
    {@"script01.txt"},
    {@"script02.txt"},
    {@"script03.txt"},
    {@"script04.txt"},
    {@"script05.txt"},
    {@"script06.txt"},
    {@"script07.txt"},
    {@"script08.txt"},
    {@"script09.txt"},
    {@"script10.txt"},
    {@"script11.txt"},
    {@"script12.txt"},
    {@"script13.txt"},
    {@"script14.txt"},
    {@"script15.txt"},
    {@"script16.txt"},
    {@"script17.txt"},
    {@"script18.txt"},
    {@"script19.txt"},
};

- (id)init{
    self = [super init];
    if(self){
        // メンバの初期化
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"quick_start_flag"] == 0){
            self.structureIndex  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"structure_index"] integerValue];
            self.scriptReadIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"script_index"] integerValue];
        }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"quick_start_flag"] == 1){
            self.structureIndex  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quick_structure_index"] integerValue];
            self.scriptReadIndex = 0;
        }

        self.scriptArray     = [[NSArray alloc] init];
        [self scriptFileReader];
    }
    
    return self;
}

- (NSMutableArray *)readScript{
    NSMutableArray  *ret = [[NSMutableArray alloc] init];
    NSMutableArray  *tmp = [[NSMutableArray alloc] init];
    NSInteger        i = 0;

    NSInteger quick_start = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quick_start_flag"] integerValue];
    
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

        if([data isEqualToString:@"# WHITE;"]||[data isEqualToString:@"# REMOVE;"]||[data isEqualToString:@"# BLACK;"]){
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
        }else if([instruct_name isEqualToString:@"# STILL-IMG"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"img_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"x"];
            [set setValue:[split objectAtIndex:3] forKey:@"direction"];
            [set setValue:[split objectAtIndex:4] forKey:@"tags"];
        }else if([instruct_name isEqualToString:@"# WHITE;"] || [instruct_name isEqualToString:@"# REMOVE;"] || [instruct_name isEqualToString:@"# BLACK;"]){
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:self.scriptReadIndex forKey:@"script_index"];
            [ud synchronize];

            if(quick_start == 0){
                [set setValue:instruct_name forKey:@"instruct_name"];
            }else if(quick_start == 0){
                [set setValue:@"# SKIP;" forKey:@"instruct_name"];
            }
        }
        [ret insertObject:set atIndex:k];
    }

    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:self.scriptReadIndex forKey:@"quick_script_index"];
    [ud synchronize];

    return ret;
}

- (void)scriptFileReader{
    NSString       *path       = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FileList[self.structureIndex].fileName];
    NSString       *scriptText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:self.structureIndex forKey:@"quick_structure_index"];

    // 参照スクリプトの更新
    self.scriptArray = [scriptText componentsSeparatedByString:@"\n"];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"quick_start_flag"] == 0){
        self.structureIndex++;
    }
}

- (NSInteger) getReadScriptIndex{
    return self.scriptReadIndex;
}

@end