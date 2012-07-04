//
//  Hand.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "Enum_CardValues.h"
#import "CardsOnTable.h"
#import "CardValuesEvaluator.h"
#import "FiveBestCards.h"

@interface Hand : NSObject
{
    NSMutableArray* cardsOnHand;
    CardValues valueOfCardsWithTableCards;
    PlayingCard* kicker;
    float chanceToWinGame;
    CardValuesEvaluator* cardValuesEvaluator;
    FiveBestCards* fiveBestCards;
}

@property (nonatomic, retain) NSMutableArray* cardsOnHand;
@property (nonatomic, assign) CardValues valueOfCardsWithTableCards;
@property (nonatomic, retain) PlayingCard* kicker;
@property (nonatomic, assign) float chanceToWinGame;
@property (nonatomic, retain) CardValuesEvaluator* cardValuesEvaluator;
@property (nonatomic, retain) FiveBestCards* fiveBestCards;

- (void) addCardToHand: (PlayingCard* ) playingCard;
- (void) throwHandAway;
- (void) defineValueOfCardsWithTableCards: (CardsOnTable* ) currentCardsOnTable;
- (void) resetHandForNewRound;

@end
