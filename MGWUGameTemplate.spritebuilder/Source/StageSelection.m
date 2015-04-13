//
//  StageSelection.m
//  MGWUGameTemplate
//
//  Created by LinLee on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StageSelection.h"
#import "MainScene.h"
#import "StageSelectionMenuItem.h"
#import "ChartLoader.h"


@implementation StageSelection
{
    CCScrollView* _songSelectionContainer;
    CCButton* _play;
    
    NSString* selectedSong;
    int selectedID;
}

- (void) selectSong:(int) myID withFile:(NSString*) name
{
    selectedSong = name;
    selectedID = myID;
    _play.visible = true;
}

- (void) onEnter
{
    [super onEnter];
    ChartLoader* theCL = [[ChartLoader alloc]init];
    [theCL loadChartFromFile:@"test"];
    [theCL saveChartToFile:@"test.tcf"];
    [theCL loadChartFromFile:@"test.tcf"];
    [theCL saveChartToFile:@"test2.tcf"];
    [theCL loadChartFromFile:@"test2.tcf"];
    NSLog(@"Listing files...");
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:documents error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.tcf'"];
    NSArray *onlyTCFs = [dirContents filteredArrayUsingPredicate:fltr];
    CCLayoutBox* box = (CCLayoutBox*)[_songSelectionContainer getChildByName:@"menu" recursively:true];
    for(int i = 0; i < [onlyTCFs count]; i++)
    {
        StageSelectionMenuItem* song = (StageSelectionMenuItem*)[CCBReader load:@"StageSelectionMenuItem" owner:self];
        
        [theCL loadChartFromFile:onlyTCFs[i]];
        //NSString* pathBGM = theCL.theChart.chartInfo[@"BGMFilename"];
        NSString* difficulty = theCL.theChart.chartInfo[@"Difficulty"];
        [song setCaption:onlyTCFs[i] withMeta:difficulty];
        song.chartFile = onlyTCFs[i];
        song.itemID = i;
        song.owner = self;

        [box addChild: song];
    }
    

    [box layout];
    CCNode* boxNode = [_songSelectionContainer getChildByName:@"menuNode" recursively:true];
    boxNode.contentSize = box.contentSize;
    boxNode.contentSizeType = box.contentSizeType;
}

-(void)playPressed
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    MainScene *customObject = [[gameplayScene children] firstObject];
    customObject.chartName = selectedSong;
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
