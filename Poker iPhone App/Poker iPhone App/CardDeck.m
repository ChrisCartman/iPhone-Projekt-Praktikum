//
//  CardDeck.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardDeck.h"
#include <stdlib.h>

@implementation CardDeck

@synthesize cardsInCardDeck;
@synthesize cardsDrawnFromCardDeck;
@synthesize popsFor;


//Die Funktion initialize erstellt alle Spielkarten und speichert sie im Array allPlayingCards
- (id) init
{
    NSMutableArray* temporaryArray = [[NSMutableArray alloc] initWithCapacity:52];
    for (int i=1; i<=4; i++)
    {
        for (int j=2; j<= 14; j++)
        {
            PlayingCard* newPlayingCard = [[PlayingCard alloc] init];
            newPlayingCard.playingCardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%i_%i.png",j,i]];
            newPlayingCard.value = j;
            if (i==1) {
                newPlayingCard.suitType = CLUBS;
            }
            else if (i==2) {
                newPlayingCard.suitType = SPADES;
            }
            else if (i==3) {
                newPlayingCard.suitType = DIAMONDS;
            }
            else {
                newPlayingCard.suitType = HEARTS;
            }
            [temporaryArray addObject:newPlayingCard];
        }
    }
    allPlayingCards = [[NSArray alloc] initWithArray: temporaryArray];
    cardsInCardDeck = [[NSMutableArray alloc] initWithCapacity:52];
    [cardsInCardDeck addObjectsFromArray:allPlayingCards];
    cardsDrawnFromCardDeck = [[NSMutableArray alloc] init];
    popsFor = @"";
    return self;
}

- (void) resetCardDeckForNewRound
{
    [cardsInCardDeck addObjectsFromArray:cardsDrawnFromCardDeck];
}


//Die Funktion shuffle mischt die Elemente im Array cardsInCardDeck
- (void) shuffle
{
    if ([cardsInCardDeck count] < 52)
    {
        [cardsInCardDeck addObjectsFromArray:cardsDrawnFromCardDeck];
        [cardsDrawnFromCardDeck removeAllObjects];
    }
    int nElements;
    int n;
    for (int i=1; i<52; i++)
    {
        nElements = 52 - i;
        n = (arc4random() % nElements) + i;
        [cardsInCardDeck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

//Oberste Karte vom Kartenstapel abheben:
- (PlayingCard* ) popFor: (NSString* ) playerOrTableCard
{
    PlayingCard* temporaryPlayingCard = [cardsInCardDeck objectAtIndex:([cardsInCardDeck count] - 1)];
    [cardsInCardDeck removeObjectAtIndex:([cardsInCardDeck count] - 1)];
    if (cardsDrawnFromCardDeck == nil)
    {
        cardsDrawnFromCardDeck = [[NSMutableArray alloc] init];
    }
    [cardsDrawnFromCardDeck addObject:temporaryPlayingCard];
    self.popsFor = playerOrTableCard;
    return temporaryPlayingCard;
}

@end
