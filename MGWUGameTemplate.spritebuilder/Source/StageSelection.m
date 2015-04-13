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
{
    CCScrollView* _songSelectionContainer;
}

- (void) onEnter
{
    [super onEnter];
    NSLog(@"Enter song selection");
    CCNode* song = [CCBReader load:@"StageSelectionMenuItem" owner:self];
    CCNode* song2 = [CCBReader load:@"StageSelectionMenuItem" owner:self];
    CCNode* song3 = [CCBReader load:@"StageSelectionMenuItem" owner:self];
    CCLayoutBox* box = (CCLayoutBox*)[_songSelectionContainer getChildByName:@"menu" recursively:true];
    [box addChild: song];
    [box addChild: song2];
    [box addChild: song3];
    [box layout];
    CCNode* boxNode = [_songSelectionContainer getChildByName:@"menuNode" recursively:true];
    boxNode.contentSize = box.contentSize;
    boxNode.contentSizeType = box.contentSizeType;
}

-(void)playPressed
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    MainScene *customObject = [[gameplayScene children] firstObject];
    customObject.chartName = @"test.tcf";
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
