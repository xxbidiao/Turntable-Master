//
//  note.h
//  MGWUGameTemplate
//
//  This class is the graphical base class of all notes.
//
//  Created by LinLee on 3/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartObject.h"

@interface note : CCSprite

@property ChartObject* note;

-(void) setupSprite;

-(void) refreshSprite:(double) currentTime;



@end
