//
//  Chart.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Chart.h"
#import "ChartObject.h"

@implementation Chart

-(id)init
{
    _objects = [[NSMutableArray alloc]init];
    _chartInfo = [[NSMutableDictionary alloc]init];
    return self;
}

-(int) findFirstObjectAfterStartingTime:(double) time
{
    int min = 0;
    int max = _objects.count;
    while(max-min > 5)
    {
        int position = (min+max)/2;
        ChartObject* theObj = _objects[position];
        if(theObj.startingTime > time)
        {
            max = position;
        }
        else
        {
            min = position;
        }
    }
    for(int i = min; i < max; i++)
    {
        ChartObject* theObj = _objects[i];
        if(theObj.startingTime > time) return i;
    }
    //no elements are after Starting Time, return count
    return max;
    
    
    
}

-(NSMutableArray*) getObjectsRangedInTime:(double)min second:(double)max
{
    double smallNumber = 1e-5;
    NSMutableArray* retval = [[NSMutableArray alloc]init];
    int startingPoint = [self findFirstObjectAfterStartingTime:min];
    for(int i = startingPoint; i < [_objects count]; i++)
    {
        ChartObject* thisObject = _objects[i];
        if(thisObject.startingTime>min && thisObject.startingTime<max+smallNumber)
        {
            [retval addObject:_objects[i]];
        }
        if(thisObject.startingTime > max+smallNumber)
        {
            return retval;
        }
    }
    return retval;
}

@end
