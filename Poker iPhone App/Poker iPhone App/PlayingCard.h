//
//  PlayingCard.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum_SuitType.h"

@interface PlayingCard : NSObject
{
    SuitType suitType;
    int value;
    UIImage* playingCardImage;
} 

@property (nonatomic, assign) SuitType suitType;
@property (nonatomic, assign) int value;
@property (nonatomic, retain) UIImage* playingCardImage;

- (NSComparisonResult) compareWithOtherCard: (PlayingCard* ) otherPlayingCard;

@end
