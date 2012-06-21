//
//  MainPot.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 13.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pot.h"

@interface MainPot : Pot
{
    float allChipsInAllPots;
    NSMutableArray* listOfAllSidePots;
}

@property (nonatomic, assign) float allChipsInAllPots;
@property (nonatomic, retain) NSMutableArray* listOfAllSidePots;

- (void) resetMainPotForNewRound;

@end
