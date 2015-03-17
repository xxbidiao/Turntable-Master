//
//  holdedTouch.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "holdedTouch.h"

@implementation holdedTouch

-(id) init
{
    self.isMoveStillValid = true;
    self.movingDistance = 0;
    self.moveStatus = movingNone;
    self.theTouch = nil;
    return self;
}

-(void) generateHash
{
    self.hashNumber = self.theTouch.uiTouch.hash;
}

@end
