//
//  Stage.h
//  MGWUGameTemplate
//
//  Created by Zhiyu Lin on 2/20/15.
//  This is the logical representation part of the main scene stage.
//

#import <Foundation/Foundation.h>
#import "Chart.h"

@interface Stage : NSObject

//chart object reference.
@property Chart* theChart;

@property NSMutableDictionary* parameters;

@property NSMutableDictionary* scores;

@property int clearStatus;

@property float hitpoint;

@property float hitpointMax;



@end
