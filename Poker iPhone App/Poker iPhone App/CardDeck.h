//
//  CardDeck.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@interface CardDeck : NSObject
{
    NSArray* allPlayingCards;
    NSMutableArray* cardsInCardDeck;
    NSMutableArray* cardsDrawnFromCardDeck;
}

- (void) shuffle;
- (PlayingCard* ) pop;

@property (nonatomic, retain) NSMutableArray* cardsInCardDeck;
@property (nonatomic, retain) NSMutableArray* cardsDrawnFromCardDeck;

- (void) resetCardDeckForNewRound;

@end
