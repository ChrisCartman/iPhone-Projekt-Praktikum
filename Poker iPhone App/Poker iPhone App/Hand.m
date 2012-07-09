//
//  Hand.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Hand.h"

@implementation Hand

@synthesize cardsOnHand;
@synthesize chanceToWinGame;
@synthesize kicker;
@synthesize valueOfCardsWithTableCards;
@synthesize cardValuesEvaluator;
@synthesize fiveBestCards;

- (id) init
{
    self = [super init];
    cardValuesEvaluator = [[CardValuesEvaluator alloc] init];
    return self;
}

- (void) resetHandForNewRound
{
    [self.cardsOnHand removeAllObjects];
    self.valueOfCardsWithTableCards = NOTHING;
    [self.fiveBestCards resetFiveBestCardsForNewRound];
}

- (void) addCardToHand:(PlayingCard *)playingCard
{
    if (cardsOnHand == nil)
    {
        cardsOnHand = [[NSMutableArray alloc] initWithCapacity:2];
    }
    [cardsOnHand addObject:playingCard];
}

- (void) throwHandAway
{
    [cardsOnHand removeObjectAtIndex:0];
    [cardsOnHand removeObjectAtIndex:1];
}

- (void) defineValueOfCardsWithTableCards:(CardsOnTable *)currentCardsOnTable
{
    // in einem temporaeren Array werden sowohl die Handkarten als auch die Tischkarten abgelegt:
    NSMutableArray* temporaryArray = [NSMutableArray arrayWithArray:currentCardsOnTable.allCards];
    [temporaryArray addObjectsFromArray:cardsOnHand];
    if ([temporaryArray count] == 7) {
        NSLog(@"true");
    }
    else {
        NSLog(@"false, %i", [temporaryArray count]);
    }
    NSMutableArray* allCards = [NSMutableArray arrayWithArray:temporaryArray];
    [self.cardValuesEvaluator defineValueOfFiveBestCards:allCards];
    self.fiveBestCards = self.cardValuesEvaluator.fiveBestCards;
}

@end
