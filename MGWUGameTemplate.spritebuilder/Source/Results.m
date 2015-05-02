//
//  Results.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Results.h"
#import "BGMManager.h"

@implementation Results
{
    CCLabelTTF* _testText;
    CCLabelTTF* _judgmentText;
    CCSprite* _spriteClear;
    BGMManager* theBGMManager;
}

-(int) getJudgmentCount:(int) judgmentType
{
    NSString *judgmentName = @"judgment";
    NSString *judgmentName2 = [[NSNumber numberWithInt:judgmentType] stringValue];
    NSString *coordinates = [NSString stringWithFormat:@"%@,%@", judgmentName, judgmentName2];
    

    
    if ([_theStage.scores objectForKey:coordinates] == nil)
    {
        return 0;
    }
    else
    {
        return [((NSNumber*)_theStage.scores[coordinates]) intValue];
    }
    
}


-(void) didLoadFromCCB
{

}

-(void) onEnter
{
    [super onEnter];
    
    theBGMManager = [[BGMManager alloc]init];
    [theBGMManager stopBGM];
    NSString* path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource: @"result" ofType:@"mp3"];
    [theBGMManager initializeBGM:path];
    [theBGMManager setLoop:true];
    [theBGMManager playBGM];
    
    //[_testText setString:([NSString stringWithFormat:@"Music has finished! %d/%d/%d/%d",[self getJudgmentCount:3],[self getJudgmentCount:2],[self getJudgmentCount:1],[self getJudgmentCount:0]])];
    int score = [self getJudgmentCount:3]*2+[self getJudgmentCount:2];
    int maxscore =[self getJudgmentCount:3]*2+[self getJudgmentCount:2]*2+[self getJudgmentCount:1]*2+[self getJudgmentCount:0]*2;
    float rate = (float)score/(float)maxscore;
    [_testText setString:[NSString stringWithFormat:@"%d",score]];
    //NSLog(@"%d vs %d = %f",score,maxscore,rate);
    //temporarily hard code it here
    if(rate>0.9) [_judgmentText setString:@"X"];
    else if(rate>0.75) [_judgmentText setString:@"S"];
    else if(rate>0.6) [_judgmentText setString:@"A"];
    else if(rate>0.45) [_judgmentText setString:@"B"];
    else if(rate>0.3) [_judgmentText setString:@"C"];
    else [_judgmentText setString:@"D"];
    bool isStageCleared = false;
    if((float)_theStage.hitpoint < (float)_theStage.hitpointMax * 0.3)
    {
        isStageCleared = true;
    }
    if(!isStageCleared) _spriteClear.visible = false;
}

-(void) backButtonPressed
{
    [theBGMManager stopBGM];
    CCScene *mainMenuScene = [CCBReader loadAsScene:@"MainMenu"];
    [[CCDirector sharedDirector] replaceScene:mainMenuScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
