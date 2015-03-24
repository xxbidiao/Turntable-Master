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
    return self;
}

-(void) setupSprite
{
    self.sprite= (SingleNote*)[CCBReader load:@"SingleNote"];
    [self.sprite setScaleX:0.5f];
    [self.sprite setScaleY:0.5f];
    self.sprite.positionType = CCPositionTypeNormalized;
}

-(void) refreshSprite:(double) currentTime
{
    if(self.note.objectSubType == 0)
    self.sprite.position = ccp((5-self.note.startingTime+currentTime)*0.1+0,0.25);
    else
    self.sprite.position = ccp((5-self.note.startingTime+currentTime)*-0.1+1,0.25);
}

@end
