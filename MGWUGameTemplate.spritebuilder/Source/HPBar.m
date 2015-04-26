//
//  HPBar.m
//  TurntableMaster
//
//  Created by LinLee on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "HPBar.h"

@implementation HPBar

-(void)setPercentage:(float)percentage
{
    [super setPercentage:percentage];
    if(percentage<0.3)
    {
        NSLog(@"<0.3!");
    }
}

@end
