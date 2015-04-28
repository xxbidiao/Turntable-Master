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
#import "Constant.h"

@interface MainScene()

//- (void) operation:(int) zoneID touchLocation:(CGPoint) thePoint;


@end

@implementation MainScene
{
    CCLabelTTF* _testText;
    CCLabelTTF* _testText2;
    CCNode* _operationZone;
    CCNode* _leftTurntable;
    CCNode* _rightTurntable;
    CCSprite* _judgmentPicture;
    
    CCClippingNode* rightMask;
    CCClippingNode* leftMask;
    
    //in-scene variables
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
    
    float currentYLocationL,currentYLocationR;
    bool longNoteEnabledL,longNoteEnabledR;
    float longNoteTimeL,longNoteTimeR;
    
    //test
    SingleNote* noteNode;
    
    //stage clear or fail metric
    //float hitpoint;
    //float hitpointMax;
    
    
}

#pragma mark initialization
-(void) didLoadFromCCB
{
    [_testText setString:@"Loading..."];
    
    //setup stentils
    double stentilWidthL = _leftTurntable.contentSize.width;
    
    //temporarily hardcode it here
    //stentilWidthL -= 0.05;
    
    double stentilHeightL = _leftTurntable.contentSize.height;
    CCNodeColor *scissorRectLeft = [CCNodeColor nodeWithColor:[CCColor clearColor] width:stentilWidthL height:stentilHeightL];
    [scissorRectLeft setContentSizeType:CCSizeTypeNormalized];
    [self addChild: scissorRectLeft];
    [scissorRectLeft setAnchorPoint:[_leftTurntable anchorPoint]];
    [scissorRectLeft setPositionType:CCPositionTypeNormalized];
    [scissorRectLeft setPosition:[_leftTurntable position]];

    leftMask = [CCClippingNode clippingNodeWithStencil:scissorRectLeft];
    [leftMask setContentSize:self.contentSize];
    [leftMask setContentSizeType:CCSizeTypeNormalized];
    //[leftMask setPosition:[_leftTurntable position]];
    [leftMask setPositionType:CCPositionTypeNormalized];
    [leftMask setAlphaThreshold:0.0];
    [leftMask setInverted:NO];
    [self addChild:leftMask];
    
    double stentilWidthR = _rightTurntable.contentSize.width;
    
    //temporarily hardcode it here
    //stentilWidthL -= 0.05;
    
    double stentilHeightR = _rightTurntable.contentSize.height;
    CCNodeColor *scissorRectRight = [CCNodeColor nodeWithColor:[CCColor clearColor] width:stentilWidthR height:stentilHeightR];
    [scissorRectRight setContentSizeType:CCSizeTypeNormalized];
    [self addChild: scissorRectRight];
    [scissorRectRight setAnchorPoint:[_rightTurntable anchorPoint]];
    [scissorRectRight setPositionType:CCPositionTypeNormalized];
    
    //another temporarily hard code
    CGPoint positionR = [_rightTurntable position];
    //positionR.x += 0.05;
    [scissorRectRight setPosition:positionR];
    
    
    //temporarily hard code it here
    
    rightMask = [CCClippingNode clippingNodeWithStencil:scissorRectRight];
    [rightMask setContentSize:self.contentSize];
    [rightMask setContentSizeType:CCSizeTypeNormalized];
    //[rightMask setPosition:[_rightTurntable position]];
    [rightMask setPositionType:CCPositionTypeNormalized];
    [rightMask setAlphaThreshold:0.0];
    [rightMask setInverted:NO];
    [self addChild:rightMask];
    minimumValueToTriggerSP = 20;
    count = 0;
    totalTime = 0;
    totalTime2 = 0;
    speedFactor = 0.1;
    currentYLocationR = 1;
    currentYLocationL = 1;
    longNoteTimeL = 0;
    longNoteTimeR = 0;
    
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
    [theCL loadChartFromFile:@"test"];
    [theCL saveChartToFile:@"test.tcf"];
    [theCL loadChartFromFile:@"test.tcf"];
    NSString* path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource: @"test" ofType: @"mp3"];
    theStage = [[Stage alloc] init];
    theStage.theChart = theCL.theChart;
    theStage.parameters[@"BGMpath"] = path;
    holdedTouches = [[NSMutableArray alloc]init];
    theStage.hitpointMax = theJudgment.judgmentMaxHPFactor * [theStage.theChart.objects count];
    theStage.hitpoint = theStage.hitpointMax;
    
}

