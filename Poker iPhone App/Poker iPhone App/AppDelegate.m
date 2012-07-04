//
//  AppDelegate.m
//  Poker iPhone App
//
//  Created by Lion User on 13/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GameViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize playerProfile;



/*- (NSMutableString* ) makeStringOutOfValue:(CardValues)cardValues
{
    if (cardValues == HIGH_CARD) return @"High Card";
    else if (cardValues == ONE_PAIR) return @"one Pair";
    else if (cardValues == TWO_PAIRS) return @"two Pairs";
    else if (cardValues == THREE_OF_A_KIND) return @"three of a Kind";
    else if (cardValues == STRAIGHT) return @"Straight";
    else if (cardValues == FLUSH) return @"Flush";
    else if (cardValues == FULL_HOUSE) return @"Full House";
    else if (cardValues == FOUR_OF_A_KIND) return @"four of a Kind";
    else if (cardValues == STRAIGHT_FLUSH) return @"straight flush";
    else if (cardValues == ROYAL_FLUSH) return @"royal flush";
}

- (NSMutableString* ) kartenBezeichnung: (PlayingCard* ) playingCard
{
    NSMutableString* string = @"";
    NSNumber* valueOfCard = [NSNumber numberWithInt:playingCard.value];
    if ([valueOfCard intValue] == 11) {
        string = [string stringByAppendingString:@"Jack"];
    }
    else if ([valueOfCard intValue] == 12) {
        string = [string stringByAppendingString:@"Queen"];
    }
    else if ([valueOfCard intValue] == 13) {
        string = [string stringByAppendingString:@"King"];
    }
    else if ([valueOfCard intValue] == 14) {
        string = [string stringByAppendingString:@"Ace"];
    }
    else {
        string = [string stringByAppendingString:[valueOfCard stringValue]];
    }
    string = [string stringByAppendingString:@" of "];
    if (playingCard.suitType == SPADES) {
        string = [string stringByAppendingString:@"Spades"];
    }
    else if (playingCard.suitType == CLUBS) {
        string = [string stringByAppendingString:@"Clubs"];
    }
    else if (playingCard.suitType == DIAMONDS) {
        string = [string stringByAppendingString:@"Diamonds"];
    }
    else {
        string = [string stringByAppendingString:@"Hearts"];
    }
    return string;
}*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (self.playerProfile == nil) {
        playerProfile = [[PlayerProfile alloc] initWithPlayerName:@"Nathan" playerImage:[UIImage imageNamed:@"Nathan.PNG"]];
    }
    
  

    

    
    
    // Override point for customization after application launch.
    /*PokerGame* pokerGame = [[PokerGame alloc] init];
    [pokerGame startGame];
    Player* player = [pokerGame.allPlayers objectAtIndex:0];
    PlayingCard* handCard1 = [[PlayingCard alloc] init];
    PlayingCard* handCard2 = [[PlayingCard alloc] init];
    handCard1.value = 11;
    handCard1.suitType = HEARTS;
    handCard2.value = 6;
    handCard2.suitType = CLUBS;
    player.hand.cardsOnHand = [NSArray arrayWithObjects:handCard1, handCard2, nil];
    [pokerGame showFlop];
    [pokerGame showTurn];
    [pokerGame showRiver];
    PlayingCard* tableCard1 = [[PlayingCard alloc] init];
    PlayingCard* tableCard2 = [[PlayingCard alloc] init];
    PlayingCard* tableCard3 = [[PlayingCard alloc] init];
    PlayingCard* tableCard4 = [[PlayingCard alloc] init];
    PlayingCard* tableCard5 = [[PlayingCard alloc] init];
    
    tableCard1.value = 11;
    tableCard1.suitType = DIAMONDS;
    tableCard2.value = 10;
    tableCard2.suitType = HEARTS;
    tableCard3.value = 14;
    tableCard3.suitType = SPADES;
    tableCard4.value = 14;
    tableCard4.suitType = CLUBS;
    tableCard5.value = 13;
    tableCard5.suitType = DIAMONDS;
    
    [pokerGame.cardsOnTable.allCards removeAllObjects];
    [pokerGame.cardsOnTable.allCards addObject:tableCard1];
    [pokerGame.cardsOnTable.allCards addObject:tableCard2];
    [pokerGame.cardsOnTable.allCards addObject:tableCard3];
    [pokerGame.cardsOnTable.allCards addObject:tableCard4];
    [pokerGame.cardsOnTable.allCards addObject:tableCard5];
    
    NSMutableString* handString = @"your hand: \n";
    NSMutableString* valueString = @"value: \n";
    NSMutableString* tableString = @"cards on table: \n";
    NSMutableString* bestCardsString = @"five best cards:";
    
    handString = [handString stringByAppendingString:[self kartenBezeichnung:handCard1]];
    handString = [handString stringByAppendingString:@"\n"];
    handString = [handString stringByAppendingString:[self kartenBezeichnung:handCard2]];
    
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:tableCard1]];
    tableString = [tableString stringByAppendingString:@"\n"];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:tableCard2]];
    tableString = [tableString stringByAppendingString:@"\n"];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:tableCard3]];
    tableString = [tableString stringByAppendingString:@"\n"];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:tableCard4]];
    tableString = [tableString stringByAppendingString:@"\n"];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:tableCard5]];
    
    [player.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    CardValues values = player.hand.fiveBestCards.valueOfFiveBestCards;
    valueString = [valueString stringByAppendingString:[self makeStringOutOfValue:values]];
    
    NSMutableArray* bestCards = [[NSMutableArray alloc] initWithArray:player.hand.fiveBestCards.arrayOfFiveBestCards];
    for (int i=0; i<[bestCards count]; i++) {
        bestCardsString = [bestCardsString stringByAppendingString:@"\n"];
        bestCardsString = [bestCardsString stringByAppendingString:[self kartenBezeichnung:((PlayingCard* ) [bestCards objectAtIndex:i])]];
    }
    
    NSMutableString* message = @"";
    
    message = [message stringByAppendingString:handString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:tableString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:valueString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:bestCardsString];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Card informations" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];

    */
    
    
    /*PokerGame* pokerGame = [[PokerGame alloc] init];
    [pokerGame prepareGame];
    Player* player = [pokerGame.allPlayers objectAtIndex:0]; 
    
    NSMutableString* handString = @"your hand:";
    handString = [handString stringByAppendingString:@"\n"];
    PlayingCard* card1 = (PlayingCard* ) [player.hand.cardsOnHand objectAtIndex:0];
    PlayingCard* card2 = (PlayingCard* ) [player.hand.cardsOnHand objectAtIndex:1];
    NSMutableString* valueString = @"current Value: \n";
    [player.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    NSMutableArray* bestCards = player.hand.fiveBestCards.arrayOfFiveBestCards;
    CardValues values = player.hand.fiveBestCards.valueOfFiveBestCards;
    valueString = [valueString stringByAppendingString:[self makeStringOutOfValue:values]];
    NSMutableString* bestCardsString = @"five best cards:";
    for (int i=0; i<[bestCards count]; i++)
    {
        bestCardsString = [bestCardsString stringByAppendingString:@"\n"];
        bestCardsString = [bestCardsString stringByAppendingString:[self kartenBezeichnung:((PlayingCard* ) [bestCards objectAtIndex:i])]];
    }                                  
    NSMutableString* message = @"";
    handString = [handString stringByAppendingString:[self kartenBezeichnung:card1]];
    handString = [handString stringByAppendingString:@", "];
    handString = [handString stringByAppendingString:[self kartenBezeichnung:card2]];
    message = [message stringByAppendingString:handString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:valueString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:bestCardsString];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Card informations" message:message delegate:self cancelButtonTitle:@"show flop" otherButtonTitles:nil, nil];
    [alert show];
    
    [pokerGame showFlop];
    
    NSMutableString* tableString = @"cards on table: \n";
    PlayingCard* card3 = (PlayingCard* ) [pokerGame.cardsOnTable.allCards objectAtIndex:0];
    PlayingCard* card4 = (PlayingCard* ) [pokerGame.cardsOnTable.allCards objectAtIndex:1];
    PlayingCard* card5 = (PlayingCard* ) [pokerGame.cardsOnTable.allCards objectAtIndex:2];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:card3]];
    tableString = [tableString stringByAppendingString:@", "];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:card4]];
    tableString = [tableString stringByAppendingString:@", "];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:card5]];
    
    valueString = @"current Value: \n";
    [player.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    bestCards = player.hand.fiveBestCards.arrayOfFiveBestCards;
    values = player.hand.fiveBestCards.valueOfFiveBestCards;
    valueString = [valueString stringByAppendingString:[self makeStringOutOfValue:values]];
    bestCardsString = @"five best cards:";
    for (int i=0; i<[bestCards count]; i++)
    {
        bestCardsString = [bestCardsString stringByAppendingString:@"\n"];
        bestCardsString = [bestCardsString stringByAppendingString:[self kartenBezeichnung:((PlayingCard* ) [bestCards objectAtIndex:i])]];
    }                           
    message = @"";
    message = [message stringByAppendingString:handString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:tableString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:valueString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:bestCardsString];
    
    alert = [[UIAlertView alloc] initWithTitle:@"Card informations" message:message delegate:self cancelButtonTitle:@"show turn" otherButtonTitles:nil, nil];
    [alert show];
    
    [pokerGame showTurn];
    
    PlayingCard* card6 = (PlayingCard* ) [pokerGame.cardsOnTable.allCards objectAtIndex:3];
    tableString = [tableString stringByAppendingString:@", "];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:card6]];
    
    valueString = @"current Value: \n";
    [player.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    bestCards = player.hand.fiveBestCards.arrayOfFiveBestCards;
    values = player.hand.fiveBestCards.valueOfFiveBestCards;
    valueString = [valueString stringByAppendingString:[self makeStringOutOfValue:values]];
    bestCardsString = @"five best cards:";
    for (int i=0; i<[bestCards count]; i++)
    {
        bestCardsString = [bestCardsString stringByAppendingString:@"\n"];
        bestCardsString = [bestCardsString stringByAppendingString:[self kartenBezeichnung:((PlayingCard* ) [bestCards objectAtIndex:i])]];
    }               
    message = @"";
    message = [message stringByAppendingString:handString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:tableString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:valueString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:bestCardsString];
    
    alert = [[UIAlertView alloc] initWithTitle:@"Card informations" message:message delegate:self cancelButtonTitle:@"show river" otherButtonTitles:nil, nil];
    [alert show];
    
    [pokerGame showRiver];
    
    PlayingCard* card7 = (PlayingCard* ) [pokerGame.cardsOnTable.allCards objectAtIndex:4];
    tableString = [tableString stringByAppendingString:@", "];
    tableString = [tableString stringByAppendingString:[self kartenBezeichnung:card7]];
    
    valueString = @"current Value: \n";
    [player.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    bestCards = player.hand.fiveBestCards.arrayOfFiveBestCards;
    values = player.hand.fiveBestCards.valueOfFiveBestCards;
    valueString = [valueString stringByAppendingString:[self makeStringOutOfValue:values]];
    bestCardsString = @"five best cards:";
    for (int i=0; i<[bestCards count]; i++)
    {
        bestCardsString = [bestCardsString stringByAppendingString:@"\n"];
        bestCardsString = [bestCardsString stringByAppendingString:[self kartenBezeichnung:((PlayingCard* ) [bestCards objectAtIndex:i])]];
    }               
    
    message = @"";
    message = [message stringByAppendingString:handString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:tableString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:valueString];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:bestCardsString];
    
    alert = [[UIAlertView alloc] initWithTitle:@"Card informations" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show]; */
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if ([_window.rootViewController.presentedViewController.presentedViewController isKindOfClass:[GameViewController class]]) {
        GameViewController* gameViewController = (GameViewController* ) _window.rootViewController.presentedViewController.presentedViewController;
        gameViewController.paused = YES;
        [gameViewController showAnimationWhenGameIsPaused];
        [gameViewController pauseOrUnpause];

    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
