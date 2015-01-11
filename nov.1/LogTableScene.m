//
//  LogTableScene.m
//  nov.1
//
//  Created by 田島僚 on 2015/01/09.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "LogTableScene.h"


@implementation LogTableScene
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
    CCScene *scene = [CCScene node];
    
    LogTableScene *layer = [LogTableScene node];
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
-(id) init{
    CGSize size = [[CCDirector sharedDirector] winSize];

    if((self=[super init])){
        self.isTouchEnabled = YES;

        CCSprite *background = [[CCSprite alloc] initWithFile:@"menu_bg.png"];
        background.position  = ccp(size.width/2, size.height/2);
        [self addChild:background];

        CCSprite *back_btn = [[CCSprite alloc] initWithFile:@"save_back.png"];
        back_btn.position  = ccp(size.width-((back_btn.contentSize.width/2.f)+20.f), size.height/2 - 142.f);
        [self addChild:back_btn];

        CCSprite *caption = [[CCSprite alloc] initWithFile:@"log-caption.png"];
        caption.position  = ccp((caption.contentSize.width/2.f)+20.f, size.height/2 + 139.f);
        [self addChild:caption];

        CGRect frame;

        frame = CGRectMake(0.f, 40.f, size.width, size.height-80.f);

        self.tableView                    = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.layer.cornerRadius = 5;
        self.tableView.layer.borderColor  = [UIColor clearColor].CGColor;
        self.tableView.layer.borderWidth  = 0;
        self.tableView.backgroundColor    = [UIColor clearColor];
        self.tableView.separatorColor     = [UIColor clearColor];
        self.tableView.allowsSelection    = NO;
        self.tableView.alpha              = 1.f;
        self.tableView.dataSource         = self;
        self.tableView.delegate           = self;
        [[[CCDirector sharedDirector] view] addSubview:self.tableView];
    }
    
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *log_array = [ud objectForKey:@"log_array"];

    return [log_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *ud         = [NSUserDefaults standardUserDefaults];
    NSArray        *log_array  = [ud objectForKey:@"log_array"];
    NSDictionary   *dictionary = [log_array objectAtIndex:indexPath.row];
    
    CGSize size = [[CCDirector sharedDirector] winSize];

    static NSString *CellIdentifier = @"CellCustom";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label;
    
    if (cell == nil){
        cell            = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        label           = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 10.f, size.width-60.f, 50.f)];
        label.tag       = 1;
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
    }else{
        label = (UILabel *)[cell.contentView viewWithTag:1];
    }

    label.font            = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label.text            = [dictionary objectForKey:@"message"];

//label.backgroundColor = [UIColor redColor];
    return cell;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    [super dealloc];
}

#pragma mark GameKit delegate
-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end
