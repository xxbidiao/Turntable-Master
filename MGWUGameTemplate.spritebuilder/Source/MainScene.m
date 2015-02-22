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
    [judgmentParameters addObject:@0.060];
    [judgmentParameters addObject:@0.030];
    [judgmentParameters addObject:@-1];
    
    //hard code judgments temporarily
    [judgmentNames addObject:@"Miss"];
    [judgmentNames addObject:@"Guard"];
    [judgmentNames addObject:@"Hit"];
    [judgmentNames addObject:@"Critical"];
    
    
    
    
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
    
    self.userInteractionEnabled = TRUE;
    theBGMManager = [[BGMManager alloc ]init];
    [theBGMManager initializeBGM:path];
    [theBGMManager playBGM];
    objectOnScreen = [[NSMutableArray alloc]init];
    
    
    
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
            [objectOnScreen addObject:theObject];
            theObject.appeared = true;
        }
    }
    
    
    bool doJudgmentReturnVal= true;
    while (doJudgmentReturnVal) {
        ChartObject* theObject = [objectOnScreen objectAtIndex:0];
        doJudgmentReturnVal = [self doJudgment:bgmLocation withObject:theObject onlyTooLate:true];
    }
    
    
    
    
}

-(void) touchBegan:(UITouch*)touch withEvent:(UIEvent *)event
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
    if(zoneID == 0)
    [_testText setString:@"Left Turntable Turned Successful"];
    else if(zoneID == 1)
    {
            [_testText setString:@"Right Turntable Turned Successful"];
    }
    else     [_testText setString:@"Other place has been touched."];
}

- (bool) doJudgment:(double) time withObject:(ChartObject*) obj onlyTooLate:(bool) flag
{
    if(flag)
    {
        double timeForMiss = [[judgmentParameters objectAtIndex:0] doubleValue];
        if(time>obj.startingTime+[obj length]+timeForMiss)
        {
            [objectOnScreen removeObject:obj];
            
            [self displayJudgment:0];
            return true;
        }
        return false;
    }
    return false;
}

- (void) displayJudgment:(int) type
{
    return;
}

@end

