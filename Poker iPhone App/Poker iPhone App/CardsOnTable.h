//
//  CardsOnTable.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "CardDeck.h"

@interface CardsOnTable : NSObject
{
    NSMutableArray* flop;
    PlayingCard* turn;
    PlayingCard* river;
    NSMutableArray* allCards;
}

@property (nonatomic, retain) NSMutableArray* flop;
@property (nonatomic, retain) PlayingCard* turn;
@property (nonatomic, retain) PlayingCard* river;
@property (nonatomic, retain) NSMutableArray* allCards;

- (void) resetCardsOnTableForNewRound;

@end
