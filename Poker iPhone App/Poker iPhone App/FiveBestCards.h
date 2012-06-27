//
//  FiveBestCards.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "Enum_CardValues.h"

@interface FiveBestCards : NSObject
{
    NSMutableArray* arrayOfFiveBestCards;
    CardValues valueOfFiveBestCards;
    NSString* cardValuesAsString;
}

@property (nonatomic, retain) NSMutableArray* arrayOfFiveBestCards;
@property (nonatomic, assign) CardValues valueOfFiveBestCards;
@property (nonatomic, retain) NSString* cardValuesAsString;

- (void) resetFiveBestCardsForNewRound;


@end
