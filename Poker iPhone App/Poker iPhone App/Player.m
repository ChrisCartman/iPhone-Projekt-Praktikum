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

@synthesize hasAlreadyBluffed;



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
        self.hasAlreadyBluffed = NO;
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
    self.hasAlreadyBluffed = NO;
}

- (void) check
{
    [self stopCountdown:countdownTimer];
    [pokerGame takeCheckFromPlayer:self];
    //self.playerState = CONFIRM_BET;
}

- (void) call
{
    if (pokerGame.highestBet - self.alreadyBetChips == 0) {
        [self check];
    }
    else {
        [self stopCountdown:countdownTimer];
        if (self.chips + self.alreadyBetChips > pokerGame.highestBet) {
            [pokerGame takeCallFromPlayer:self];
        }
        else {
            [pokerGame takeAllInFromPlayer:self asBlind:NO];
        }
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
    if (amount == 0) {
        [self check];
    }
    else if (amount == pokerGame.highestBet) {
        [self call];
    }
    else {
        if (!isBlind) {
            [self stopCountdown:countdownTimer];
        }
        [pokerGame takeBetAmount:amount fromPlayer:self asBlind:isBlind];
    }
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
            if ([pokerGame.gameSettings.difficulty isEqualToString:@"schwer"]) {
                [self makeBet];
            }
            else {
                [self makeRandomBet];
            }
        }
    }
    
    if (self.counter < 0) { 
        if (pokerGame.highestBet - alreadyBetChips == 0) [self check];
        else [self fold];
    }
}

- (void) stopCountdown:(NSTimer *)timer
{
    if ([currentlyRunningTimersWithCreationTimes containsObject:timer]) {
        int index = [currentlyRunningTimersWithCreationTimes indexOfObject:timer];
        for (int i=1;i<=2;i++) {
            [self.currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index];
        }
    }
    [timer invalidate];
    timer = nil;
}

// Test-Funktionen: (später löschen)

- (void) makeRandomBet
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
    
       








