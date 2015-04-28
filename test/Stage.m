//
//  Stage.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Stage.h"

@implementation Stage

-(id)init
{
    _theChart = [[Chart alloc]init];
    _parameters = [[NSMutableDictionary alloc]init];
    _scores = [[NSMutableDictionary alloc]init];
    _clearStatus = -1;
    _hitpoint = 0;
    _hitpointMax = 1;
    return self;
}

@end
