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

@interface MainScene()

- (void) operation:(int) zoneID touchLocation:(CGPoint) thePoint;

@end

@implementation MainScene
{
    
    CCLabelTTF* _testText;
    CCNode* _operationZone;
    CCNode* _leftTurntable;
    CCNode* _rightTurntable;
    int count;
    double totalTime;
    double totalTime2;
    ChartLoader* theCL;
    BGMManager* theBGMManager;
    
    NSMutableArray* judgmentParameters;
    NSMutableArray* judgmentNames;
    
    double speedFactor;
    
    NSMutableArray* objectOnScreen;
    double latestObjectOnScreen;
    
    //test
    SingleNote* noteNode;
    
    
}



-(void) didLoadFromCCB
{
    count = 0;
    totalTime = 0;
    totalTime2 = 0;
    speedFactor = 1;
    
    judgmentParameters = [[NSMutableArray alloc]init];
    judgmentNames = [[NSMutableArray alloc]init];
    
    //hard code judgments temporarily
    [judgmentParameters addObject:@0.120];
    [judgmentParameters addObject:@0.120];
    [judgmentParameters addObject:@0.060];
    [judgmentParameters addObject:@0.030];
    [judgmentParameters addObject:@-1];
    
    
    //hard code judgments temporarily
    [judgmentNames addObject:@"Miss"];
    [judgmentNames addObject:@"Guard"];
    [judgmentNames addObject:@"Hit"];
    [judgmentNames addObject:@"Critical"];
    [judgmentNames addObject:@"IMPOSSIBLE"];
    
    
    
    
    theCL = [[ChartLoader alloc]init];
    [theCL loadChartFromFile:@"test"];
    /*
    NSString* str = theCL.theChart.chartInfo[@"Difficulty"];
    NSLog(str);
     */
    //NSString * applicationPath = [[NSBundle mainBundle] bundlePath];
    //NSLog(applicationPath);
    [_testText setString:@"Load Successful"];
    
    NSFileManager *filemgr;
    
    
    
    NSString* path;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource: @"test" ofType: @"mp3"];
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: path ] == YES)
        NSLog (@"File exists");
    else
        NSLog (@"File not found");
    

    theBGMManager = [[BGMManager alloc ]init];
    [theBGMManager initializeBGM:path];
    [theBGMManager playBGM];
    objectOnScreen = [[NSMutableArray alloc]init];
    
    /*
    // loads the Penguin.ccb we have set up in Spritebuilder
    SingleNote* note = [CCBReader load:@"SingleNote" owner:self];
    // position the penguin at the bowl of the catapult
    note.position = ccp(100,100);
    [self addChild:note];
    */
    self.userInteractionEnabled = TRUE;
    
}

- (void)update:(CCTime)delta
{
    
    count += 1;
    totalTime += delta;
    totalTime2 += delta;
    //NSMutableArray *objectsInRange = [theCL.theChart getObjectsRangedInTime:totalTime2 second:totalTime2*2];
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
    
    NSMutableArray* possibleNewObjects = [theCL.theChart getObjectsRangedInTime:bgmLocation second:bgmLocation+lifetime];
    for(int i = 0; i < [possibleNewObjects count]; i++)
    {
        ChartObject* theObject = [possibleNewObjects objectAtIndex:i];
        if(theObject.appeared == false)
        {
            SingleNote* theNote = [CCBReader load:@"SingleNote" owner:self];
            theNote.note = theObject;
            [objectOnScreen addObject:theNote];
            theObject.appeared = true;
            [self addChild:theNote];
        }
    }
    
    //refresh note locations
    //temporarily hard-code it here
    for(int i = 0; i < [objectOnScreen count]; i++)
    {
        SingleNote* theNote = [objectOnScreen objectAtIndex:i];
        theNote.position = ccp((5-theNote.note.startingTime+bgmLocation)*100+0,200);
    }
    
    
    bool doJudgmentReturnVal= true;
    while (doJudgmentReturnVal) {
        SingleNote* theNote = [objectOnScreen objectAtIndex:0];
        doJudgmentReturnVal = [self doJudgment:bgmLocation withObject:theNote.note onlyTooLate:true];
    }
    
    
    
    
}

-(void) touchBegan:(CCTouch*)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_operationZone];
    
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
                                        [self removeChild:theNote];
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
                    [self removeChild:theNote];
                    [self displayJudgment:bestJudgment];
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
    return;
}


@end

