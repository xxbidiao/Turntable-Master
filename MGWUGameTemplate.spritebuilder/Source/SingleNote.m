//
//  SingleNote.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SingleNote.h"

@implementation SingleNote

-(id) init
{
    self = [super init];
    NSLog(@"Hello from SingleNote");
    return self;
}

-(id) initWithNote:(ChartObject*) obj
{
    self = [super init];
    NSLog(@"Initialized with chartobject");
    self.note = obj;
    return self;
}

@end
