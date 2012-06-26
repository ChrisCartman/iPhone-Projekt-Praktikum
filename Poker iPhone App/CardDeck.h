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
- (PlayingCard* ) popFor: (NSString* ) playerOrTableCard;

@property (nonatomic, retain) NSMutableArray* cardsInCardDeck;
@property (nonatomic, retain) NSMutableArray* cardsDrawnFromCardDeck;
@property (nonatomic, retain) NSString* popsFor; //wird benötigt, um die Verknüpfung zwischen Karte und Outlets herzustellen, wenn eine Karte vom Stapel ausgeteilt wird (Animation)

- (void) resetCardDeckForNewRound;

@end
