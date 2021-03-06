//
//  noteBuilder.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "noteBuilder.h"
#import "SingleNote.h"
#import "LongNote.h"

@implementation noteBuilder

+(note*) getNote:(ChartObject*) obj
{
    if(obj.objectType == noteSingleNote)
    {
        SingleNote* theNote = [[SingleNote alloc]init];
        theNote.note = obj;
        return theNote;
    }
    else if(obj.objectType == noteLongNote)
    {
        LongNote* theNote = [[LongNote alloc]init];
        theNote.note = obj;
        return theNote;
    }
    return nil;
}

@end
