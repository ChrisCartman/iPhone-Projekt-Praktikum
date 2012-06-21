//
//  SidePot.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 18.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pot.h"

@interface SidePot : Pot
{
    float chipsAmountNeededFromEachPlayerToBeFilled;
    BOOL isFilled;
    NSMutableArray* playersWhoPaidInThisPot;
    BOOL isDrained;
    float maxChips;
}

@property (nonatomic, assign) float chipsAmountNeededFromEachPlayerToBeFilled;
@property (nonatomic, assign) BOOL isFilled;
@property (nonatomic, retain) NSMutableArray* playersWhoPaidInThisPot;
@property (nonatomic, assign) BOOL isDrained;
@property (nonatomic, assign) float maxChips;

@end
