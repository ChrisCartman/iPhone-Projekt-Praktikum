//
//  Player.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "PokerGame.h"

@implementation Player

@synthesize hand;
@synthesize playerState;
@synthesize nextPlayerInRound;
@synthesize previousPlayerInRound;
@synthesize dealer;
@synthesize smallBlind;
@synthesize bigBlind;
@synthesize playerOnLeftSide;
@synthesize playerOnRightSide;
@synthesize chips;
@synthesize pokerGame;
@synthesize alreadyBetChips;
@synthesize counter;
@synthesize isYou;
@synthesize identification;
@synthesize isAllIn;
@synthesize hasSidePot;
@synthesize sidePot;
@synthesize countdownTimer;
@synthesize chipsWon;
@synthesize showsCards;
@synthesize mayShowCards;
@synthesize doesNotWinAnything;


- (id)init
{
    if (self = [super init]) {
        hand = [[Hand alloc] init];
        playerState = SET_UP;
        chips = 0;
        alreadyBetChips = 0;
        identification = [[NSString alloc] init];
        self.isYou = NO;
        self.isAllIn = NO;
        self.hasSidePot = NO;
        self.chipsWon = 0;
        self.showsCards = NO;
        self.mayShowCards = NO;
        self.doesNotWinAnything = NO;
    }
    return self;
}

- (void) resetPlayerForNewRound
{
    [self.hand resetHandForNewRound];
    self.nextPlayerInRound = self.playerOnLeftSide;
    self.previousPlayerInRound = self.playerOnRightSide;
    self.dealer = NO;
    self.smallBlind = NO;
    self.bigBlind = NO;
    self.alreadyBetChips = 0;
    self.isAllIn = NO;
    self.hasSidePot = NO;
    self.sidePot = nil;
    self.showsCards = NO;
    self.mayShowCards = NO;
    self.doesNotWinAnything = NO;
}

- (void) check
{
    [self stopCountdown:countdownTimer];
    [pokerGame takeCheckFromPlayer:self];
    //self.playerState = CONFIRM_BET;
}

- (void) call
{
    [self stopCountdown:countdownTimer];
    if (self.chips > pokerGame.highestBet) {
        [pokerGame takeCallFromPlayer:self];
    }
    else {
        [pokerGame takeAllInFromPlayer:self asBlind:NO];
    }
}

- (void) fold
{
    [self stopCountdown:countdownTimer];
    [pokerGame takeFoldFromPlayer:self];
    /*
    //Wenn der Startspieler folded: nächster in der Runde wird Startspieler
    if (self == self.pokerGame.firstInRound) {
        self.pokerGame.firstInRound = self.pokerGame.firstInRound.nextPlayerInRound;
    }
    previousPlayerInRound.nextPlayerInRound = self.nextPlayerInRound;
    nextPlayerInRound.previousPlayerInRound = self.previousPlayerInRound;
    [pokerGame.remainingPlayersInRound removeObject:self];
    [hand.cardsOnHand removeAllObjects];
    playerState = FOLDED; */
}

- (void) bet: (float) amount asBlind:(BOOL)isBlind
{
    [self stopCountdown:countdownTimer];
    [pokerGame takeBetAmount:amount fromPlayer:self asBlind:isBlind];
    /*
    self.chips -= (amount - alreadyBetChips);
    pokerGame.chipsInPot += (amount - alreadyBetChips);
    pokerGame.highestBet = amount;
    self.alreadyBetChips = pokerGame.highestBet;
    pokerGame.playerWhoBetMost = self;
    self.playerState = CONFIRM_BET; */
}

- (void) allIn: (float) amount asBlind:(BOOL)isBlind
{
    [self stopCountdown:countdownTimer];
    [pokerGame takeAllInFromPlayer:self asBlind:isBlind];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"playerState"]) {
        Player* aPlayer = (Player* ) object;
        PlayerState newPlayerState = aPlayer.playerState;
        if (newPlayerState == ACTIVE) {
            [self prepareMove];
        }
    }
}

- (void) startCountdown
{
    counter = 20;
    self.countdownTimer = [[NSTimer alloc] init];
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(advanceTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void) prepareMove
{
    [self startCountdown];
}

- (void) startMove
{

}

- (void)advanceTimer:(NSTimer *)timer
{
    [self setCounter:(counter -1)];
    if (isYou == NO) {
        if (counter == 19) {
            [self makeRandomBet];
        }
    }
    
    if (counter == 0) { 
        if (pokerGame.highestBet - alreadyBetChips == 0) [self check];
        else [self fold];
    }
}

- (void) stopCountdown:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
}

// Test-Funktionen: (später löschen)

- (void) makeRandomBet
{
    int n = (arc4random() % 10);
    if (n==1) {
        if (pokerGame.highestBet - alreadyBetChips > 0) {
            [self fold];
        }
        else {
            [self check];
        }
    }
    else if (n==9 || n==8) {
        [self bet:(pokerGame.highestBet+10.0) asBlind:NO];
    }
    else {
        if (pokerGame.highestBet - alreadyBetChips > 0) {
            [self call];
        }
        else {
            [self check];
        }
    }
}

- (BOOL) hasBetterCardsThan:(Player *)aPlayer
{
    if (self.hand.fiveBestCards.valueOfFiveBestCards > aPlayer.hand.fiveBestCards.valueOfFiveBestCards) {
        return YES;
    }
    else if (self.hand.fiveBestCards.valueOfFiveBestCards < aPlayer.hand.fiveBestCards.valueOfFiveBestCards) {
        return NO;
    }
    // Bei Gleichheit einzelne Karten überprüfen. Die Karten sind automatisch nach der Güte sortiert, das heißt: Karten können einzeln überprüft werden:
    else {
        for (int k=0;k<=4;k++) {
            PlayingCard* card1 = (PlayingCard* ) [self.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:k];
            PlayingCard* card2 = (PlayingCard* ) [aPlayer.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:k];
            if (card1.value > card2.value) {
                return YES;
            }
            else if (card1.value < card2.value) {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL) hasEqualCardsAs:(Player *)aPlayer
{
    if (self.hand.fiveBestCards.valueOfFiveBestCards > aPlayer.hand.fiveBestCards.valueOfFiveBestCards) {
        return NO;
    }
    else if (self.hand.fiveBestCards.valueOfFiveBestCards < aPlayer.hand.fiveBestCards.valueOfFiveBestCards) {
        return NO;
    }
    // Bei Gleichheit einzelne Karten überprüfen. Die Karten sind automatisch nach der Güte sortiert, das heißt: Karten können einzeln überprüft werden:
    else {
        for (int k=0;k<=4;k++) {
            PlayingCard* card1 = (PlayingCard* ) [self.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:k];
            PlayingCard* card2 = (PlayingCard* ) [aPlayer.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:k];
            if (card1.value > card2.value) {
                return NO;
            }
            else if (card1.value < card2.value) {
                return NO;
            }
        }
    }
    return YES;
}

- (void) mayShowCardsNow
{
    self.doesNotWinAnything = YES;
    self.mayShowCards = YES;
}

- (void) showCards
{
    [pokerGame.playersWhoHaveShownCards addObject:self];
    self.showsCards = YES;
}



@end
