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
@synthesize currentlyRunningTimersWithCreationTimes;
@synthesize paused;
@synthesize createdTimerDuringPause;
@synthesize throwsCardsAway;

//KI
@synthesize outs;
@synthesize cardOddFlopIsHigher;
@synthesize cardOddTurnIsHigher;
@synthesize cardOddRiverIsHigher;  
@synthesize pot;
//@synthesize cardOddsIsHigher;
@synthesize cardOdds;
@synthesize cardValues;



- (id)init
{
    if (self = [super init]) {
        hand = [[Hand alloc] init];
        playerState = SET_UP;
        chips = 0;
        alreadyBetChips = 0;
        identification = [[NSString alloc] init];
        currentlyRunningTimersWithCreationTimes = [[NSMutableArray alloc] init];
        self.isYou = NO;
        self.isAllIn = NO;
        self.hasSidePot = NO;
        self.chipsWon = 0;
        self.showsCards = NO;
        self.throwsCardsAway = NO;
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
    self.throwsCardsAway = NO;
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
    if (!isBlind) {
        [self stopCountdown:countdownTimer];
    }
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
    self.counter = 20;
    self.countdownTimer = [[NSTimer alloc] init];
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(advanceTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
    NSArray* temporaryArray = [NSArray arrayWithObjects:countdownTimer, [NSDate date], nil];
    [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
    if (paused) {
        self.createdTimerDuringPause = YES;
    }
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
        if (self.counter == 19) {
            [self makeBet];
        }
    }
    
    if (self.counter < 0) { 
        if (pokerGame.highestBet - alreadyBetChips == 0) [self check];
        else [self fold];
    }
}

- (void) stopCountdown:(NSTimer *)timer
{
    [timer invalidate];
    int index = [currentlyRunningTimersWithCreationTimes indexOfObject:timer];
    for (int i=1;i<=2;i++) {
        [self.currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index];
     }
    timer = nil;
}

// Test-Funktionen: (später löschen)

/*- (void) makeRandomBet
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
        if (pokerGame.highestBet >= self.chips) {
            [self call];
        }
        else {
            [self bet:(pokerGame.highestBet+10.0) asBlind:NO];
        }
    }
    else {
        if (pokerGame.highestBet - alreadyBetChips > 0) {
            [self call];
        }
        else {
            [self check];
        }
    }
}*/

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
    if ([pokerGame.remainingPlayersInRound count] > 1) {
        self.doesNotWinAnything = YES;
    }
    self.mayShowCards = YES;
}

- (void) showCards: (BOOL) required
{
    if (required) {
        [pokerGame.playersWhoHaveShownCards addObject:self];
    }
    self.showsCards = YES;
}

- (void) changePlayerState:(NSNumber *)playerStateAsObject
{
    //da diese Funktion mit Delay aufgerufen werden soll, muss ein Objekt übergeben werden... deswegen wird zunächst NSNumber wieder in ein PlayerState umgewandelt:
    PlayerState newPlayerState = [playerStateAsObject intValue];
    self.playerState = newPlayerState;
}


#pragma mark - KI Methoden

- (void) handStrength
{
    //Berechne zunächst cardValues
    [self.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    self.cardValues = self.hand.fiveBestCards.valueOfFiveBestCards;
    
    //Beim Paar ermittle den Wert des Paares
    if (self.cardValues == ONE_PAIR || self.cardValues == TWO_PAIRS) {
        PlayingCard* playingCard = [self.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:0];
        int valueOfPair = playingCard.value;
        self.valueOfHighestPair = valueOfPair;
    }
    
    
    
}

- (int) calculateOuts{
    
    
    if([self expectFlush]){return 9;};
    
    
}

- (void) calculateCardOdds{
    
   
    
    //Wahrscheinlichkeiten, seine Karten durch einen Turn, River zu verbessern und die Wahrscheinlichkeit seine Karten nach dem Flop zu verbessern (also Turn oder River)
    outs = [self calculateOuts];
    cardOddsFlop = 1-((47-outs)/47 * (46-outs)/46);
    cardOddsTurn = outs/47;
    cardOddsRiver = outs/46;
    
    
    
    //cardOddsIsHigher = (2*outs+1)/100;
    
}

- (void) calculatePotOdds{
    potOdds = pokerGame.highestBet/pot.chipsInPot;
}

- (BOOL) expectFlush{
    
    //Karten Tisch+Hand
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:self.pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    allCards = [self.hand.cardValuesEvaluator sortCards_Suits:allCards];
    
    
    //Erwartung Flush bei 4 Karten gleicher Farbe
    if ([allCards count] <5) {return NO;}
    else {    
        //erste Karte
        PlayingCard* currentPlayingCard = (PlayingCard* ) [allCards objectAtIndex:0];
        SuitType suitTypeCurrentPlayingCard = currentPlayingCard.suitType;
        int countOfThisSuitType = 1;
        
        
        
        for (int i=1; i<[allCards count]; i++) {
            int j = [allCards count] - i; // Anzahl noch nicht gepruefter Elemente
            
            if (countOfThisSuitType + j < 4) {
                return NO;}
            else {
                //jeweils nächste Karte
                PlayingCard* nextPlayingCard = (PlayingCard* ) [allCards objectAtIndex:i];
                SuitType suitTypeOfNextPlayingCard = nextPlayingCard.suitType;
                
                //Vergleich
                if (suitTypeOfNextPlayingCard == suitTypeCurrentPlayingCard) {
                    countOfThisSuitType += 1;
                    
                    if (countOfThisSuitType==4) {
                        return YES;
                        }
                
                }}}}}



- (BOOL) expectOpenStraight{
    
    //Karten Tisch+Hand
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:self.pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    
    allCards = [self.hand.cardValuesEvaluator sortCards_Values:allCards];
    
    //Erwartung openStraight bei vier aufeinander folgenden Karten 
    
    //erstes Element im Array:
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCards objectAtIndex:0];   
    int lastValueInStraight = currentPlayingCard.value;
    int countOfStraightedElements = 1;
    
    
    
    
    //Beginne Vergleiche:
    for (int i=1; i<[allCards count]; i++) {
        int j = [allCards count] - i; // Anzahl noch nicht gepruefter Elemente
        if (countOfStraightedElements + j < 4) {
            return NO;}
        else {PlayingCard* nextPlayingCard = (PlayingCard* ) [allCards objectAtIndex:i];
            int nextValueInArray = nextPlayingCard.value;
            
            // gleiche können ignoriert werden:
            if (nextValueInArray == lastValueInStraight) {
                [allCards removeObjectAtIndex:i];
                i -= 1;}
            
            //aufeinadnerfolgende:
            else if (nextValueInArray == lastValueInStraight + 1) {
                lastValueInStraight = nextValueInArray;
                countOfStraightedElements += 1;}
            if (countOfStraightedElements==4) {
                return YES; }
            //outs = 8
        }
        
    }
    
    
}       

- (BOOL) expectGutshot{
    
    
    //Karten Tisch+Hand
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:self.pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    //Karten nach Wert sortieren
    allCards = [self.hand.cardValuesEvaluator sortCards_Values:allCards];
    
    //erstes Element im Array
    PlayingCard *currentPlayingCard = (PlayingCard *) [allCards objectAtIndex:0];
    int lastValueInStraight = currentPlayingCard.value;
    int countOfStraightedElements = 1;
    
    //Fall 1: fehlende Karte liegt "rechts außen", d.h drei Karten in Folge - Lücke - Karte
    
    for (int i=1; i<[allCards count]; i++){
        PlayingCard* nextPlayingCard = (PlayingCard* ) [allCards objectAtIndex:i];
        int nextValueInArray = nextPlayingCard.value;
        
        if (nextValueInArray == lastValueInStraight + 1){
            lastValueInStraight = nextValueInArray;
            countOfStraightedElements += 1;}
        
        
        
        
        
    }
    
    
    
    
    
    
}

- (BOOL) expectDoubleGutshot{
    
}




- (void) compareOdds{
    if (cardOddsFlop >= potOdds){cardOddsFlopIsHigher =YES;};
    if (cardOddsTurn >= potOdds){cardOddsTurnIsHigher =YES;};
    if (cardOddsRiver >= potOdds){cardOddsRiverIsHigher =YES;};
    //if (cardOdds >= potOdds){cardOddsIsHigher = YES;};
    
}

- (void) makeBet{
    
    [self calculateCardOdds];
    [self calculatePotOdds];
    [self compareOdds];
    

    [self handStrength];
    
    
    
    switch (cardValues) {
        case ONE_PAIR:
            [self call];
            break;
        case TWO_PAIRS:
            [self call];
            break;
        case THREE_OF_A_KIND:
            [self call];
            break;
        case FLUSH:
            [self call];
            break;
        case STRAIGHT:
            [self call];
            break;
        case FULL_HOUSE:
            [self call];
            break;
        case FOUR_OF_A_KIND:
            [self call];
            break;
        default:
            if(pokerGame.gameState == PRE_FLOP){[self call];}
            else if (pokerGame.gameState == FLOP && cardOddsFlopIsHigher ==YES){[self call];}
            else if (pokerGame.gameState == TURN && cardOddsTurnIsHigher == YES){[self call];}
            else if (pokerGame.gameState == RIVER && cardOddsRiverIsHigher == YES){[self call];}
            else {[self fold];};
            break;
    }
    
    
    
    
    
    
}




@end
