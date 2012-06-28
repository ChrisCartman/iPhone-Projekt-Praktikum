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
@synthesize startDragPoint;
@synthesize startDragValue;
@synthesize internValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sensibility = MEDIUM_SENSIBILITY;
    }
    return self;
}

- (void) setUpWithCurrentBigBlind:(float)bigBlind
{
    self.currentBigBlind = bigBlind;
}

- (float) roundSliderValue
{
    float currentValue = internValue;
    //keine Sensibilitätsunterscheidung bei all in
    if (currentValue == self.maximumValue) {
        return currentValue;
    }
    //falls man zum big blind setzen all in gehen muss: bei mehr als der Hälfte all in
    else if (currentValue < currentBigBlind && self.maximumValue < currentBigBlind) {
        if (currentValue >= (self.maximumValue + self.minimumValue) / 2.0) {
            return self.maximumValue;
        }
        else {
            return self.minimumValue;
        }
    }
    else if (currentValue < currentBigBlind) {
        if (currentValue >= (currentBigBlind + self.minimumValue) / 2.0) {
            return currentBigBlind;
        }
        else {
            return self.minimumValue;
        }
    }
    else {
        if (self.sensibility == STRONG_SENSIBILITY) {
            return internValue;
        }
        else if (self.sensibility == MEDIUM_SENSIBILITY) {
            float decimalsOnly = (float) self.value - (int) self.value;
            if (decimalsOnly==0.0) {
                return internValue;
            }
            else if (decimalsOnly>=0.5) {
                return (int) (internValue + 1);
            }
            else {
                return (int) internValue;
            }
        }
        else if (self.sensibility == NO_SENSIBILITY) {
            int counter = 0;
            while (counter*currentBigBlind <= self.value) {
                counter++;
            }
            if (counter*currentBigBlind - self.value >= currentBigBlind / 2.0) {
                return counter*currentBigBlind;
            }
            else {
                return (counter-1)*currentBigBlind;
            }
        }
    }
    return 0.0;
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
