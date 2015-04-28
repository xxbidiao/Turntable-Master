//
//  holdedTouch.h
//  MGWUGameTemplate
//
//  Created by LinLee on 3/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface holdedTouch : NSObject

//touchMoved related variables
typedef NS_ENUM(NSInteger, movingDirection) {
    movingUp,
    movingDown,
    movingNone
};

@property CCTouch * theTouch;
@property enum movingDirection moveStatus;
@property BOOL isMoveStillValid;
@property double origX;
@property double origY;
@property double lastX;
@property double lastY;
@property double movingDistance;
@property unsigned long hashNumber;
@property CCParticleSystem * effect;

-(void)generateHash;
@end
