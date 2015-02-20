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

@property Chart* theChart;

@property NSDictionary* parameters;

@property NSDictionary* scores;



@end
