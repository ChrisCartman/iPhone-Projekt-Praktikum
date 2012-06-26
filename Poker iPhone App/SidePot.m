//
//  SidePot.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 18.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SidePot.h"

@implementation SidePot

@synthesize chipsAmountNeededFromEachPlayerToBeFilled;
@synthesize isFilled;
@synthesize playersWhoPaidInThisPot;
@synthesize isDrained;
@synthesize maxChips;

- (id) init
{
    if (self = [super init]) {
        self.chipsAmountNeededFromEachPlayerToBeFilled = 0;
        self.isFilled = NO;
        self.playersWhoPaidInThisPot = [[NSMutableArray alloc] init];
        self.isDrained = NO;
        self.maxChips = 0;
    }
    return self;
}

@end
