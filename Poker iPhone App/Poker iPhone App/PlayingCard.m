//
//  PlayingCard.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayingCard.h"
#import "AppDelegate.h"

@implementation PlayingCard

@synthesize value;
@synthesize suitType;
@synthesize playingCardImage;

- (NSComparisonResult) compareWithOtherCard:(PlayingCard *)otherPlayingCard
{
    if (self.value == otherPlayingCard.value)
    {
        return (NSComparisonResult) NSOrderedSame;
    }
    else if (self.value < otherPlayingCard.value)
    {
        return (NSComparisonResult) NSOrderedAscending;
    }
    return NSOrderedDescending;
}


@end