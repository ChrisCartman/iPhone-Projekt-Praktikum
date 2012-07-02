//
//  AppDelegate.h
//  Poker iPhone App
//
//  Created by Lion User on 13/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enum_CardValues.h"
#import "PlayingCard.h"
#import "PlayerProfile.h"

@class GameViewController;



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PlayerProfile* playerProfile;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PlayerProfile* playerProfile;





//- (NSMutableString* ) kartenBezeichnung: (PlayingCard* ) playingCard;
//- (NSMutableString* ) makeStringOutOfValue: (CardValues) cardValues;


@end
