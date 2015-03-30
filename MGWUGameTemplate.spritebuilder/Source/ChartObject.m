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
    _disappeared = false;
    _playerPerformance = [[NSMutableDictionary alloc]init];
    return self;
    
}

-(double)length
{
    return 0;
}

-(NSMutableDictionary*) serialize
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    dict[@"objectType"] = [NSNumber numberWithInt:_objectType];
    dict[@"objectSubType"] = [NSNumber numberWithInt:_objectSubType];
    dict[@"startingTime"] = [NSNumber numberWithDouble:_startingTime];
    dict[@"objectPosition"] = _objectPosition;
    return dict;
}

-(void) deserialize:(NSMutableDictionary*) obj
{
    _objectType = [(NSNumber*)obj[@"objectType"] intValue];
    _objectSubType = [(NSNumber*)obj[@"objectSubType"] intValue];
    _startingTime = [(NSNumber*)obj[@"startingTime"] doubleValue];
    _objectPosition = obj[@"objectPosition"];
}

-(trackType) getTrackType;
{
    if(self.objectSubType == 0)
        return trackLeft;
    else
        return trackRight;
}

@end