- (BOOL) expectGutshot
{
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    
    //zum testen: 
    //    NSMutableArray* allCards = [[NSMutableArray alloc] init];
    //    PlayingCard* card1 = [[PlayingCard alloc] init];
    //    card1.value = 2;
    //    PlayingCard* card2 = [[PlayingCard alloc] init];
    //    card2.value = 5;
    //    PlayingCard* card3 = [[PlayingCard alloc] init];
    //    card3.value = 13;
    //    PlayingCard* card4 = [[PlayingCard alloc] init];
    //    card4.value = 11;    
    //    PlayingCard* card5 = [[PlayingCard alloc] init];
    //    card5.value = 5;
    //    PlayingCard* card6 = [[PlayingCard alloc] init];
    //    card6.value = 6;
    //    
    //    [allCards addObject:card1];
    //    [allCards addObject:card2];
    //    [allCards addObject:card3];
    //    [allCards addObject:card4];
    //    [allCards addObject:card5];
    //    [allCards addObject:card6];
    
    //falls ein Ass enthalten ist: füge eine imaginäre Karte mit dem Wert1 hinzu:
    for (PlayingCard* aPlayingCard in allCards) {
        if (aPlayingCard.value == 14) {
            PlayingCard* imaginaryPlayingCard = [[PlayingCard alloc] init];
            imaginaryPlayingCard.value = 1;    
            [allCards addObject:imaginaryPlayingCard];
            break;
        }
    }
    
    //sortiere das Array
    allCards = [self.hand.cardValuesEvaluator sortCards_Values:allCards];
    
    //Es gibt drei verschiedene Fälle für dieses Problem:
    /* x: Loch, o: brauchbare Karte:
     die drei Fälle sind dann: (1) o x o o o, (2) o o x o o, (3) o o o x o */
    //beginne mit einem Vergleich der ersten beiden Karten im sortierten Array:
    //Idee: speichere je in einer Variablen, welcher Fall gerade betrachtet wird und in einer wieviele passende Karten schon gefunden wurden: dies sollten idealerweise 4 sein:
    int gutshotCase = 0; //0 bedeutet keiner der Fälle wird gerade besonders in Betracht gezogen
    int countOfFittingCards = 1; // eine passende Karte hat man immer
    
    PlayingCard* lastPlayingCard = [allCards objectAtIndex:0];
    int valueOfLastPlayingCard = lastPlayingCard.value;
    
    
    int index = 0;
    while (countOfFittingCards < 4) {
        //falls nicht mehr genug Karten übrig sind um einen Gutshotfall zu vervollständigen: NO
        index++;
        if ([allCards count] - index + countOfFittingCards < 4) {
            return NO;
        }
        PlayingCard* currentPlayingCard = [allCards objectAtIndex:index];
        if (currentPlayingCard.value == valueOfLastPlayingCard) {
            lastPlayingCard = currentPlayingCard;
            valueOfLastPlayingCard = lastPlayingCard.value;
            continue;
        }
        // noch kein gutshotCase gewählt, d.h. countOfFittingCards == 1:
        if (gutshotCase == 0) {
            //Fall (2) oder Fall (3) ?
            if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                gutshotCase = 2;
                countOfFittingCards += 1;
            }
            // Fall (1) ?
            else if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                gutshotCase = 1;
                countOfFittingCards += 1;
            }
        }
        else if (gutshotCase == 1) {
            if (countOfFittingCards >= 2) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //weitermachen:
                    countOfFittingCards += 1;
                }
                else if (!(currentPlayingCard.value == valueOfLastPlayingCard + 2)) {
                    //wieder von vorne anfangen
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
        }
        else if (gutshotCase == 2) {
            if (countOfFittingCards == 2) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //switch zu Fall (3)
                    countOfFittingCards += 1;
                    gutshotCase = 3;
                }
                else if (currentPlayingCard.value = valueOfLastPlayingCard + 2) {
                    //weitermachen
                    countOfFittingCards += 1;
                }
                else {
                    //wieder von vorne anfangen
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
            else if (countOfFittingCards == 3) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //fall 2 vollständig!
                    countOfFittingCards += 1;
                }
                else if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                    //switch zu fall (1)
                    gutshotCase = 1;
                    countOfFittingCards = 2;
                }
                else {
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
        }
        else {
            if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                countOfFittingCards += 1;
            }
            else {
                gutshotCase = 0;
                countOfFittingCards = 1;
            }
        }
        // falls keiner der Fälle zutrifft, werden nur die folgenden Zeilen ausgeführt:
        lastPlayingCard = currentPlayingCard;
        valueOfLastPlayingCard = lastPlayingCard.value;
        
    }
    return YES;
}

