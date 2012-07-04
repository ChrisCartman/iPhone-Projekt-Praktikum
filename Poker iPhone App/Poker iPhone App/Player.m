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
@synthesize showDownCard1Frame;
@synthesize showDownCard2Frame;
@synthesize playerProfile;

//KI
@synthesize outs;
@synthesize cardOddFlopIsHigher;
@synthesize cardOddTurnIsHigher;
@synthesize cardOddRiverIsHigher;  
@synthesize pot;
//@synthesize cardOddsIsHigher;
@synthesize cardOdds;
@synthesize cardValues;
@synthesize valueOfHighestPair;
@synthesize preFlopDict;
@synthesize cardPairSuit;
@synthesize cardPairKey;



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
    if (self.chips + self.alreadyBetChips > pokerGame.highestBet) {
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
    if (n==11) { //(n==9 || n==8) {
        if (pokerGame.highestBet - alreadyBetChips > 0) {
            [self fold];
        }
        else {
            [self check];
        }
    }
    else if ([self.identification isEqualToString:@"player2"]) { //(n==7 || n==6) {
        if (pokerGame.highestBet >= self.chips + self.alreadyBetChips) {
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


- (void) preparePreFlop{

    NSMutableArray* temporaryArray = [[NSMutableArray alloc] init];
    //k=1 suited, k=2 offsuited
    
    for (int k=1; k<=2; k++) {
       for (int j=2; j<=14; j++) {
           for (int i=2; i<=14; i++) {
        [temporaryArray addObject:[NSString stringWithFormat:@"%i_%i_%i",i,j,k]];
           }
       }
   }
    
    [temporaryArray addObject:[NSString stringWithFormat:@"1_1_1"]];
    NSArray* cardPairsArray = [NSArray arrayWithArray:temporaryArray];
    
    NSString *one = @"1"; 
    NSString *two = @"2";
    NSString *three = @"3";
    NSString *four = @"4";
    NSString *five = @"5";
    NSString *six = @"6";
    NSString *seven = @"7";
    NSString *eight = @"8";
    
    
   

    NSArray *bucketsArray = [NSArray arrayWithObjects: 
                        //k=1, j=2, i läuft von 2-14
                        seven, eight, eight, eight, seven, eight, eight, eight, seven,eight, seven, seven, five,
                        //k=1, j=3
                        eight, seven, seven, eight, seven, eight, eight, eight, seven, eight, seven, seven, five,
                        //k=1, j=4
                        eight, seven, seven, six, seven, eight, eight, eight, seven, eight, seven, seven, five,
                        //k=1, j=5
                        eight, eight, six, six, five, seven, eight, eight, seven,eight, seven, seven, five,
                        //k=1, j=6
                        seven, seven, seven, five, six, five, six, eight, seven, eight, seven, seven, five,
                        //k=1, j=7
                        eight, eight, eight, seven, five, five, five, five, seven, eight, seven, seven, five,
                        //k=1, j=8
                        eight, eight, eight, eight, six, five, four, four, five, six, seven, seven, five,
                        //k=1, j=9
                        eight, eight, eight, eight, eight, five, four, three, four, four, five, six, five,
                        //k=1, j=10
                        seven, seven, seven, seven, seven, seven, five, four, two, three, four, four, three,
                        //k=1, j=11
                        eight, eight, eight, eight, eight, eight, six, four, three, one, three, three, two,
                        //k=1, j=12
                        seven, seven, seven, seven, seven, seven, seven, five, four, three, one, two, two,
                        //k=1, j=13
                        seven, seven, seven, seven, seven, seven, seven, six, four, three, two, one, one,
                        //k=1, j=14
                        five, five, five, five, five, five, five, five, three, two, two, one, one,
                        //k=2, j=2
                        seven, seven, seven, seven, seven, seven, seven, seven, seven, seven, seven, seven, seven,
                        //k=2, j=3
                        seven, seven, seven, seven, seven, seven, seven, seven, seven, seven, seven, seven, seven,
                        //k=2, j=4
                        seven, seven, seven, eight, eight, eight, eight, eight, eight, eight, eight, eight, 
                        //k=2, j=5
                        seven, seven, eight, six, eight, eight, eight, eight, eight, eight, eight, eight, eight, 
                        //k=2, j=6
                        seven, seven, eight, eight, six, eight, eight, eight, eight, eight, eight, eight, eight, 
                        //k=2, j=7
                        seven, seven, eight, eight, eight, five, eight, eight, eight, eight, eight, eight, eight,
                        //k=2, j=8
                        seven, seven, eight, eight, eight, eight, four, seven, eight, eight, eight, eight, eight,
                        //k=2, j=9
                        seven, seven, eight, eight, eight, eight, seven,three, seven, seven, eight, eight, eight, 
                        //k=2, j=10
                        seven, seven, eight, eight, eight, eight, eight, seven, two, five, six, six, six,
                        //k=2, j=11
                        seven, seven, eight, eight, eight, eight, eight, seven, five, one, five, five, four,
                        //k=2, j=12
                        seven, seven, eight, eight, eight, eight, eight, eight, six, five, one, four, three,
                        //k=2, j=13
                        seven, seven, eight, eight, eight, eight, eight, eight, eight, six, five, four, one, two,
                        //k=2, j=14
                        seven, seven, eight, eight, eight, eight, eight, eight, eight, six, four, three, two, one,nil];
                        
            
    preFlopDict = [NSDictionary dictionaryWithObjects: bucketsArray forKeys: cardPairsArray];
    
    
     //Der aktuellen Hand soll der Key zugewiesen werden
    PlayingCard *card1 = [self.hand.cardsOnHand objectAtIndex:0];
    PlayingCard *card2 = [self.hand.cardsOnHand objectAtIndex:1];
    
   if (card1.suitType == card2.suitType) {cardPairSuit = 1;} 
   else {cardPairSuit = 2;};
    cardPairKey = [NSString stringWithFormat:@"%i_%i_%i", card1.value, card2.value,cardPairSuit];  
    


}





- (BOOL) expectPair{
    
    if (cardValues == HIGH_CARD){return YES;}
    else {return NO;};
}


- (BOOL) expectThreeOfAKind{
    if(cardValues == ONE_PAIR){return YES;}
    else {return NO;};
}


- (BOOL) expectFlush{
    
    //Karten Tisch+Hand
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:self.pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    allCards = [self.hand.cardValuesEvaluator sortCards_Suits:allCards];
    
    //zum Testen:
//    NSMutableArray *allCards = [[NSMutableArray alloc]init];
//    PlayingCard *card1 = [[PlayingCard alloc]init];
//    PlayingCard *card2 = [[PlayingCard alloc]init];
//    PlayingCard *card3 = [[PlayingCard alloc]init];
//    PlayingCard *card4 = [[PlayingCard alloc]init];
//    PlayingCard *card5 = [[PlayingCard alloc]init];
//    
//    card1.value = 2;
//    card1.suitType = DIAMONDS;
//    card2.value = 5;
//    card1.suitType = HEARTS;
//    card3.value = 6;
//    card3.suitType = HEARTS;
//    card4.value = 7;
//    card4.suitType = HEARTS;
//    card5.value = 8;
//    card5.suitType = HEARTS;
//    
//    [allCards addObject: card1];
//    [allCards addObject: card2];
//    [allCards addObject: card3];
//    [allCards addObject: card4];
//    [allCards addObject: card5];

        //erste Karte
        PlayingCard* currentPlayingCard = (PlayingCard* ) [allCards objectAtIndex:0];
        SuitType suitTypeCurrentPlayingCard = currentPlayingCard.suitType;
        int countOfThisSuitType = 1;
        
        
        
        for (int i=1; i<[allCards count]; i++) {
            if (countOfThisSuitType==4) {
                return YES;
            }
            int j = [allCards count] - i; // Anzahl noch nicht gepruefter Elemente
            
            if (countOfThisSuitType + j < 4) {
                return NO;}
            else {
                //jeweils nächste Karte
                PlayingCard* nextPlayingCard = (PlayingCard* ) [allCards objectAtIndex:i];
                SuitType suitTypeOfNextPlayingCard = nextPlayingCard.suitType;
                
                //wenn die Karten gleiche Farbe haben, erhöhe Zähler
                if (suitTypeOfNextPlayingCard == suitTypeCurrentPlayingCard) {
                    countOfThisSuitType += 1;}
            }       
        
        };    
            
        
        
        return NO;
                    
                
        
        
}


- (BOOL) expectOpenStraight{
    
    //Karten Tisch+Hand
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:self.pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    
    allCards = [self.hand.cardValuesEvaluator sortCards_Values:allCards];
    
    
    //zum Testen:
//    NSMutableArray *allCards = [[NSMutableArray alloc]init];
//    PlayingCard *card1 = [[PlayingCard alloc]init];
//    PlayingCard *card2 = [[PlayingCard alloc]init];
//    PlayingCard *card3 = [[PlayingCard alloc]init];
//    PlayingCard *card4 = [[PlayingCard alloc]init];
//    PlayingCard *card5 = [[PlayingCard alloc]init];
//    
//    card1.value = 2;
//    card1.suitType = HEARTS;
//    card2.value = 5;
//    card1.suitType = DIAMONDS;
//    card3.value = 6;
//    card3.suitType = HEARTS;
//    card4.value = 7;
//    card4.suitType = HEARTS;
//    card5.value = 8;
//    card5.suitType = HEARTS;
//    
//    [allCards addObject: card1];
//    [allCards addObject: card2];
//    [allCards addObject: card3];
//    [allCards addObject: card4];
//    [allCards addObject: card5];

    
    //Erwartung openStraight bei vier aufeinander folgenden Karten 
    
    //erstes Element im Array:
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCards objectAtIndex:0];   
    int lastValueInStraight = currentPlayingCard.value;
    int countOfStraightedElements = 1;
    
    
    
    for (int i=1; i<[allCards count]; i++) {
        
        if (countOfStraightedElements==4) {
            return YES;
        };
        //Die nächsten Karten werden ebenfalls einem Objekt zugewiesen und erhalten eine Value Variable
            PlayingCard* nextPlayingCard = (PlayingCard* ) [allCards objectAtIndex:i];
            int nextValueInArray = nextPlayingCard.value;
            
            
            //wenn die nächste Karte nun die richtige aufeinderfolgende ist, bekommt sie die var lastValueinStraight
            if (nextValueInArray == lastValueInStraight + 1) {
                lastValueInStraight = nextValueInArray;
                countOfStraightedElements += 1;
            }
            // wenn die nächste Karte gleich ist, wird die aktuelle herausgelöscht
            else if (nextValueInArray == lastValueInStraight) {
            [allCards removeObjectAtIndex:i];
            i -= 1;
            }
            //wenn die nächste Karte weiter als +1 weg liegt, muss die aktuelle und alle vorherigen gelöscht werden
            else {  for (int j=0; j<i; j++){
                    [allCards removeObjectAtIndex:0];
                    }
                PlayingCard *newFirstPlayingCard = (PlayingCard*) [allCards objectAtIndex:0];
                lastValueInStraight = newFirstPlayingCard.value;
                countOfStraightedElements =1;
                i -= 1;
            }
    };
        
    
    //Bei vier aufeinanderfolgenden Karten wird yes zurückgegeben    
    if (countOfStraightedElements==4) {
                return YES;
    } 
    else {return NO;};
    
}    
    
       








- (BOOL) expectGutshot{}

- (BOOL) expectDoubleGutshot{}

- (BOOL) expectFlushAndGutshot{}

- (BOOL) expectFlushAndOpenStraight{
    
    

}



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
    
    if([self expectFlushAndOpenStraight]){return 15;}
        else if([self expectFlushAndGutshot]){return 12;}
        else if([self expectFlush]){return 9;}
        else if([self expectOpenStraight]){return 8;}
        else if([self expectDoubleGutshot]){return 8;}
        else if([self expectPair]){return 6;}
        else if([self expectGutshot]){return 4;}
        else if([self expectThreeOfAKind]){return 2;}
        
    return 0;
    
    
    
}

- (void) calculateCardOdds{
    
    
    
    //Wahrscheinlichkeiten, seine Karten durch einen Turn, River zu verbessern     
    
    outs = [self calculateOuts];
    cardOddsTurn = outs/47;
    cardOddsRiver = outs/46;
    
    
    
    
    
}



- (void) calculatePotOdds{
    potOdds = pokerGame.highestBet/pot.chipsInPot;
}


- (void) compareOdds{
    
    if (cardOddsTurn >= potOdds){cardOddsTurnIsHigher =YES;};
    if (cardOddsRiver >= potOdds){cardOddsRiverIsHigher =YES;};
   
    
}

- (void) makeBet{
    [self preparePreFlop];
    [self calculateCardOdds];
    [self calculatePotOdds];
    [self compareOdds];
    [self handStrength];
    
    if (pokerGame.gameState == PRE_FLOP){
        NSString *bucketString = [preFlopDict objectForKey:cardPairKey];
        int bucket = [bucketString intValue];
        if (bucket <=3){
            
            [self bet:pokerGame.highestBet +10 asBlind:NO];
        } 
        else if (bucket >3 && bucket<=7){
            [self call];
        }
    
        else if (bucket >7){
            if (self.alreadyBetChips == pokerGame.highestBet) {
                [self check];
            }
            else {
                [self fold];
            }
        }
    }
    
    else {
    switch (cardValues) {
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
            //if (cardValues==ONE_PAIR && self.valueOfHighestPair>=10){[self call];}else 
            if (pokerGame.gameState == FLOP &&  cardOddsTurnIsHigher ==YES){[self call];}
            else if (pokerGame.gameState == TURN &&  cardOddsRiverIsHigher == YES){[self call];}
            else if (pokerGame.gameState == RIVER && cardOddsRiverIsHigher == YES){[self call];}
            else {[self fold];};
            break;
    }
    
    
    }
    
    
    
}




@end