- (void)update:(CCTime)delta
{
    
    count += 1;
    totalTime += delta;
    totalTime2 += delta;
    NSString *test1 = [NSString stringWithFormat:@"%.2f %f %lu", count/totalTime, [theBGMManager getPlaybackTime],(unsigned long)[objectOnScreen count]];
    double bgmLocation = [theBGMManager getPlaybackTime];
    NSString *hitpointTest = [NSString stringWithFormat:@"HP:%f/%f",theStage.hitpoint,theStage.hitpointMax];
    [_testText setString:hitpointTest];
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
            if([theNote.note getTrackType] == trackLeft)
            {
                [leftMask addChild:theNote.sprite];
            }
            else
            {
                [rightMask addChild:theNote.sprite];
            }
        }
    }
    
    //refresh note locations
    for(int i = 0; i < [objectOnScreen count]; i++)
    {
        note* theNote = [objectOnScreen objectAtIndex:i];
        [theNote refreshSprite:bgmLocation];
    }
    
    
    
    bool doJudgmentReturnVal= true;

    /*
    while (doJudgmentReturnVal) {
        if([objectOnScreen count] == 0)
        {
            doJudgmentReturnVal = false;
            break;
        }
        note* theNote = [objectOnScreen objectAtIndex:0];
        doJudgmentReturnVal = [self doJudgment:bgmLocation withObject:theNote.note onlyTooLate:true];
    }
     */
    
    
    
    for(int i = (int)[objectOnScreen count]-1; i >= 0; i--)
    {
        
        note* theNote = [objectOnScreen objectAtIndex:i];
        doJudgmentReturnVal = [self doJudgment:bgmLocation withObject:theNote.note onlyTooLate:true];
    }
    
    lastLongNoteJudgmentTime = bgmLocation;
    
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
    //long note part
    [self triggerOperation:touchLocation withType:1];
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
    
    //long note part
    [self triggerOperation:touchLocation withType:1];
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
            [self operation:noteSingleNote zone:0 touchLocation:touchLocation];
        }
        if (CGRectContainsPoint([_rightTurntable boundingBox],touchLocation))
        {
            [self operation:noteSingleNote zone:1 touchLocation:touchLocation];
        }
    }
    if(hitType == 1)
    {
        // If inside the operation zone
        CGSize s = [CCDirector sharedDirector].viewSize;
        float scaleW = s.width;
        float scaleH = s.height;
        float touchYLocationNormalized = touchLocation.y/scaleH;
        float touchYLocationRelative = (touchYLocationNormalized-Constant.kPositionYStartingAt)/Constant.kPositionYDelta;
        if (CGRectContainsPoint([_leftTurntable boundingBox], touchLocation))
        {
            currentYLocationL = touchYLocationRelative;
        }
        if (CGRectContainsPoint([_rightTurntable boundingBox],touchLocation))
        {
            currentYLocationR = touchYLocationRelative;
        }
    }

}

- (void) operation:(int) type zone:(int) zoneID touchLocation:(CGPoint) thePoint
{
    [self doJudgment:[theBGMManager getPlaybackTime]withObject:[self getProperNotesForJudgment:type track:zoneID withTime:[theBGMManager getPlaybackTime]] onlyTooLate:false];
}

- (ChartObject*) getProperNotesForJudgment:(int)type track:(int) subType withTime:(double)time
{
    for(int i = 0; i < [objectOnScreen count]; i++)
    {
        ChartObject* theObj = ((note*)[objectOnScreen objectAtIndex:i]).note;
        if(theObj.disappeared) continue;
        if(theObj.objectSubType == subType && theObj.objectType == type)
        {
            return theObj;
        }
    }
    NSLog(@"Wow,Nil returned");
    return nil;
}

- (void) removeNoteSprite:(note*) obj
{
    if([obj.note getTrackType] == trackLeft)
    {
        [leftMask removeChild:obj.sprite];
    }
    else
    {
        [rightMask removeChild:obj.sprite];
    }
}

float lastLongNoteJudgmentTime;

