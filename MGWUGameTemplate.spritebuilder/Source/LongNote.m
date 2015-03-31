//
//  LongNote.m
//  MGWUGameTemplate
//
//  Created by LinLee on 3/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LongNote.h"

@implementation LongNote

-(id) init
{
    self.speedFactor = 0.1;
    return self;
}

#pragma mark private helpers
//modifier: the Y axis distance
-(void) setScaleFromNormalizedSize:(CCSprite*) sprite width:(float)w height:(float)h modifier:(float)m
{
    //note that the W does not need a modifier.
    CGSize s = [CCDirector sharedDirector].viewSize;
    float screenModifier = s.width/s.height;
    float scaleW = w*s.width/sprite.contentSize.width;
    float pixelX = h * s.height;
    float pixelY = m * s.width;
    float scaleH = sqrt(pixelX*pixelX+pixelY*pixelY)/sprite.contentSize.height;
    sprite.scaleX = scaleW;
    sprite.scaleY = scaleH;
}

float positionYStartingAt = 0.1;
float positionYDelta = 0.08;


-(float) getPositionY:(int) subTrack
{
    return positionYStartingAt+subTrack*positionYDelta;
}

// Y in position, not normalized value
-(float) getAngle:(float) deltaX :(int)deltaY
{
    CGSize s = [CCDirector sharedDirector].viewSize;
    float scaleW = s.width;
    float scaleH = s.height;
    float modifier = scaleW/scaleH;
    
    if(deltaX == 0) return 90.0f;
    float realYDelta = deltaY*positionYDelta; //possible to be neg
    float angle = atan2(realYDelta,deltaX*modifier)*180/3.1415926;
    return 90-angle;
}

-(void) setupSprite
{
    float flipfactor = 0;
    if(self.note.objectSubType == 0)
    {
        flipfactor = -1;
    }
    else if(self.note.objectSubType == 1)
    {
        flipfactor = 1;
    }
    CCNode* wholeLongNote = [[CCNode alloc]init];
    [wholeLongNote setContentSize: CGSizeMake(1,1)];
    [wholeLongNote setContentSizeType:CCSizeTypeNormalized];
    [wholeLongNote setPositionType:CCPositionTypeNormalized];
    int totalNodes = [self getTotalNodeCount];
    //note that the index start at 1
    for(int i = 1; i <= totalNodes; i++)
    {
        CCSprite* ln1 = (CCSprite*)[CCBReader load:@"LongNoteNode"];
        [ln1 setScaleX:0.5f];
        [ln1 setScaleY:0.5f];
        [ln1 setAnchorPoint:CGPointMake(0.5f,0.5f)];
        ln1.positionType = CCPositionTypeNormalized;
        int thePosition = [self getNodePosition:i];
        ln1.position = CGPointMake([self getNodeTime:i]*self.speedFactor*flipfactor,[self getPositionY:thePosition]);
        [wholeLongNote addChild: ln1];
        if(i >= 2)
        {
            CCSprite* ln3 = (CCSprite*)[CCBReader load:@"LongNoteLine"];
            [ln3 setAnchorPoint:CGPointMake(0.5,0.0)];
            
            int deltaInPosition = [self getNodePosition:i] - [self getNodePosition:i-1];
            float theModifier = [self getNodeTime:i]-[self getNodeTime:i-1];
            theModifier *= self.speedFactor;
            [self setScaleFromNormalizedSize:ln3 width:0.02 height:deltaInPosition*positionYDelta modifier:theModifier];
            
            //[ln3 setScaleX:1.0f];
            //[ln3 setScaleY:1.0f];
            [ln3 setRotation:flipfactor * [self getAngle:theModifier :deltaInPosition]+180];
            ln3.positionType = CCPositionTypeNormalized;
            ln3.position = CGPointMake([self getNodeTime:i]*self.speedFactor*flipfactor,[self getPositionY:thePosition]);
            [wholeLongNote addChild: ln3];
        }
    }


    
    self.sprite = wholeLongNote;
}

-(void) refreshSprite:(double) currentTime
{
    int position = [((NSNumber*)self.note.objectPosition[@"SingleNotePosition"]) intValue];
    
    if(self.note.objectSubType == 0)
        self.sprite.position = ccp((0.5/self.speedFactor-self.note.startingTime+currentTime)*self.speedFactor+0,[self getPositionY:position]);
    else
        self.sprite.position = ccp((0.5/self.speedFactor-self.note.startingTime+currentTime)*-self.speedFactor+1,[self getPositionY:position]);
}

#pragma mark data extraction helpers
-(int) getTotalNodeCount
{
    int result =  [((NSNumber*)self.note.objectPosition[@"LongNoteTotalNodeCount"]) intValue];
    return result;
}

-(int) getNodePosition:(int) loc
{
    NSString* lookupString = [NSString stringWithFormat:@"LongNoteNodePosition%d",loc];
    int result =  [((NSNumber*)self.note.objectPosition[lookupString]) intValue];
    return result;
}

-(float) getNodeTime:(int) loc
{
    NSString* lookupString = [NSString stringWithFormat:@"LongNoteNodeTime%d",loc];
    float result =  [((NSNumber*)self.note.objectPosition[lookupString]) floatValue];
    return result;
}
@end
