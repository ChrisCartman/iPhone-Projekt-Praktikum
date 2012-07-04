//
//  PlayerProfile.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerProfile : NSObject
{
    NSString* playerName;
    UIImage* playerImage;
}

@property (nonatomic, retain) NSString* playerName;
@property (nonatomic, retain) UIImage* playerImage;

- (id) initWithPlayerProfile: (PlayerProfile* ) profile;
- (id) initWithPlayerName: (NSString* ) aPlayerName playerImage:(UIImage* ) aPlayerImage;

@end
