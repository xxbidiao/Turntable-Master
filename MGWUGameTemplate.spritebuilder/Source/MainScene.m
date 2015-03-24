//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "ChartLoader.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Chart.h"
#import "ChartObject.h"
#import "BGMManager.h"
#import "SingleNote.h"
#import "Stage.h"
#import "Judgment.h"
#import "Results.h"
#import "holdedTouch.h"
#import "noteBuilder.h"

@interface MainScene()

- (void) operation:(int) zoneID touchLocation:(CGPoint) thePoint;

@end

@implementation MainScene
{
    
    CCLabelTTF* _testText;
    CCLabelTTF* _testText2;
    CCNode* _operationZone;
    CCNode* _leftTurntable;
    CCNode* _rightTurntable;
    CCSprite* _judgmentPicture;
    int count;
    double totalTime;
    double totalTime2;
    ChartLoader* theCL;
    Stage* theStage;
    BGMManager* theBGMManager;
    Judgment* theJudgment;
    double minimumValueToTriggerSP;
    
    NSMutableArray* judgmentParameters;
    NSMutableArray* judgmentNames;
    
    double speedFactor;
    
    NSMutableArray* objectOnScreen;
    double latestObjectOnScreen;
   
    NSMutableArray* holdedTouches;
    
    //test
    SingleNote* noteNode;
    
    
}

#pragma mark initialization
-(void) didLoadFromCCB
{
    [_testText setString:@"Loading..."];
    minimumValueToTriggerSP = 20;
    count = 0;
    totalTime = 0;
    totalTime2 = 0;
    speedFactor = 1;
    
    theJudgment = [[Judgment alloc]init];
    judgmentParameters = theJudgment.judgmentParameters;
    judgmentNames = theJudgment.judgmentNames;
    
    
    [self initializeStage];

    theBGMManager = [[BGMManager alloc ]init];
    [theBGMManager initializeBGM:theStage.parameters[@"BGMpath"]];
    [theBGMManager playBGM];
    
    
    objectOnScreen = [[NSMutableArray alloc]init];
    [_testText setString:@"Loaded!"];
    self.userInteractionEnabled = TRUE;
    
    
    [self setMultipleTouchEnabled:YES];
    
}

- (void) initializeStage
{
    theCL = [[ChartLoader alloc]init];
    //[theCL loadChartFromFile:@"test"];
    //[theCL saveChartToFile:@"test.tcf"];
    [theCL loadChartFromFile:@"test.tcf"];
    NSString* path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource: @"test" ofType: @"mp3"];
    theStage = [[Stage alloc] init];
    theStage.theChart = theCL.theChart;
    theStage.parameters[@"BGMpath"] = path;
    holdedTouches = [[NSMutableArray alloc]init];
    
}

- (void)update:(CCTime)delta
{
    
    count += 1;
    totalTime += delta;
    totalTime2 += delta;
    NSString *test1 = [NSString stringWithFormat:@"%.2f %f %lu", count/totalTime, [theBGMManager getPlaybackTime],(unsigned long)[objectOnScreen count]];
    double bgmLocation = [theBGMManager getPlaybackTime];
    [_testText setString:test1];
    if(count >= 100)
    {
        count /= 4;
        totalTime /= 4;
    }
    
    //check if a new note is needed to add onto screen
    double lifetime = 5 / speedFactor;
    
    NSMutableArray* possibleNewObjects = [theStage.theChart getObjectsRangedInTime:bgmLocation second:bgmLocation+lifetime];
    for(int i = 0; i < [possibleNewObjects count]; i++)
    {
        ChartObject* theObject = [possibleNewObjects objectAtIndex:i];
        if(theObject.appeared == false)
        {
            note* theNote = [noteBuilder getNote:theObject];
            [theNote setupSprite];
            [objectOnScreen addObject:theNote];
            theObject.appeared = true;
            [self addChild:theNote.sprite];

        }
    }
    
    //refresh note locations
    //temporarily hard-code it here
    for(int i = 0; i < [objectOnScreen count]; i++)
    {
        note* theNote = [objectOnScreen objectAtIndex:i];
        [theNote refreshSprite:bgmLocation];
    }
    
    
    bool doJudgmentReturnVal= true;

    while (doJudgmentReturnVal) {
        if([objectOnScreen count] == 0)
        {
            doJudgmentReturnVal = false;
            break;
        }
        note* theNote = [objectOnScreen objectAtIndex:0];
        doJudgmentReturnVal = [self doJudgment:bgmLocation withObject:theNote.note onlyTooLate:true];
    }
    
    if([theBGMManager isFinished])
    {
        [self afterStage:0];
    }
    
    
    
}

#pragma mark touches

