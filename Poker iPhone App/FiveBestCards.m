//
//  FiveBestCards.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FiveBestCards.h"

@implementation FiveBestCards

@synthesize arrayOfFiveBestCards;
@synthesize valueOfFiveBestCards;
@synthesize cardValuesAsString;

- (id) init
{
    self = [super init];
    arrayOfFiveBestCards = [[NSMutableArray alloc] initWithCapacity:5];
    cardValuesAsString = [[NSString alloc] init];
    return self;
}

- (void) resetFiveBestCardsForNewRound
{
    [arrayOfFiveBestCards removeAllObjects];
    valueOfFiveBestCards = NOTHING;
    cardValuesAsString = @"";
}

@end
