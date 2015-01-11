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
    {@"script18.txt"}
};

- (id)init{
    self = [super init];
    if(self){
        // メンバの初期化
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

        if([[NSUserDefaults standardUserDefaults] integerForKey:@"quick_start_flag"] == 0){
            self.structureIndex  = [[ud objectForKey:@"structure_index"] integerValue];
            self.scriptReadIndex = [[ud objectForKey:@"script_index"] integerValue];
        }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"quick_start_flag"] == 1){
            self.structureIndex  = [[ud objectForKey:@"quick_structure_index"] integerValue];
            self.scriptReadIndex = [[ud objectForKey:@"quick_script_index"] integerValue];

            [ud setInteger:self.structureIndex forKey:@"structure_index"];
            [ud synchronize];
        }

        self.scriptArray = [[NSArray alloc] init];
        [self scriptFileReader];
    }
    
    return self;
}

- (NSMutableArray *)readScript{
    NSUserDefaults  *ud  = [NSUserDefaults standardUserDefaults];
    NSMutableArray  *ret = [[NSMutableArray alloc] init];
    NSMutableArray  *tmp = [[NSMutableArray alloc] init];
    NSInteger        i = 0;

    // 命令を受け取る
    while(true){
        NSString *data = [self.scriptArray objectAtIndex:self.scriptReadIndex];
        // STOPの場合一旦離脱する
        if([data isEqualToString:@"ENDING;"]){
            NSMutableDictionary *set = [[NSMutableDictionary alloc] init];
            [set setValue:@"ENDING;" forKey:@"instruct_name"];
            [ret insertObject:set atIndex:0];
            return ret;
        }

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

        // 文字データだった時にセーブ用にインデックスを保存
        NSArray  *split         = [data componentsSeparatedByString:@":"];
        NSString *instruct_name = [split objectAtIndex:0];
        if([instruct_name isEqualToString:@"# MSG"]){
            [ud setInteger:self.scriptReadIndex-1 forKey:@"quick_script_index"];
        }
    }

    ret = [self setInstruct:tmp insertInstructArray:ret];
    [ud synchronize];

    return ret;
}

- (NSMutableArray *)setInstruct : (NSMutableArray *)tmp insertInstructArray : (NSMutableArray *)ret{
    NSUserDefaults      *ud          = [NSUserDefaults standardUserDefaults];
    NSDictionary        *dict        = [ud objectForKey:@"quick_instruct_datas"];
    NSMutableDictionary *saves       = [[NSMutableDictionary alloc] initWithDictionary:dict];

    // 命令をパースする
    for(int k=0; k < [tmp count]; k++){
        NSString *instruct = [tmp objectAtIndex:k];
        NSArray  *split    = [instruct componentsSeparatedByString:@":"];

        NSMutableDictionary *set           = [[NSMutableDictionary alloc] init];
        NSString            *instruct_name = [split objectAtIndex:0];

        if([instruct_name isEqualToString:@"# BG"]){
            [set setValue:instruct_name forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"bg_name"];
            
            [saves setObject:instruct forKey:@"BG"];
        }else if([instruct_name isEqualToString:@"# IMG"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"img_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"position"];
            
            [saves setObject:instruct forKey:[NSString stringWithFormat: @"IMG-%@", [split objectAtIndex:2]]];
        }else if([instruct_name isEqualToString:@"# MSG"]){
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"message"];

            [dictionary setValue:[split objectAtIndex:1] forKey:@"message"];

            if([split count]==3){
                [set setValue:[split objectAtIndex:2] forKey:@"name"];
                [dictionary setValue:[split objectAtIndex:2] forKey:@"name"];
            }else{
                [dictionary setValue:@"ーーー" forKey:@"name"];
            }
            
            NSDictionary   *tmp    = [[NSDictionary alloc] initWithDictionary:dictionary];
            NSMutableArray *_array = [[NSMutableArray alloc] initWithArray: [ud objectForKey:@"log_array"]];
            [_array addObject:tmp];

            [ud setObject:[[NSArray alloc] initWithArray:_array] forKey:@"log_array"];
            [ud synchronize];
        }else if([instruct_name isEqualToString:@"# BGM"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"bgm_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"action"];
            
            if([[split objectAtIndex:2] isEqualToString:@"PLAY"]){
                [saves setObject:instruct forKey:@"BGM-PLAY"];
            }else if([[split objectAtIndex:2] isEqualToString:@"STOP"]){
                [saves setObject:@"" forKey:@"BGM-PLAY"];
            }
        }else if([instruct_name isEqualToString:@"# STILL-IMG"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"img_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"x"];
            [set setValue:[split objectAtIndex:3] forKey:@"direction"];
            [set setValue:[split objectAtIndex:4] forKey:@"tags"];

            [saves setObject:instruct forKey:[NSString stringWithFormat:@"STILL-IMG-%d", [[split objectAtIndex:4] integerValue]]];
        }else if([instruct_name isEqualToString:@"# REMOVE-IMG"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"position"];

            [saves setObject:@"" forKey:[NSString stringWithFormat: @"IMG-%@", [split objectAtIndex:1]]];
        }else if([instruct_name isEqualToString:@"# WHITE;"] || [instruct_name isEqualToString:@"# REMOVE;"] || [instruct_name isEqualToString:@"# BLACK;"]){
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:self.scriptReadIndex forKey:@"script_index"];
            [ud synchronize];

            [set setValue:instruct_name forKey:@"instruct_name"];
            
            NSDictionary *datas = @{@"BGM-PLAY":[[ud objectForKey:@"quick_instruct_datas"] objectForKey:@"BGM-PLAY"]};
            saves = [[NSMutableDictionary alloc] initWithDictionary:datas];
        }else if([instruct_name isEqualToString:@"# EFFECT"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"effect_name"];
            [set setValue:[split objectAtIndex:2] forKey:@"action"];

            if([[split objectAtIndex:2] isEqualToString:@"PLAY"]){
                [saves setObject:instruct forKey:@"EFFECT-PLAY"];
            }else if([[split objectAtIndex:2] isEqualToString:@"STOP"]){
                [saves setObject:@"" forKey:@"EFFECT-PLAY"];
            }            
        }else if([instruct_name isEqualToString:@"# WAIT"]){
            [set setValue:instruct_name           forKey:@"instruct_name"];
            [set setValue:[split objectAtIndex:1] forKey:@"times"];
        }
        
        [ret insertObject:set atIndex:k];
    }
    
    [ud setObject:[[NSDictionary alloc] initWithDictionary:saves] forKey:@"quick_instruct_datas"];
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
}

- (NSInteger) getReadScriptIndex{
    return self.scriptReadIndex;
}

@end