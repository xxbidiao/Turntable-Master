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
}



-(void) didLoadFromCCB
{
    count = 0;
    totalTime = 0;
    totalTime2 = 0;
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
    
    
    
}

- (void)update:(CCTime)delta
{
    
    count += 1;
    totalTime += delta;
    totalTime2 += delta;
    NSMutableArray *objectsInRange = [theCL.theChart getObjectsRangedInTime:totalTime2 second:totalTime2*2];
    NSString *test1 = [NSString stringWithFormat:@"%.2f %f", count/totalTime, [theBGMManager getPlaybackTime]];
    [_testText setString:test1];
    if(count >= 100)
    {
        count /= 4;
        totalTime /= 4;
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

@end
