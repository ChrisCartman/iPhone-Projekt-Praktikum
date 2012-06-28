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
    CGPoint startDragPoint;
    float startDragValue;
    float internValue;
}

@property (nonatomic, assign) SliderSensibility sensibility;
@property (nonatomic, assign) float currentBigBlind;
@property (nonatomic, assign) CGPoint startDragPoint;
@property (nonatomic, assign) float startDragValue;
@property (nonatomic, assign) float internValue;

- (void) setUpWithCurrentBigBlind: (float) bigBlind;

- (float) roundSliderValue;

@end
