//
//  HPBar.m
//  TurntableMaster
//
//  Created by LinLee on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "HPBar.h"

@implementation HPBar



-(void)onEnter
{
    [super onEnter];
    self.type=CCProgressNodeTypeBar;
    self.midpoint = CGPointMake(0,0);
    self.barChangeRate = CGPointMake(1,0);
    self.scaleX = 0.4;
    self.scaleY = 0.05;
    NSLog(@"SET");
}

-(void)setPercentage:(float)percentage
{
    [super setPercentage:percentage];
    if(percentage<0.3)
    {
        NSLog(@"<0.3!");
    }
}

@end
