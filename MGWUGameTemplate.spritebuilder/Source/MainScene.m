//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "ChartLoader.h"

@implementation MainScene
{
    CCLabelTTF* _testText;
}



-(void) didLoadFromCCB
{
    ChartLoader* theCL = [[ChartLoader alloc]init];
    [theCL loadChartFromFile:@"test"];
    NSString* str = theCL.theChart.chartInfo[@"Difficulty"];
    NSLog(str);
    [_testText setString:str];
}

@end
