//
//  ModifiedSlider.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enum_SliderSensibility.h"

@interface ModifiedSlider : UISlider
{
    SliderSensibility sensibility;
    float currentBigBlind;
    float dollars;
    float cents;
    float currentChips;
    float internValue;
    float currentHighestBet;
    float currentAlreadyBetChips;
    float lastCentValue;
}

@property (nonatomic, assign) SliderSensibility sensibility;
@property (nonatomic, assign) float currentBigBlind;
@property (nonatomic, assign) float dollars;
@property (nonatomic, assign) float cents;
@property (nonatomic, assign) float currentChips;
@property (nonatomic, assign) float internValue;
@property (nonatomic, assign) float currentHighestBet;
@property (nonatomic, assign) float currentAlreadyBetChips;
@property (nonatomic, assign) float lastCentValue;

- (void) setUpWithCurrentBigBlind: (float) bigBlind;

- (void) getBetAmountNoSensibility;
- (void) getBetAmountStrongSensibility;
- (float) getSliderValue;

- (float) roundSliderValue;

@end
