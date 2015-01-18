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
        back_btn.tag       = 1;
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
        self.tableView.separatorColor     = [UIColor whiteColor];
        self.tableView.allowsSelection    = NO;
        self.tableView.alpha              = 1.f;
        self.tableView.dataSource         = self;
        self.tableView.delegate           = self;
        [[[CCDirector sharedDirector] view] addSubview:self.tableView];
        
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height) animated:NO];
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
    NSUserDefaults *ud         = [NSUserDefaults standardUserDefaults];
    NSArray        *log_array  = [ud objectForKey:@"log_array"];
    NSDictionary   *dictionary = [log_array objectAtIndex:indexPath.row];

    UILabel *name_label = [[UILabel alloc] init];
    UILabel *text_label = [[UILabel alloc] init];
    name_label.text = [dictionary objectForKey:@"name"];
    text_label.text = [dictionary objectForKey:@"message"];
    name_label.numberOfLines   = 0;
    text_label.numberOfLines   = 0;

    [name_label sizeToFit];
    [text_label sizeToFit];

    return name_label.frame.size.height+text_label.frame.size.height+30.f;
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
    UILabel         *name_label, *text_label;
    
    if (cell == nil){
        cell                       = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        name_label                 = [[UILabel alloc] init];
        name_label.tag             = 1;
        name_label.textColor       = [UIColor whiteColor];
        name_label.backgroundColor = [UIColor clearColor];
        name_label.font            = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
        name_label.numberOfLines   = 0;
        [cell.contentView addSubview:name_label];
        
        text_label                 = [[UILabel alloc] init];
        text_label.tag             = 2;
        text_label.textColor       = [UIColor whiteColor];
        text_label.backgroundColor = [UIColor clearColor];
        text_label.font            = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
        text_label.numberOfLines   = 0;
        [cell.contentView addSubview:text_label];

        name_label.frame = CGRectMake(30.f, 10.f, size.width-60.f, name_label.frame.size.height);
        text_label.frame = CGRectMake(30.f, 20.f, size.width-60.f, text_label.frame.size.height);
    }else{
        name_label = (UILabel *)[cell.contentView viewWithTag:1];
        text_label = (UILabel *)[cell.contentView viewWithTag:2];
    }

    name_label.text = [dictionary objectForKey:@"name"];
    text_label.text = [dictionary objectForKey:@"message"];

    [name_label sizeToFit];
    [text_label sizeToFit];
    
    name_label.frame = CGRectMake(30.f, 10.f, size.width-60.f, name_label.frame.size.height);
    text_label.frame = CGRectMake(30.f, 20.f+name_label.frame.size.height, size.width-60.f, text_label.frame.size.height);

    return cell;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    [super dealloc];
}

-(void) registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    location         = [[CCDirector sharedDirector] convertToGL:location];

    CCSprite       *back_btn = (CCSprite *)[self getChildByTag:1];

    if(location.x > back_btn.position.x-(back_btn.contentSize.width/2)&&
       location.x < back_btn.position.x+(back_btn.contentSize.width/2)&&
       location.y > back_btn.position.y-(back_btn.contentSize.height/2)&&
       location.y < back_btn.position.y+(back_btn.contentSize.height/2)){
        [self.tableView removeFromSuperview];
        [[CCDirector sharedDirector] popScene];
        return YES;
    }
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end