//
//  ChartObject.h
//
//  Created by Zhiyu Lin on 2/20/15.
//  This class is the parent of chart objects.
//  Chart objects are objects (a.k.a. notes) in a chart.
//

#import <Foundation/Foundation.h>

@interface ChartObject : NSObject

// field for other objects to recognize which kind of chart object it is
@property int objectType;

// field for its starting time.
// Some note may only have a starting time, other notes have more properties.
@property double startingTime;

// Location where object data like where it appears is stored.
@property NSDictionary* objectPosition;



@end
