//
//  StageSelection.m
//  MGWUGameTemplate
//
//  Created by LinLee on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StageSelection.h"
#import "MainScene.h"

@implementation StageSelection

-(void)playPressed
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    MainScene *customObject = [[gameplayScene children] firstObject];
    customObject.chartName = @"test.tcf";
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
