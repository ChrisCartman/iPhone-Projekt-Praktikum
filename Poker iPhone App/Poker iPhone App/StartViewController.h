//
//  StartViewController.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface StartViewController : ViewController{}

@property (nonatomic, retain) UISegmentedControl *singlePlayerButton;
@property (nonatomic, retain) UISegmentedControl *profilButton;

- (void)singlePlayerButtonPressed;
- (void)viewDidLoad;

@end
