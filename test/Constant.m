//
//  Constant.m
//  MGWUGameTemplate
//
//  Created by LinLee on 4/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Constant.h"

float PositionYStartingAt = 0.1;
float PositionYDelta = 0.08;
float longNoteThreshold = 1.0;

@implementation Constant
+(float) kPositionYStartingAt
{
    return PositionYStartingAt;
}

+(float) kPositionYDelta
{
    return PositionYDelta;
}

+(float) kLongNoteThreshold
{
    return longNoteThreshold;
}
@end
