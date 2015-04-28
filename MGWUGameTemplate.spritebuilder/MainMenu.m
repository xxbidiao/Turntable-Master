//
//  MainMenu.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainMenu.h"
#import "CCTransition.h"

@implementation MainMenu

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
    [self playPressed];
}

-(void)playPressed
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"StageSelection"];
    NSLog(@"Hello world from Turntable Master!");
    //CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