-(void) touchBegan:(CCTouch*)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_operationZone];
    holdedTouch * thisTouch = [[holdedTouch alloc]init];
    thisTouch.theTouch = touch;
    thisTouch.origX = thisTouch.lastX = touchLocation.x;
    thisTouch.origY = thisTouch.lastY = touchLocation.y;
    thisTouch.effect = (CCParticleSystem *)[CCBReader load:@"Effects/holdEffectIdle"];
    thisTouch.effect.position = touchLocation;
    [self addChild:thisTouch.effect];
    [thisTouch generateHash];
    [holdedTouches addObject:thisTouch];
}

- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    int touchNumber = -1;
    for(int i = 0; i < holdedTouches.count; i++)
    {
        holdedTouch* comparer = (holdedTouch*)holdedTouches[i];
        if(comparer.hashNumber == touch.uiTouch.hash)
        {
            touchNumber = i;
            break;
        }
    }
    
    if(touchNumber == -1)
    {
        NSLog(@"Oh no! touchNumber == -1!");
        return;
    }
    
    holdedTouch* relatedTouch = (holdedTouch*)holdedTouches[touchNumber];
    
    
    
    CGPoint touchLocation = [touch locationInNode:_operationZone];
    relatedTouch.effect.position = touchLocation;
    int moveY = touchLocation.y-relatedTouch.lastY;
    bool isMovingUp = moveY>0?YES:NO;
    movingDirection newStatus = relatedTouch.moveStatus;
    relatedTouch.movingDistance += moveY;
    if(relatedTouch.moveStatus == movingNone)
    {
        if(isMovingUp)
        {
            newStatus = movingUp;
            relatedTouch.isMoveStillValid=true;
            //NSLog(@"Moving up");
        }
        else
        {
            newStatus = movingDown;
            relatedTouch.isMoveStillValid=true;
            //NSLog(@"Moving down");
        }
    }
    else if(relatedTouch.moveStatus == movingUp)
    {
        if(isMovingUp)
        {
            if(relatedTouch.movingDistance>minimumValueToTriggerSP&&relatedTouch.isMoveStillValid)//test
            {
                NSLog(@"Move up enough to trigger action");
                [self triggerOperation:touchLocation withType:0];
                relatedTouch.isMoveStillValid=false;
            }
        }
        else
        {
                //NSLog(@"Reversed...");
                newStatus = movingDown;
                relatedTouch.isMoveStillValid = true;
                relatedTouch.movingDistance = 0;
        }
    }
    else if(relatedTouch.moveStatus == movingDown)
    {
        if(!isMovingUp)
        {
            if(relatedTouch.movingDistance<-minimumValueToTriggerSP&&relatedTouch.isMoveStillValid)//test
            {
                NSLog(@"Move down enough to trigger action");
                [self triggerOperation:touchLocation withType:0];
                relatedTouch.isMoveStillValid=false;
            }
        }
        else
        {
            //NSLog(@"Reversed...");
            newStatus = movingUp;
            relatedTouch.isMoveStillValid = true;
            relatedTouch.movingDistance = 0;
        }
    }
    
    relatedTouch.moveStatus = newStatus;
    relatedTouch.lastX = touchLocation.x;
    relatedTouch.lastY = touchLocation.y;
    //NSLog([NSString stringWithFormat:@"%lu/%lu", (unsigned long)touchNumber,holdedTouches.count]);
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    int touchNumber = -1;
    for(int i = 0; i < holdedTouches.count; i++)
    {
        holdedTouch* comparer = (holdedTouch*)holdedTouches[i];
        if(comparer.hashNumber == touch.uiTouch.hash)
        {
            touchNumber = i;
            break;
        }
    }
    holdedTouch* theTouch = (holdedTouch*)holdedTouches[touchNumber];
    [self removeChild:theTouch.effect];
    [holdedTouches removeObjectAtIndex:touchNumber];
    NSLog(@"TouchEnded");
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    int touchNumber = -1;
    for(int i = 0; i < holdedTouches.count; i++)
    {
        holdedTouch* comparer = (holdedTouch*)holdedTouches[i];
        if(comparer.hashNumber == touch.uiTouch.hash)
        {
            touchNumber = i;
            break;
        }
    }
    holdedTouch* theTouch = (holdedTouch*)holdedTouches[touchNumber];
    [self removeChild:theTouch.effect];
    [holdedTouches removeObjectAtIndex:touchNumber];
}

#pragma mark after-touch funcs

- (void) triggerOperation:(CGPoint) touchLocation withType:(int)hitType
{
    if(hitType == 0)
    {
        CCParticleSystem* theSystem = (CCParticleSystem *)[CCBReader load:@"Effects/actionEffect"];
        theSystem.position = touchLocation;
        theSystem.autoRemoveOnFinish = true;
        [self addChild:theSystem];
        // If inside the operation zone
        if (CGRectContainsPoint([_leftTurntable boundingBox], touchLocation))
        {
            [self operation:0 touchLocation:touchLocation];
        }
        if (CGRectContainsPoint([_rightTurntable boundingBox],touchLocation))
        {
            [self operation:1 touchLocation:touchLocation];
        }
    }

}

