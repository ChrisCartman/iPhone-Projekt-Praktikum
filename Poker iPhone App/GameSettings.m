//
//  GameSettings.m
//  Poker iPhone App
//
//  Created by Lion User on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameSettings.h"


@implementation GameSettings
@synthesize difficulty;
@synthesize blinds;
@synthesize anzahlKI;
@synthesize startChips;
@synthesize startBlinds;
@synthesize increaseBlindsAfter;


- (id) initWithSettings: (GameSettings* ) settings
{
    if (self = [super init]) {
        self.difficulty = settings.difficulty;
        self.blinds = settings.blinds;
        self.anzahlKI = settings.anzahlKI;
        self.startChips = settings.startChips;
        self.startBlinds = settings.startBlinds;
        self.increaseBlindsAfter = settings.increaseBlindsAfter;
    }
    return self;
}




@end
