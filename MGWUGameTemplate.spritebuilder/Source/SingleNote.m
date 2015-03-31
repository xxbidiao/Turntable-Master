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
    int position = [((NSNumber*)self.note.objectPosition[@"SingleNotePosition"]) intValue];
    if(self.note.objectSubType == 0)
    self.sprite.position = ccp((2-self.note.startingTime+currentTime)*0.25,0.05+position*0.05);
    else
    self.sprite.position = ccp((2-self.note.startingTime+currentTime)*-0.25+1,0.05+position*0.05);
}



@end
