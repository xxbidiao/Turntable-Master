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
    self.sprite= (SingleNote*)[CCBReader load:@"SingleNote"];
    [self.sprite setScaleX:0.5f];
    [self.sprite setScaleY:0.5f];
    return self;
}

-(void) setupSprite
{

}

-(void) refreshSprite:(double) currentTime
{
    
}

@end