- (BOOL) expectDoubleGutshot
{
    //Idee: die Methode expectGutshot findet immer den 1. möglichen gutshot.
    //falls es mehrere gibt, so haben diese mit Sicherheit mit den vorderen Karten (vor der Lücke) des 1. Gutshots nichts zu tun, diese können also entfernt werden und danach kann einfach nochmals überprüft werden, ob ein gutshot da war:
    
    //Kopiere also zunächst den code der Funktion gutshot
    
    NSMutableArray* allCards = [[NSMutableArray alloc] initWithArray:pokerGame.cardsOnTable.allCards];
    [allCards addObjectsFromArray:self.hand.cardsOnHand];
    
    
    //zum testen: 
    //    NSMutableArray* allCards = [[NSMutableArray alloc] init];
    //    PlayingCard* card1 = [[PlayingCard alloc] init];
    //    card1.value = 2;
    //    PlayingCard* card2 = [[PlayingCard alloc] init];
    //    card2.value = 3;
    //    PlayingCard* card3 = [[PlayingCard alloc] init];
    //    card3.value = 4;
    //    PlayingCard* card4 = [[PlayingCard alloc] init];
    //    card4.value = 6;    
    //    PlayingCard* card5 = [[PlayingCard alloc] init];
    //    card5.value = 7;
    //    PlayingCard* card6 = [[PlayingCard alloc] init];
    //    card6.value = 8;
    //        
    //    [allCards addObject:card1];
    //    [allCards addObject:card2];
    //    [allCards addObject:card3];
    //    [allCards addObject:card4];
    //    [allCards addObject:card5];
    //    [allCards addObject:card6];
    
    //falls ein Ass enthalten ist: füge eine imaginäre Karte mit dem Wert1 hinzu:
    for (PlayingCard* aPlayingCard in allCards) {
        if (aPlayingCard.value == 14) {
            PlayingCard* imaginaryPlayingCard = [[PlayingCard alloc] init];
            imaginaryPlayingCard.value = 1;    
            [allCards addObject:imaginaryPlayingCard];
            break;
        }
    }
    
    //sortiere das Array
    allCards = [self.hand.cardValuesEvaluator sortCards_Values:allCards];
    
    //Es gibt drei verschiedene Fälle für dieses Problem:
    /* x: Loch, o: brauchbare Karte:
     die drei Fälle sind dann: (1) o x o o o, (2) o o x o o, (3) o o o x o */
    //beginne mit einem Vergleich der ersten beiden Karten im sortierten Array:
    //Idee: speichere je in einer Variablen, welcher Fall gerade betrachtet wird und in einer wieviele passende Karten schon gefunden wurden: dies sollten idealerweise 4 sein:
    int gutshotCase = 0; //0 bedeutet keiner der Fälle wird gerade besonders in Betracht gezogen
    int countOfFittingCards = 1; // eine passende Karte hat man immer
    
    PlayingCard* lastPlayingCard = [allCards objectAtIndex:0];
    int valueOfLastPlayingCard = lastPlayingCard.value;
    
    int index = 0;
    while (countOfFittingCards < 4) {
        //falls nicht mehr genug Karten übrig sind um einen Gutshotfall zu vervollständigen: NO
        index++;
        if ([allCards count] - index + countOfFittingCards < 4) {
            return NO;
        }
        PlayingCard* currentPlayingCard = [allCards objectAtIndex:index];
        if (currentPlayingCard.value == valueOfLastPlayingCard) {
            lastPlayingCard = currentPlayingCard;
            valueOfLastPlayingCard = lastPlayingCard.value;
            continue;
        }
        // noch kein gutshotCase gewählt, d.h. countOfFittingCards == 1:
        if (gutshotCase == 0) {
            //Fall (2) oder Fall (3) ?
            if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                gutshotCase = 2;
                countOfFittingCards += 1;
            }
            // Fall (1) ?
            else if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                gutshotCase = 1;
                countOfFittingCards += 1;
            }
        }
        else if (gutshotCase == 1) {
            if (countOfFittingCards >= 2) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //weitermachen:
                    countOfFittingCards += 1;
                }
                else if (!(currentPlayingCard.value == valueOfLastPlayingCard + 2)) {
                    //wieder von vorne anfangen
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
        }
        else if (gutshotCase == 2) {
            if (countOfFittingCards == 2) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //switch zu Fall (3)
                    countOfFittingCards += 1;
                    gutshotCase = 3;
                }
                else if (currentPlayingCard.value = valueOfLastPlayingCard + 2) {
                    //weitermachen
                    countOfFittingCards += 1;
                }
                else {
                    //wieder von vorne anfangen
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
            else if (countOfFittingCards == 3) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //fall 2 vollständig!
                    countOfFittingCards += 1;
                }
                else if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                    //switch zu fall (1)
                    gutshotCase = 1;
                    countOfFittingCards = 2;
                }
                else {
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
        }
        else {
            if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                countOfFittingCards += 1;
            }
            else {
                gutshotCase = 0;
                countOfFittingCards = 1;
            }
        }
        // falls keiner der Fälle zutrifft, werden nur die folgenden Zeilen ausgeführt:
        lastPlayingCard = currentPlayingCard;
        valueOfLastPlayingCard = lastPlayingCard.value;
        
    }
    
    //wenn die Methode hier ankommt wurde ein gutshot gefunden:
    
    //welcher der drei Fälle war es?
    if (gutshotCase == 1) {
        //Fall 1: lösche die erste Karte der vier gutshot-Karten (sowie falls sie doppelt vorhanden ist auch die anderen gleich Werts), sowie alle Karten die kleiner sind:
        while (true) {
            PlayingCard* aPlayingCard = [allCards objectAtIndex:0];
            if (aPlayingCard.value > valueOfLastPlayingCard - 3) {
                break;
            }
            else {
                [allCards removeObjectAtIndex:0];
            }
        }
    }
    else if (gutshotCase == 2) {
        //Fall 2: analog zu oben, jetzt werden die ersten beiden Karten aus dem gutshot gelöscht
        while (true) {
            PlayingCard* aPlayingCard = [allCards objectAtIndex:0];
            if (aPlayingCard.value > valueOfLastPlayingCard - 2) {
                break;
            }
            else {
                [allCards removeObjectAtIndex:0];
            }
        }
    }
    else {
        //Fall 3: hier müssten 3 Karten gelöscht werden, dann sind aber noch maximal 3 Karten übrig, also kein gutshot mehr möglich:
        return NO;
    }
    
    //unnötige Karten für den zweiten gutShot wurden entfernt: jetzt kann der ganze Algorithmus von oben einfach noch einmal durchgeführt werden:
    
    // einfach nochmal hineinkopiert:
    gutshotCase = 0; //0 bedeutet keiner der Fälle wird gerade besonders in Betracht gezogen
    countOfFittingCards = 1; // eine passende Karte hat man immer
    
    lastPlayingCard = [allCards objectAtIndex:0];
    valueOfLastPlayingCard = lastPlayingCard.value;
    
    index = 0;
    while (countOfFittingCards < 4) {
        //falls nicht mehr genug Karten übrig sind um einen Gutshotfall zu vervollständigen: NO
        index++;
        if ([allCards count] - index + countOfFittingCards < 4) {
            return NO;
        }
        PlayingCard* currentPlayingCard = [allCards objectAtIndex:index];
        if (currentPlayingCard.value == valueOfLastPlayingCard) {
            lastPlayingCard = currentPlayingCard;
            valueOfLastPlayingCard = lastPlayingCard.value;
            continue;
        }
        // noch kein gutshotCase gewählt, d.h. countOfFittingCards == 1:
        if (gutshotCase == 0) {
            //Fall (2) oder Fall (3) ?
            if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                gutshotCase = 2;
                countOfFittingCards += 1;
            }
            // Fall (1) ?
            else if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                gutshotCase = 1;
                countOfFittingCards += 1;
            }
        }
        else if (gutshotCase == 1) {
            if (countOfFittingCards >= 2) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //weitermachen:
                    countOfFittingCards += 1;
                }
                else if (!(currentPlayingCard.value == valueOfLastPlayingCard + 2)) {
                    //wieder von vorne anfangen
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
        }
        else if (gutshotCase == 2) {
            if (countOfFittingCards == 2) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //switch zu Fall (3)
                    countOfFittingCards += 1;
                    gutshotCase = 3;
                }
                else if (currentPlayingCard.value = valueOfLastPlayingCard + 2) {
                    //weitermachen
                    countOfFittingCards += 1;
                }
                else {
                    //wieder von vorne anfangen
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
            else if (countOfFittingCards == 3) {
                if (currentPlayingCard.value == valueOfLastPlayingCard + 1) {
                    //fall 2 vollständig!
                    countOfFittingCards += 1;
                }
                else if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                    //switch zu fall (1)
                    gutshotCase = 1;
                    countOfFittingCards = 2;
                }
                else {
                    countOfFittingCards = 1;
                    gutshotCase = 0;
                }
            }
        }
        else {
            if (currentPlayingCard.value == valueOfLastPlayingCard + 2) {
                countOfFittingCards += 1;
            }
            else {
                gutshotCase = 0;
                countOfFittingCards = 1;
            }
        }
        // falls keiner der Fälle zutrifft, werden nur die folgenden Zeilen ausgeführt:
        lastPlayingCard = currentPlayingCard;
        valueOfLastPlayingCard = lastPlayingCard.value;
        
    }
    //wenn die Methode hier ankommt, liegt tatsächlich ein doubleGutshot vor:
    return YES;
    
}


