//
//  CardsOnTable.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardsOnTable.h"

@implementation CardsOnTable

@synthesize flop;
@synthesize turn;
@synthesize river;
@synthesize allCards;

- (id) init
{
    self = [super init];
    flop = [[NSMutableArray alloc] init];
    turn = [[PlayingCard alloc] init];
    river = [[PlayingCard alloc] init];
    allCards = [[NSMutableArray alloc] init];
    return self;
}

- (void) resetCardsOnTableForNewRound
{
    [self.flop removeAllObjects];
    self.turn = nil;
    self.river = nil;
    [self.allCards removeAllObjects];
}

@end
