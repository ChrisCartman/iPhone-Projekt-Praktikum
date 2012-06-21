//
//  MainPot.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 13.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainPot.h"

@implementation MainPot

@synthesize allChipsInAllPots;
@synthesize listOfAllSidePots;

- (id) init
{
    if (self = [super init]) {
        self.allChipsInAllPots = 0;
        self.listOfAllSidePots = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) resetMainPotForNewRound
{
    allChipsInAllPots = 0;
    [listOfAllSidePots removeAllObjects];
    chipsInPot = 0;
}

@end
