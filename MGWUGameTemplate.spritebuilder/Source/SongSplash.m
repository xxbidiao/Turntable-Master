//
//  SongSplash.m
//  TurntableMaster
//
//  Created by LinLee on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SongSplash.h"
#import "MainScene.h"

@implementation SongSplash
{
    NSString* selectedSong;
    CCLabelTTF* _songName;
}

-(void)onEnter
{
    [super onEnter];
        self.userInteractionEnabled = TRUE;
    [_songName setString:_chartName];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    MainScene *customObject = [[gameplayScene children] firstObject];
    customObject.chartName = _chartName;
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
