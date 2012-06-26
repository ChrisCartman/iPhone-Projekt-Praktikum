//
//  Pot.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 12.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pot.h"

@implementation Pot

@synthesize chipsInPot;

- (id) init
{
    if (self = [super init]) {
        self.chipsInPot = 0;
    }
    return self;
}

@end
