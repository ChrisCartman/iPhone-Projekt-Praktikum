//
//  ModifiedSlider.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModifiedSlider.h"

@implementation ModifiedSlider

@synthesize sensibility;
@synthesize currentBigBlind;
@synthesize dollars;
@synthesize cents;
@synthesize currentChips;
@synthesize internValue;
@synthesize currentHighestBet;
@synthesize currentAlreadyBetChips;
@synthesize lastCentValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sensibility = NO_SENSIBILITY;
    }
    return self;
}

- (void) setUpWithCurrentBigBlind:(float)bigBlind
{
    self.currentBigBlind = bigBlind;
}

- (void) getBetAmountNoSensibility
{
    float currentValue = self.value;
    //keine Sensibilitätsunterscheidung bei all in
    if (currentValue == self.maximumValue) {
        self.internValue = currentValue;
        self.dollars = (int) self.internValue;
        self.cents = self.internValue - self.dollars;
    }
    //falls man zum big blind setzen all in gehen muss: bei mehr als der Hälfte all in
    else if (currentValue < currentBigBlind && self.maximumValue < currentBigBlind) {
        if (currentValue >= (self.maximumValue + self.minimumValue) / 2.0) {
            self.internValue = self.maximumValue;
            self.dollars = (int) self.internValue;
            self.cents = self.internValue - self.dollars;
        }
        else {
            self.internValue = self.minimumValue;
            self.dollars = (int) self.internValue;
            self.cents = self.internValue - self.dollars;
        }
    }
    else if (currentValue < currentBigBlind) {
        if (currentValue >= (currentBigBlind + self.minimumValue) / 2.0) {
            self.internValue = self.currentBigBlind;
            self.dollars = (int) self.internValue;
            self.cents = self.internValue - self.dollars;
        }
        else {
            self.internValue = self.minimumValue;
            self.dollars = (int) self.internValue;
            self.cents = self.internValue - self.dollars;
        }
    }
    else if (currentValue < self.minimumValue + currentBigBlind / 2.0) {
        self.dollars = self.currentBigBlind;
        if (self.lastCentValue != self.cents) {
            self.cents = self.lastCentValue;
        }
    }
    else if (currentValue >= self.minimumValue + currentBigBlind / 2.0 && currentValue <= self.minimumValue + currentBigBlind) {
        self.dollars = (int) self.minimumValue + currentBigBlind;
        if (self.lastCentValue != self.cents) {
            self.cents = self.lastCentValue;
        }
    }
    else {
        self.dollars = (int) currentValue;
        if (self.lastCentValue != self.cents) {
            self.cents = self.lastCentValue;
        }
    }
}

- (void)getBetAmountStrongSensibility
{
    float currentValue = self.value;
    self.cents = (float) (((int) (currentValue * 100)) / 100.0);
    self.lastCentValue = self.cents;
}

- (float) getSliderValue
{
    if (!(self.dollars + self.cents == self.internValue)) {
        self.internValue = self.dollars + self.cents;
    }
    return self.internValue;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