- (bool) doJudgment:(double) time withObject:(ChartObject*) obj onlyTooLate:(bool) flag
{
    if(flag)
    {
        double timeForMiss = [[judgmentParameters objectAtIndex:0] doubleValue];
        if(obj.objectType == noteLongNote)
        {
            timeForMiss = 0;
            if(obj.getTrackType == trackLeft)
            {
                bool isOnLongNoteL = false;
                if(fabsf([obj getCurrentLocation:time] - currentYLocationL) < [Constant kLongNoteThreshold])
                {
                    isOnLongNoteL = true;
                }
                if(time>=obj.startingTime && isOnLongNoteL)
                {
                    float timeEnd = time;
                    if(timeEnd>obj.startingTime+[obj length])
                    {
                        timeEnd = obj.startingTime + [obj length];
                    }
                    float timeStart = lastLongNoteJudgmentTime;
                    if(timeStart<obj.startingTime)
                    {
                        timeStart = obj.startingTime;
                    }
                    longNoteTimeL += timeEnd-timeStart;

                }
            }
            NSLog(@"LongNoteTimeL = %f",longNoteTimeL);
            
            if(obj.getTrackType == trackRight)
            {
                bool isOnLongNoteR = false;
                if(fabsf([obj getCurrentLocation:time] - currentYLocationR) < [Constant kLongNoteThreshold])
                {
                    isOnLongNoteR = true;
                }
                if(time>=obj.startingTime && isOnLongNoteR)
                {
                    float timeEnd = time;
                    if(timeEnd>obj.startingTime+[obj length])
                    {
                        timeEnd = obj.startingTime + [obj length];
                    }
                    float timeStart = lastLongNoteJudgmentTime;
                    if(timeStart<obj.startingTime)
                    {
                        timeStart = obj.startingTime;
                    }
                    longNoteTimeR += timeEnd-timeStart;
                    
                }
            }

        }
            

        if(time>obj.startingTime+[obj length]+timeForMiss)
        {
            obj.disappeared = true;

            for(int i = 0; i < [objectOnScreen count]; i++)
            {
                note* theNote = [objectOnScreen objectAtIndex:i];
                if(theNote.note == obj)
                {
                    if(obj.objectType == noteSingleNote)
                    {
                        [objectOnScreen removeObject:theNote];
                        [self displayJudgment:0];
                        [self refreshScoreList:0];
                        [self removeNoteSprite:theNote];
                        return true;
                    }
                    else if(obj.objectType == noteLongNote)
                    {
                        [objectOnScreen removeObject:theNote];
                        float thisNoteTime;
                        if(obj.objectSubType == trackLeft)
                        {
                            thisNoteTime = longNoteTimeL;
                            longNoteTimeL = 0;
                        }
                        else if(obj.objectSubType == trackRight)
                        {
                            thisNoteTime = longNoteTimeR;
                            longNoteTimeR = 0;
                        }
                        
                        float rate = thisNoteTime / [obj length];
                        int judgment;
                        if(rate>0.99) judgment = 3;
                        else if(rate>0.5) judgment = 2;
                        else if(rate>0.01) judgment = 1;
                        else judgment = 0;
                        [self displayJudgment:judgment];
                        [self refreshScoreList:judgment];
                        [self removeNoteSprite:theNote];
                        return true;
                    }

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
                note* theNote = [objectOnScreen objectAtIndex:i];
                if(theNote.note == obj)
                {
                    [objectOnScreen removeObject:theNote];
                    [self removeNoteSprite:theNote];
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
        
        theStage.hitpoint -= [theJudgment.judgmentHitPoint[type] floatValue];
        if(theStage.hitpoint > theStage.hitpointMax) theStage.hitpoint=theStage.hitpointMax;
        if(theStage.hitpoint < 0) theStage.hitpoint = 0;
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
    //NSLog([NSString stringWithFormat:@"Music has finished! %d/%d/%d/%d",[self getJudgmentCount:3],[self getJudgmentCount:2],[self getJudgmentCount:1],[self getJudgmentCount:0]]);
    [theBGMManager clearFinishStatus];
    CCScene *resultScene = (Results*)[CCBReader loadAsScene:@"Results"];
    Results *customObject = [[resultScene children] firstObject];
    
    customObject.theJudgment = theJudgment;
    customObject.theStage = theStage;
    
    [[CCDirector sharedDirector] replaceScene:resultScene];
}
@end

