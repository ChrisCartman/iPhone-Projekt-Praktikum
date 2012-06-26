//
//  GameSettings.h
//  Poker iPhone App
//
//  Created by Lion User on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@interface GameSettings : NSObject{


    NSString *difficulty;
    NSString *blinds;
    int anzahlKI;
    int startChips;
    int startBlinds;
    int increaseBlindsAfter;


}
@property(nonatomic,retain) NSString *difficulty;
@property (nonatomic,retain) NSString *blinds;
@property (nonatomic,assign) int anzahlKI;
@property (nonatomic,assign) int startChips;
@property (nonatomic,assign) int startBlinds;
@property (nonatomic,assign) int increaseBlindsAfter;

- (id) initWithSettings: (GameSettings* ) settings;



@end
