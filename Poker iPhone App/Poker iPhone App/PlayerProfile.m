//
//  PlayerProfile.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerProfile.h"

@implementation PlayerProfile

@synthesize playerName;
@synthesize playerImage;

- (id) initWithPlayerProfile:(PlayerProfile *)profile
{
    if (self = [super init]) {
        self.playerName = profile.playerName;
        self.playerImage = profile.playerImage;
    }
    return self;
}

@end
