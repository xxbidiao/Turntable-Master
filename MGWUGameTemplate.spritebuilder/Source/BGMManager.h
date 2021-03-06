//
//  BGMManager.h
//  MGWUGameTemplate
//
//  Created by LinLee on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGMManager : NSObject

-(id) init;

-(BOOL) initializeBGM:(NSString*) fileName;

-(BOOL) playBGM;

-(BOOL) pauseBGM;

-(BOOL) stopBGM;

-(double) getPlaybackTime;

-(BOOL) isFinished;

-(void) clearFinishStatus;

-(BOOL) setLoop:(BOOL) value;

@end