- (void) operation:(int) zoneID touchLocation:(CGPoint) thePoint
{
    [self doJudgment:[theBGMManager getPlaybackTime]withObject:[self getProperNotesForJudgment:zoneID withTime:[theBGMManager getPlaybackTime]] onlyTooLate:false];
}

- (ChartObject*) getProperNotesForJudgment:(int)type withTime:(double)time
{
    for(int i = 0; i < [objectOnScreen count]; i++)
    {
        ChartObject* theObj = ((SingleNote*)[objectOnScreen objectAtIndex:i]).note;
        if(theObj.disappeared) continue;
        if(theObj.objectType == type)
        {
            return theObj;
        }
    }
    NSLog(@"Wow,Nil returned");
    return nil;
}

// only timing judgments
- (bool) doJudgment:(double) time withObject:(ChartObject*) obj onlyTooLate:(bool) flag
{
    if(flag)
    {
        double timeForMiss = [[judgmentParameters objectAtIndex:0] doubleValue];
        if(time>obj.startingTime+[obj length]+timeForMiss)
        {
            obj.disappeared = true;
            for(int i = 0; i < [objectOnScreen count]; i++)
            {
                SingleNote* theNote = [objectOnScreen objectAtIndex:i];
                if(theNote.note == obj)
                {
                    [objectOnScreen removeObject:theNote];
                    [self displayJudgment:0];
                    [self refreshScoreList:0];
                    [self removeChild:theNote.sprite];
                    return true;
                }
                
            }
        }
        return false;
    }
    else
    {
        int bestJudgment = -1;
        for(int i = 0; i < [judgmentParameters count]; i++)
        {

            double realTime = fabs(time - obj.startingTime);
            double judgmentTime = [[judgmentParameters objectAtIndex:i] doubleValue];
                        //NSLog([NSString stringWithFormat:@"%f vs %f", realTime,judgmentTime]);
            if(realTime < judgmentTime)
            {
                bestJudgment = i;
            }
        }
        if(bestJudgment >= 0)
        {
            obj.disappeared = true;
            for(int i = 0; i < [objectOnScreen count]; i++)
            {
                SingleNote* theNote = [objectOnScreen objectAtIndex:i];
                if(theNote.note == obj)
                {
                    [objectOnScreen removeObject:theNote];
                    [self removeChild:theNote.sprite];
                    [self displayJudgment:bestJudgment];
                    [self refreshScoreList:bestJudgment];
                    return true;
                }

            }

        }
        return false;
    }
    //return false;
}

- (void) displayJudgment:(int) type
{
    NSString* judgment = [judgmentNames objectAtIndex:type];
    NSLog(judgment);
    [_testText2 setString:judgment];
    
    CCTexture* tex = [CCTexture textureWithFile:[NSString stringWithFormat:@"Resources/judgment/judgment-%@.png",judgment]];
    
    [_judgmentPicture setTexture:tex];
    [_judgmentPicture setTextureRect:CGRectMake(0, 0, tex.contentSize.width, tex.contentSize.height)];
    
    return;
}

// type = -1 means only refresh score.
// type >= 0 means add a judgment and refresh score.
- (void) refreshScoreList:(int)type
{
    if(type >= 0)
    {
        NSString *judgmentName = @"judgment";
        NSString *judgmentName2 = [[NSNumber numberWithInt:type] stringValue];
        NSString *coordinates = [NSString stringWithFormat:@"%@,%@", judgmentName, judgmentName2];

        if ([theStage.scores objectForKey:coordinates] == nil)
        {
            theStage.scores[coordinates] = [NSNumber numberWithInt:1];
        }
        else
        {
            int temp = [((NSNumber*)theStage.scores[coordinates]) intValue];
            temp += 1;
            [theStage.scores setObject:[NSNumber numberWithInt:temp] forKey:coordinates];
        }
    }
}

-(int) getJudgmentCount:(int) judgmentType
{
    NSString *judgmentName = @"judgment";
    NSString *judgmentName2 = [[NSNumber numberWithInt:judgmentType] stringValue];
    NSString *coordinates = [NSString stringWithFormat:@"%@,%@", judgmentName, judgmentName2];
    
    if ([theStage.scores objectForKey:coordinates] == nil)
    {
        return 0;
    }
    else
    {
        return [((NSNumber*)theStage.scores[coordinates]) intValue];
    }
    
}

#pragma mark postMusicFinish

-(void) afterStage:(int)type
{
    NSLog([NSString stringWithFormat:@"Music has finished! %d/%d/%d/%d",[self getJudgmentCount:3],[self getJudgmentCount:2],[self getJudgmentCount:1],[self getJudgmentCount:0]]);
    [theBGMManager clearFinishStatus];
    CCScene *resultScene = (Results*)[CCBReader loadAsScene:@"Results"];
    Results *customObject = [[resultScene children] firstObject];
    
    customObject.theJudgment = theJudgment;
    customObject.theStage = theStage;
    
    [[CCDirector sharedDirector] replaceScene:resultScene];
}





@end

