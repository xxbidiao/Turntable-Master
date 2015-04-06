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
    if(_objectType == noteSingleNote) return 0;
    if(_objectType == noteLongNote)
    {
        int totalNodes =  [((NSNumber*)self.objectPosition[@"LongNoteTotalNodeCount"]) intValue];
        NSString* lookupString1 = [NSString stringWithFormat:@"LongNoteNodeTime%d",1];
        float result1 =  [((NSNumber*)self.objectPosition[lookupString1]) floatValue];
        NSString* lookupString2 = [NSString stringWithFormat:@"LongNoteNodeTime%d",totalNodes];
        float result2 =  [((NSNumber*)self.objectPosition[lookupString2]) floatValue];
        return result2-result1;
        
        
    }
    return 0;
}

-(double) getCurrentLocation: (double) time
{
    if(_objectType == noteSingleNote)
    {
        return -1; //undefined for single note: hit everywhere is OK
    }
    if(_objectType == noteLongNote)
    {
        time -= self.startingTime;
        int totalNodes =  [((NSNumber*)self.objectPosition[@"LongNoteTotalNodeCount"]) intValue];
        int positions[totalNodes+1];
        float times[totalNodes+1];
        for(int i = 1; i <= totalNodes; i++)
        {
            NSString* lookupString1 = [NSString stringWithFormat:@"LongNoteNodePosition%d",i];
            int result1 =  [((NSNumber*)self.objectPosition[lookupString1]) intValue];
            positions[i] = result1;
            
            NSString* lookupString2 = [NSString stringWithFormat:@"LongNoteNodeTime%d",i];
            float result2 =  [((NSNumber*)self.objectPosition[lookupString2]) floatValue];
            times[i] = result2;
        }
        if(time<times[1]) return positions[1];
        if(time>times[totalNodes]) return positions[totalNodes];
        for(int i = 1; i < totalNodes; i++)
        {
            if(time<times[i+1])
            {
                float deltaPos = (float)positions[i+1] - (float)positions[i];
                float deltaTime = times[i+1]-times[i];
                float realDeltaTime = time - times[i];
                if(deltaTime<0.0001) deltaTime = 0.0001;
                float result = (float)positions[i] + realDeltaTime/deltaTime*deltaPos;
                return result;
            }
        }
        //uh,wow
        NSLog(@"Should not run to here in note position calc");
        return 0;
        
        
    }
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
