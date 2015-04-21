//
//  Config.m
//  TurntableMaster
//
//  Created by LinLee on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Config.h"

@implementation Config

double speedFactor;

+(double)getSpeedFactor
{
    return speedFactor;
}

+(void)setSpeedFactor:(double)value
{
    speedFactor = value;
}

@end
