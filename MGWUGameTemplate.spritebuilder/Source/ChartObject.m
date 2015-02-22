//
//  ChartObject.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChartObject.h"

@implementation ChartObject

-(id)init
{
    _objectType = 0;
    _startingTime = 0;
    _objectPosition = [[NSMutableDictionary alloc]init];
    _appeared = false;
    _playerPerformance = [[NSMutableDictionary alloc]init];
    return self;
    
}

-(double)length
{
    return 0;
}

@end