- (BOOL) expectFlushAndGutshot
{
    return ([self expectGutshot] && [self expectFlush]);
}

- (BOOL) expectFlushAndOpenStraight
{
    return ([self expectOpenStraight] && [self expectFlush]);
}

- (CardValues) bla
{
    if (true) {
        
        return FLUSH;
        
    }
    else if (true) {
        
        return STRAIGHT_FLUSH;
        
    }
    else if (true) {
        
        return STRAIGHT;
        
    }
    else if (true) {
        
        return THREE_OF_A_KIND;
        
    }
    else if (true) {
        
        return HIGH_CARD;
        
    }
    else if (true) {
        
        return ONE_PAIR;
        
    }
    else if (true) {
        
        return TWO_PAIRS;
        
    }
    else if (true) {
        
        return ROYAL_FLUSH;
        
    }
    else if (true) {
        
        return FULL_HOUSE;
        
    }
    else if (true) {
        
        return FOUR_OF_A_KIND;
        
    }
    
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
    int potChips = pokerGame.mainPot.chipsInPot;
    for (Player* aPlayer in pokerGame.allPlayers) {
        potChips += aPlayer.alreadyBetChips;
    }
    potOdds = pokerGame.highestBet/potChips;
}


- (void) compareOdds{
    
    if (cardOddsTurn >= potOdds){cardOddsTurnIsHigher =YES;};
    if (cardOddsRiver >= potOdds){cardOddsRiverIsHigher =YES;};
   
    
}

