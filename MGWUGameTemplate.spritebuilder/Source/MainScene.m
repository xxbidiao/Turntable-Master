//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "ChartLoader.h"
#import "Chart.h"
#import "ChartObject.h"

@implementation MainScene
{
    CCLabelTTF* _testText;
    int count;
    double totalTime;
    double totalTime2;
    ChartLoader* theCL;
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
    [_testText setString:@"Load Successful"];
}

- (void)update:(CCTime)delta
{
    /*
    count += 1;
    totalTime += delta;
    totalTime2 += delta;
    NSMutableArray *objectsInRange = [theCL.theChart getObjectsRangedInTime:totalTime2 second:totalTime2*2];
    NSString *test1 = [NSString stringWithFormat:@"%.2f %lu", count/totalTime, (unsigned long)objectsInRange.count];
    [_testText setString:test1];
    if(count >= 100)
    {
        count /= 4;
        totalTime /= 4;
    }
     */
}

@end
