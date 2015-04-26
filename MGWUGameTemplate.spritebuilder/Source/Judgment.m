//
//  Judgment.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Judgment.h"

@implementation Judgment

//initialize the class with default judgment values
-(id)init
{
    _judgmentParameters = [[NSMutableArray alloc]init];
    _judgmentNames = [[NSMutableArray alloc]init];
    _judgmentHitPoint = [[NSMutableArray alloc]init];
    
    //hard code judgments temporarily
    [_judgmentParameters addObject:@0.120];
    [_judgmentParameters addObject:@0.120];
    [_judgmentParameters addObject:@0.060];
    [_judgmentParameters addObject:@0.030];
    [_judgmentParameters addObject:@-1];

    //hard code judgments temporarily
    [_judgmentHitPoint addObject:@-9.000f];
    [_judgmentHitPoint addObject:@0.000f];
    [_judgmentHitPoint addObject:@1.000f];
    [_judgmentHitPoint addObject:@3.000f];
    [_judgmentHitPoint addObject:@-9999.0f];
    
    //hard code judgments temporarily
    [_judgmentNames addObject:@"miss"];
    [_judgmentNames addObject:@"guard"];
    [_judgmentNames addObject:@"hit"];
    [_judgmentNames addObject:@"critical"];
    [_judgmentNames addObject:@"IMPOSSIBLE"];
    
    _judgmentMaxHPFactor = 1.25f;
    
    return self;
}

+(bool) breaksCombo:(int)type
{
    if(type == 0) return true;
    else return false;
}

@end
