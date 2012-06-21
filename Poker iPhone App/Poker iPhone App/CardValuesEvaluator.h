//
//  CardValuesEvaluator.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "Enum_CardValues.h"
#import "FiveBestCards.h"

@interface CardValuesEvaluator : NSObject
{
    FiveBestCards* fiveBestCards;
    BOOL flush;
    BOOL straight;
    BOOL four_of_a_kind;
    BOOL three_of_a_kind;
    BOOL one_pair;
}

@property (nonatomic, retain) FiveBestCards* fiveBestCards;

- (void) defineValueOfFiveBestCards: (NSMutableArray* ) allCards;
- (NSMutableArray* ) isFlush: (NSMutableArray* ) allCards;
- (NSMutableArray* ) isStraight: (NSMutableArray* ) allCards;
- (NSMutableArray* ) isFourOfAKind: (NSMutableArray* ) allCards;
- (NSMutableArray* ) isThreeOfAKind: (NSMutableArray* ) allCards;
- (NSMutableArray* ) isOnePair: (NSMutableArray* ) allCards;
- (NSMutableArray* ) sortCards_Values: (NSMutableArray* ) allCards;
- (NSMutableArray* ) sortCards_Suits: (NSMutableArray* ) allCards;

@end
