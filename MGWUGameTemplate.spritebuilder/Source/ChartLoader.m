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
        _theChart.chartInfo[@"Difficulty"]=@"10";
        _theChart.chartInfo[@"BGMFilename"]=@"test";
        _theChart.chartInfo[@"BGMExtension"]=@"mp3";
        for(int i = 0; i <= 10; i++)
        {
            ChartObject* theObjSingle = [[ChartObject alloc]init];
            theObjSingle.startingTime = 3+(i/2)*4;
            theObjSingle.objectType = 0;
            theObjSingle.objectSubType = (i+1)%2;
            theObjSingle.objectPosition[@"SingleNotePosition"] = [NSNumber numberWithInt:5];
            //[_theChart.objects addObject:theObjSingle];
            ChartObject* theObj = [[ChartObject alloc]init];
            theObj.startingTime = 3.5+i*2;
            theObj.objectType = 1;
            theObj.objectSubType = (i%2);
            theObj.objectPosition[@"LongNoteNodePosition1"] = [NSNumber numberWithInt: 1];
            theObj.objectPosition[@"LongNoteNodeTime1"] = [NSNumber numberWithDouble:0];
            theObj.objectPosition[@"LongNoteNodePosition2"] = [NSNumber numberWithInt: 1];
            theObj.objectPosition[@"LongNoteNodeTime2"] = [NSNumber numberWithDouble:0.5f];
            theObj.objectPosition[@"LongNoteNodePosition3"] = [NSNumber numberWithInt: 1];
            theObj.objectPosition[@"LongNoteNodeTime3"] = [NSNumber numberWithDouble:1.0f];
            theObj.objectPosition[@"LongNoteTotalNodeCount"] = [NSNumber numberWithInt:3];
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
        NSFileManager *fm = [NSFileManager defaultManager];
        bool readable = [fm isReadableFileAtPath:filePath];
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath options: 0 error: &error];
        if (jsonData == nil)
        {
            NSLog(@"Failed to read file, error %@", error);
        }
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
    [json writeToFile:filePath atomically:false];
        NSError* errorFM;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[fm attributesOfItemAtPath:filePath error:&errorFM]];
    [attributes setValue:[NSNumber numberWithShort:0777]
                  forKey:NSFilePosixPermissions]; // chmod permissions 777

    [fm setAttributes:attributes ofItemAtPath:filePath error:&errorFM];
    return true;
}

@end