- (void) makeBetDecision:(int)maxBet betProbabilityParameter:(int)betParameter foldProbabilityParamter:(int)foldParameter callEverything:(BOOL)callsEverything
{
    int sum = betParameter + foldParameter;
    int randomNumber = arc4random() % sum;
    int potChips = pokerGame.mainPot.chipsInPot;
    for (Player* aPlayer in pokerGame.allPlayers) {
        potChips += aPlayer.alreadyBetChips;
    }
    // falls es gute Karten sind: checke zu einer Wahrscheinlichkeit von 1/3:
    if (foldParameter == 0 && pokerGame.highestBet == 0) {
        int randomNumberForCheck = arc4random() % 3;
        if (randomNumberForCheck == 0) {
            [self check];
            return;
        }
    }
    
    // dieser Fall ist genau betParameter / sum
    if (randomNumber < betParameter) {
        if (pokerGame.highestBet - self.alreadyBetChips >= maxBet) {
            if (callsEverything) {
                [self call];
            }
            else {
                [self makeBluffDecision:potChips];
            }
        }
        else {
            int betAmount;
            if (pokerGame.highestBet + pokerGame.smallBlind*2 < maxBet) {
                betAmount = pokerGame.highestBet + pokerGame.smallBlind*2 + (arc4random() % (int)(maxBet - 2*pokerGame.smallBlind - pokerGame.highestBet));
            }
            else {
                betAmount = 2*pokerGame.smallBlind;
            }
            if (pokerGame.highestBet - self.alreadyBetChips > betAmount) {
                if (callsEverything) {
                    [self call];
                }
                else {
                    [self makeBluffDecision:potChips];
                }
            }
            else {
                [self bet:betAmount asBlind:NO];
            }
        }
    }
    else {
        [self makeBluffDecision:potChips];
    }    
}

