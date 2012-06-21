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



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
   
}

@property (strong, nonatomic) UIWindow *window;





- (NSMutableString* ) kartenBezeichnung: (PlayingCard* ) playingCard;
- (NSMutableString* ) makeStringOutOfValue: (CardValues) cardValues;


@end
