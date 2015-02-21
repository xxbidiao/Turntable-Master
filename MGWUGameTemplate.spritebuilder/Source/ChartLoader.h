//
//  ChartLoader.h
//  MGWUGameTemplate
//
//  Created by LinLee on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chart.h"

@interface ChartLoader : NSObject

@property Chart* theChart;

-(BOOL) loadChartFromFile:(NSString*) filename;

@end
