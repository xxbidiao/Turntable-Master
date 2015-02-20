//
//  Chart.h
//  MGWUGameTemplate
//
//  Created by Zhiyu Lin on 2/20/15.
//  This class represents an abstract object of charts (how a stage is generated.)
//

#import <Foundation/Foundation.h>

@interface Chart : NSObject

//Objects in the chart.
@property NSArray* objects;

//Other related information about the chart (difficulty, BPM, etc)
@property NSDictionary* chartInfo;

@end
