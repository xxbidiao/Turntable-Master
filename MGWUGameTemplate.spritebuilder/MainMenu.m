//
//  MainMenu.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainMenu.h"
#import "CCTransition.h"
#import "BGMManager.h"

@implementation MainMenu
{
    BGMManager* theBGMManager;
}

-(void) onEnter
{
    [super onEnter];
    theBGMManager = [[BGMManager alloc]init];
    [theBGMManager stopBGM];
    NSString* path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource: @"title" ofType:@"mp3"];
    [theBGMManager initializeBGM:path];
    [theBGMManager setLoop:true];
    [theBGMManager playBGM];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
    [self playPressed];
}

-(void)playPressed
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"StageSelection"];
    NSLog(@"Hello world from Turntable Master!");
    //CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [theBGMManager stopBGM];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
