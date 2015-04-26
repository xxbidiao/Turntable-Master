//
//  StageSelectionMenuItem.m
//  TurntableMaster
//
//  Created by LinLee on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StageSelectionMenuItem.h"

@implementation StageSelectionMenuItem
{
    CCLabelTTF* _songName;
    CCLabelTTF* _songMetadata;
    CCSprite* _songPicture;
    NSString* theName;
    NSString* theMetadata;
    bool needSetting;
}

- (void) onEnter
{
    [super onEnter];
    [self setCaption:theName withMeta:theMetadata];
    self.userInteractionEnabled = TRUE;
}

- (void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
    NSLog(@"touchbegan");
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"TOUCHENDED");
    [_owner selectSong:1 withFile:theName];
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = self.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Select"];
}

-(bool) setCaption:(NSString*) name withMeta: (NSString*) metadata
{
    theName = name;
    theMetadata = metadata;
    [_songName setString:name];
    [_songMetadata setString:metadata];
    return true;
}

@end