- (void) makeBluffDecision: (float) potChips
{
    /* Überlegungen zur Bluff-Entscheidung:
     - die Bluff-Entscheidung soll von verschiedenen Parametern abhängen:
        => 1. Zufall (für die Unberechenbarkeit)
        => 2. Anzahl Spieler aus ihm, die noch in der Runde sind
        => 3. Chips der Spieler, die noch mit ihm in der Runde sind
        => 4. Gewinnrate der Spieler, die noch mit ihm in der Runde sind (eine größere Win-Rate als 1/maxPlayers bedeutet, dass dieser Spieler evtl. dazu neight zu bluffen)
        => 5. eigene Chips
        => bereits gesetztes Geld
        => wurde bereits in der BetRound vorher geblufft? => weiterbluffen?
     
        Idee: fuere einen Wahrscheinlichkeitsparameter ein, der bei günstigen oder ungünstigen Bedingungen, die Entscheidung für oder gegen einen Bluff beeinflussen
     */
    float probabilityToBluff;
    int minBet;
    int maxBet;
    //beginne mit der GrundeinStellung 1/Anzahl Spieler:
    probabilityToBluff = 1.0 / [pokerGame.remainingPlayersInRound count];
    
    //Verhältnis der eigenen Chips zu den Chips der Gegner:
    NSMutableArray* remainingPlayersSorted = [NSMutableArray arrayWithArray:pokerGame.remainingPlayersInRound];
    [remainingPlayersSorted sortedArrayUsingComparator:^(Player* player1, Player* player2) {
        if (player1.chips < player2.chips) return NSOrderedAscending;
        else if (player1.chips > player2.chips) return NSOrderedDescending;
        else {
            return NSOrderedSame;
        }
    }];
    if ([remainingPlayersSorted indexOfObject:self] >= [remainingPlayersSorted count] / 2.0) {
        probabilityToBluff *= 1.5;
    }
    else {
        probabilityToBluff *= 2.0/3.0;
    }
    
    //Gewinnraten der Spieler, die noch dabei sind (neigen sie zum bluffen?)
    for (Player* aPlayer in remainingPlayersSorted) {
        float quotient = [self playerHasWonMoreThanAverage:aPlayer];
        if (quotient == 5.0) {
            probabilityToBluff *= (1+4.0*pokerGame.roundsPlayed/10.0);
        }
        else if (quotient >= 4.0) {
            probabilityToBluff *= (1+3.0*pokerGame.roundsPlayed/10.0);
        }
        else if (quotient >= 3.0) {
            probabilityToBluff *= (1+2.0*pokerGame.roundsPlayed/10.0);
        }
        else if (quotient >= 2.0) {
            probabilityToBluff *= (1+pokerGame.roundsPlayed/10.0);
        }
        else if (quotient >= 1.5) {
            probabilityToBluff *= (1+0.3*pokerGame.roundsPlayed/10.0);
        }
    }
    
    //wurde bereits in der Runde vorher geblufft?
    if (hasAlreadyBluffed) {
        probabilityToBluff *= 2.0;
    }
    
    float estimatedBetChips = potChips / (([pokerGame.allPlayers count] + [remainingPlayersSorted count]) / 2.0);
    
    if (estimatedBetChips / self.chips >= 1) {
        probabilityToBluff *= 1.5;
    }
    else if (estimatedBetChips / self.chips >= 0.75) {
        probabilityToBluff *= 1.3;
    }
    else if (estimatedBetChips /  self.chips >= 0.5) {
        probabilityToBluff *= 1.1;
    }
    else {
        probabilityToBluff *= (0.5 + (estimatedBetChips / self.chips));
    }
    
    if (probabilityToBluff >= 1) {
        minBet = (1+probabilityToBluff*pokerGame.smallBlind*2);
    }
    else {
        minBet = pokerGame.smallBlind*2;
    }
    maxBet = self.chips / 5.0;
    
    if (probabilityToBluff >= 1) probabilityToBluff = 1;
    
    int probTimesHundred = probabilityToBluff * 100;
    int randomNumber = arc4random() % 100;
    int betAmount;
    if (randomNumber < probTimesHundred) {
        betAmount = minBet + arc4random() % (maxBet - minBet);
        if (betAmount >= pokerGame.highestBet + 2*pokerGame.smallBlind) {
            [self bet:betAmount asBlind:NO];
        }
        else {
            [self call];
        }
    }
    else {
        if (self.alreadyBetChips - pokerGame.highestBet == 0) {
            [self check];
        }
        else {
            [self fold];
        }
    }
}

