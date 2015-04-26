//
//  Results.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Results.h"

@implementation Results
{
    CCLabelTTF* _testText;
    CCLabelTTF* _judgmentText;
    CCSprite* _spriteClear;
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
    //[_testText setString:([NSString stringWithFormat:@"Music has finished! %d/%d/%d/%d",[self getJudgmentCount:3],[self getJudgmentCount:2],[self getJudgmentCount:1],[self getJudgmentCount:0]])];
    int score = [self getJudgmentCount:3]*2+[self getJudgmentCount:2];
    int maxscore =[self getJudgmentCount:3]*2+[self getJudgmentCount:2]*2+[self getJudgmentCount:1]*2+[self getJudgmentCount:0]*2;
    float rate = (float)score/(float)maxscore;
    [_testText setString:[NSString stringWithFormat:@"%d",score]];
    //NSLog(@"%d vs %d = %f",score,maxscore,rate);
    //temporarily hard code it here
    if(rate>0.8) [_judgmentText setString:@"A"];
    else if(rate>0.6) [_judgmentText setString:@"B"];
    else if(rate>0.4) [_judgmentText setString:@"C"];
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
    CCScene *mainMenuScene = [CCBReader loadAsScene:@"MainMenu"];
    [[CCDirector sharedDirector] replaceScene:mainMenuScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
