//
//  ChartLoader.m
//  MGWUGameTemplate
//
//  Created by LinLee on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChartLoader.h"
#import "ChartObject.h"

@implementation ChartLoader

-(id)init
{
    _theChart = [[Chart alloc]init];
    return self;
}

-(BOOL) loadChartFromFile:(NSString*) filename
{
    _theChart = [[Chart alloc]init];
    if([filename  isEqual: @"test"])
    {
        _theChart.chartInfo[@"Difficulty"]=@"1";
        for(int i = 0; i <= 1; i++)
        {
            ChartObject* theObjSingle = [[ChartObject alloc]init];
            theObjSingle.startingTime = 3;
            theObjSingle.objectType = 0;
            theObjSingle.objectSubType = i;
            theObjSingle.objectPosition[@"SingleNotePosition"] = [NSNumber numberWithInt:3];
            [_theChart.objects addObject:theObjSingle];
            ChartObject* theObj = [[ChartObject alloc]init];
            theObj.startingTime = 5;
            theObj.objectType = 1;
            theObj.objectSubType = i;
            theObj.objectPosition[@"LongNoteNodePosition1"] = [NSNumber numberWithInt: 1];
            theObj.objectPosition[@"LongNoteNodeTime1"] = [NSNumber numberWithDouble:0];
            theObj.objectPosition[@"LongNoteNodePosition2"] = [NSNumber numberWithInt: 4];
            theObj.objectPosition[@"LongNoteNodeTime2"] = [NSNumber numberWithDouble:1.0f];
            theObj.objectPosition[@"LongNoteNodePosition3"] = [NSNumber numberWithInt: 7];
            theObj.objectPosition[@"LongNoteNodeTime3"] = [NSNumber numberWithDouble:1.25f];
            theObj.objectPosition[@"LongNoteNodePosition4"] = [NSNumber numberWithInt: 5];
            theObj.objectPosition[@"LongNoteNodeTime4"] = [NSNumber numberWithDouble:1.5f];
            theObj.objectPosition[@"LongNoteNodePosition5"] = [NSNumber numberWithInt: 2];
            theObj.objectPosition[@"LongNoteNodeTime5"] = [NSNumber numberWithDouble:3.0f];
            theObj.objectPosition[@"LongNoteNodePosition6"] = [NSNumber numberWithInt: 3];
            theObj.objectPosition[@"LongNoteNodeTime6"] = [NSNumber numberWithDouble:4.0f];
            theObj.objectPosition[@"LongNoteTotalNodeCount"] = [NSNumber numberWithInt:6];
            [_theChart.objects addObject:theObj];
        }
        return true;
    }
    else
    {
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [directories firstObject];
        NSLog(@"DOCUMENTS > %@", documents);
        NSString *filePath = [documents stringByAppendingPathComponent:filename];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error = nil;
        
        // Get JSON data into a Foundation object
        id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        // Verify object retrieved is dictionary
        if ([object isKindOfClass:[NSDictionary class]] && error == nil)
        {
            _theChart.chartInfo = object[@"chartInfo"];
            NSMutableArray* chartObjs = object[@"objects"];
            for(int i = 0; i < chartObjs.count; i++)
            {
                NSMutableDictionary* tmpObj = chartObjs[i];
                ChartObject* temp = [[ChartObject alloc]init];
                [temp deserialize:tmpObj];
                [_theChart.objects addObject:temp];
            }
        }
        return true;
    }

    
}

-(BOOL) saveChartToFile:(NSString*) filename
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_theChart.chartInfo forKey:@"chartInfo"];
    NSMutableArray* objs = [[NSMutableArray alloc]init];
    for (int i = 0; i < _theChart.objects.count; i++) {
        NSDictionary* tempObj = [((ChartObject*)_theChart.objects[i]) serialize];
        [objs addObject: tempObj];
    }
    [dict setObject: objs forKey:@"objects"];
    
    
    NSError * error = nil;
    NSData * json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    //NSString* newStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    //NSLog(newStr);
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSLog(@"DOCUMENTS > %@", documents);
    NSString *filePath = [documents stringByAppendingPathComponent:filename];
    [json writeToFile:filePath atomically:true];
    return true;
}

@end
