//
//  note.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "note.h"

@implementation note

-(id) init
{
    NSLog(@"Hello from note");
    return self;
}

-(id) initWithNote:(ChartObject*) obj
{
    NSLog(@"Initialized with chartobject");
    self.note = obj;
    return self;
}

-(void) setupSprite
{
    NSAssert(NO,@"pure virtual function in note called!");
}

-(void) refreshSprite:(double) currentTime
{
    NSAssert(NO,@"pure virtual function in note called!");
}


@end
