//
//  StageSelectionMenuItem.h
//  TurntableMaster
//
//  Created by LinLee on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "StageSelection.h"

@interface StageSelectionMenuItem : CCNode

-(bool) setCaption:(NSString*) name withMeta: (NSString*) metadata;

@property NSString* chartFile;
@property StageSelection* owner;
@end
