//
//  LongNote.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LongNote.h"

@implementation LongNote
-(void) setupSprite
{
    self.sprite= (CCSprite*)[CCBReader load:@"SingleNote"];
    [self.sprite setScaleX:1.5f];
    [self.sprite setScaleY:1.5f];
    self.sprite.positionType = CCPositionTypeNormalized;
}

-(void) refreshSprite:(double) currentTime
{
    int position = [((NSNumber*)self.note.objectPosition[@"SingleNotePosition"]) intValue];
    if(self.note.objectSubType == 0)
        self.sprite.position = ccp((5-self.note.startingTime+currentTime)*0.3+0,0.25+position*0.05);
    else
        self.sprite.position = ccp((5-self.note.startingTime+currentTime)*-0.3+1,0.25+position*0.05);
}
@end
