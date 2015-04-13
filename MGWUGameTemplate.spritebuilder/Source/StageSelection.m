//
//  StageSelection.m
//  MGWUGameTemplate
//
//  Created by LinLee on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StageSelection.h"
#import "MainScene.h"
#import "StageSelectionMenuItem.h"

@implementation StageSelection
{
    CCScrollView* _songSelectionContainer;
}

- (void) selectSong:(int) myID
{
    NSLog(@"%d",myID);
}

- (void) onEnter
{
    [super onEnter];
    NSLog(@"Enter song selection");
    StageSelectionMenuItem* song = (StageSelectionMenuItem*)[CCBReader load:@"StageSelectionMenuItem" owner:self];
    [song setCaption:@"test1" withMeta:@"Difficulty:10"];
    song.chartFile = @"test.tcf";
    song.owner = self;
    CCLayoutBox* box = (CCLayoutBox*)[_songSelectionContainer getChildByName:@"menu" recursively:true];
    [box addChild: song];
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