- (void) makeBet
{
    [self preparePreFlop];
    [self calculateCardOdds];
    [self calculatePotOdds];
    [self compareOdds];
    [self handStrength];
    
    if (pokerGame.gameState == PRE_FLOP){
        NSString *bucketString = [preFlopDict objectForKey:cardPairKey];
        int bucket = [bucketString intValue];
        if (bucket == 1) {
            int maxBet = self.chips / 8;
            [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
        }
        else if (bucket == 2) {
            int maxBet = self.chips / 12;
            [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];   
        }
        else if (bucket == 3) {
            int maxBet = self.chips / 15;
            [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
        }
        else if (bucket == 4) {
            int maxBet = self.chips / 15;
            [self makeBetDecision:maxBet betProbabilityParameter:4 foldProbabilityParamter:1 callEverything:YES];
        }
        else if (bucket == 5) {
            int maxBet = self.chips / 20;
            [self makeBetDecision:maxBet betProbabilityParameter:3 foldProbabilityParamter:1 callEverything:NO];
        }
        else if (bucket == 6) {
            int maxBet = self.chips / 25;
            [self makeBetDecision:maxBet betProbabilityParameter:2 foldProbabilityParamter:1 callEverything:NO];
        }
        else if (bucket == 7) {
            int maxBet = self.chips / 30;
            [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:1 callEverything:NO];
        }
        else {
            int maxBet = self.chips / 40;
            [self makeBetDecision:maxBet betProbabilityParameter:3 foldProbabilityParamter:5 callEverything:NO];
        }
    }
    else {
        CardValuesEvaluator* cardValuesEvaluatorForTableCards = [[CardValuesEvaluator alloc] init];
        [cardValuesEvaluatorForTableCards defineValueOfFiveBestCards:pokerGame.cardsOnTable.allCards];
        if (cardValues == cardValuesEvaluatorForTableCards.fiveBestCards.valueOfFiveBestCards) {
            //berechne Outs
            //if (cardValues==ONE_PAIR && self.valueOfHighestPair>=10){[self call];}else 
            if (pokerGame.gameState == FLOP &&  cardOddsTurnIsHigher ==YES){[self call];}
            else if (pokerGame.gameState == TURN &&  cardOddsRiverIsHigher == YES){[self call];}
            else {
                if (pokerGame.highestBet == 0) {
                    [self check];
                }
                else {
                    int potChips = pokerGame.mainPot.chipsInPot;
                    for (Player* aPlayer in pokerGame.allPlayers) {
                        potChips += aPlayer.alreadyBetChips;
                    }
                    [self makeBluffDecision:potChips];
                }
            }
        }
        else {
            switch (cardValues) {
                case TWO_PAIRS: {
                    int maxBet = self.chips / 10;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:NO];
                }
                    break;
                case THREE_OF_A_KIND: {
                    int maxBet = self.chips / 6;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case FLUSH: {
                    int maxBet = self.chips / 4;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case STRAIGHT: {
                    int maxBet = self.chips / 5;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case FULL_HOUSE: {
                    int maxBet = self.chips / 2;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case FOUR_OF_A_KIND: {
                    int maxBet = self.chips;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case STRAIGHT_FLUSH: {
                    int maxBet = self.chips;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case ROYAL_FLUSH: {
                    int maxBet = self.chips;
                    [self makeBetDecision:maxBet betProbabilityParameter:1 foldProbabilityParamter:0 callEverything:YES];
                }
                    break;
                case ONE_PAIR: {
                    //Wert der höchsten Karte berechnen:
                    int maxBet = self.chips / 40;
                    [self makeBetDecision:maxBet betProbabilityParameter:self.valueOfHighestPair foldProbabilityParamter:14 - self.valueOfHighestPair callEverything:NO];   
                }
                    break;
                default: {
                    //if (cardValues==ONE_PAIR && self.valueOfHighestPair>=10){[self call];}else 
                    if (pokerGame.gameState == FLOP &&  cardOddsTurnIsHigher ==YES){[self call];}
                    else if (pokerGame.gameState == TURN &&  cardOddsRiverIsHigher == YES){[self call];}
                    else {
                        if (pokerGame.highestBet == 0) {
                            [self check];
                        }
                        else {
                            int potChips = pokerGame.mainPot.chipsInPot;
                            for (Player* aPlayer in pokerGame.allPlayers) {
                                potChips += aPlayer.alreadyBetChips;
                            }
                            [self makeBluffDecision:potChips];
                        }
                    }
                }
                    break;
            }
        }
    
    }
}


- (float) playerHasWonMoreThanAverage:(Player *)aPlayer
{
    float wins;
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        wins = [(NSNumber* ) [pokerGame.gameStatistics objectAtIndex:0] floatValue];
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        wins = [(NSNumber* ) [pokerGame.gameStatistics objectAtIndex:1] floatValue];
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        wins = [(NSNumber* ) [pokerGame.gameStatistics objectAtIndex:2] floatValue];
    }    
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        wins = [(NSNumber* ) [pokerGame.gameStatistics objectAtIndex:3] floatValue];
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        wins = [(NSNumber* ) [pokerGame.gameStatistics objectAtIndex:4] floatValue];
    }
    return ((wins / pokerGame.roundsPlayed) / (1.0 / pokerGame.maxPlayers));
}


@end
