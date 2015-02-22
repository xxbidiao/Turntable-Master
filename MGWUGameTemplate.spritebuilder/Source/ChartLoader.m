//
//  ChartLoader.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChartLoader.h"
#import "ChartObject.h"

@implementation ChartLoader

-(id)init
{
    _theChart = [[Chart alloc]init];
    return self;
}

-(BOOL) loadChartFromFile:(NSString*) filename
{
    
    
    _theChart.chartInfo[@"Difficulty"]=@"1";
    for(int i = 0; i < 10000; i++)
    {
        ChartObject* theObj = [[ChartObject alloc]init];
        theObj.startingTime = i;
        [_theChart.objects addObject:theObj];
    }
    return true;
    
}

@end
