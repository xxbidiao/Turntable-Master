//
//  BGMManager.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGMManager.h"
#import "GBMusicTrack.h"
//#import "AQPlayer.h"
//#import "AQRecorder.h"

@implementation BGMManager
{
    GBMusicTrack* gb;
}


-(id) init
{
    return self;
}

-(BOOL) initializeBGM:(NSString*) fileName
{
    gb=[[GBMusicTrack alloc]initWithPath:fileName];
    return true;
}

-(BOOL) playBGM
{
    [gb play];
    return true;
    
}

-(BOOL) pauseBGM
{
    [gb pause];
    return true;
}

-(BOOL) stopBGM
{
    [gb close];
    return true;
}

-(double) getPlaybackTime
{
    return [gb getPlaybackLocation];
}

-(BOOL) isFinished
{
    return [gb isFinished];
}

-(void) clearFinishStatus
{
    [gb clearFinishStatus];
}


@end
