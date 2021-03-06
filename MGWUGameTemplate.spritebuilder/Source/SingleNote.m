//
//  SingleNote.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SingleNote.h"
#import "Config.h"

@implementation SingleNote

-(id) init
{
    self.speedFactor = [Config getSpeedFactor];
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
    int position = [((NSNumber*)self.note.objectPosition[@"SingleNotePosition"]) intValue];
    if(self.note.objectSubType == 0)
    self.sprite.position = ccp((0.5/self.speedFactor-self.note.startingTime+currentTime)*self.speedFactor,0.1+position*0.08);
    else
    self.sprite.position = ccp((0.5/self.speedFactor-self.note.startingTime+currentTime)*-self.speedFactor+1,0.1+position*0.08);
}



@end
