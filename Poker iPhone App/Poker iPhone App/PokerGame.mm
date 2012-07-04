//
//  PokerGame.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PokerGame.h"

@implementation PokerGame

@synthesize allPlayers;
@synthesize cardsOnTable;
@synthesize remainingPlayersInRound;
@synthesize cardDeck;
@synthesize activePlayer;
@synthesize smallBlind;
@synthesize highestBet;
@synthesize playerWhoBetMost;
@synthesize firstInRound;
@synthesize gameState;
@synthesize gameSettings;
@synthesize maxPlayers;
@synthesize dealer;
@synthesize playersWhoAreAllIn;
@synthesize mainPot;
@synthesize playersWhoHaveShownCards;
@synthesize showDownTimer;
@synthesize counterForTimer;
@synthesize dealOutTimer;
@synthesize tableCardsTimer;
@synthesize currentlyRunningTimersWithCreationTimes;
@synthesize paused;
@synthesize createdTimerDuringPause;
@synthesize roundsPlayed;
@synthesize blindsTimer;
@synthesize blindsCountdown;
@synthesize exactlyTwoPlayersAllIn;
@synthesize yourNumber;
@synthesize you;

- (void) dealOut
{
    Player* currentPlayer = dealer;
    //int yourNumber = maxPlayers+1;     //benötigt zur Identifizierung der Spieler mit ihren Outlets, Initialisierung mit sonst nicht erreichbaren Wert
    int numberOfPlayer;
    //finde heraus, der wievielte Spieler in der Reihe man selbst ist (der sitzt vorne)
    int counter = 1;
    int shift;
    if (yourNumber == 6) {
        while (counter <= maxPlayers) {
            currentPlayer = currentPlayer.playerOnLeftSide;
            if (currentPlayer.isYou) {
                yourNumber = counter;
                break;
            }
            counter++;
        }
    }
    
    
    
    shift = yourNumber - 1;
    numberOfPlayer = maxPlayers;
    counter = 0;
    currentPlayer = dealer;
    while (counter < 2*maxPlayers) {
        counter++; //Wiederverwendung von counter, hier soll er regeln, dass die Animationen unterschiedlich lange dauern
        currentPlayer = currentPlayer.playerOnLeftSide;
        int correctNumber;
        if (numberOfPlayer == maxPlayers) {
            numberOfPlayer = 1;
        }
        else {
            numberOfPlayer += 1;
        }
        if (numberOfPlayer - shift >= 1) {
            correctNumber = numberOfPlayer - shift;
        }
        else {
            correctNumber = maxPlayers + (numberOfPlayer - shift);
        }
        int cardNumber;
        if (counter - maxPlayers > 0) {
            cardNumber = 2;
        }
        else {
            cardNumber = 1;
        }
        //vielleicht sind einige Spieler schon nicht mehr im Spiel?
        while (![currentPlayer.identification isEqualToString:[NSString stringWithFormat:@"player%i",correctNumber]]) {
            NSLog(@"%@",currentPlayer.identification);
            if (correctNumber==5) {
                correctNumber = 1;
            }
            else {
                correctNumber++;
            }
        }
        NSString* popsFor = [NSString stringWithFormat:@"player%i_%i",correctNumber,cardNumber];
            
        NSArray* userInfo = [[NSArray alloc] initWithObjects:currentPlayer,popsFor, nil];
        dealOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.2*counter target:self selector:@selector(dealOutTimerFired:) userInfo:userInfo repeats:NO];
        NSArray* temporaryArray = [NSArray arrayWithObjects:dealOutTimer, [NSDate date], nil];
        [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
        if (paused) {
            self.createdTimerDuringPause = YES;
        }
    }
}

- (void) dealOutTimerFired:(NSTimer *)aTimer
{
    Player* currentPlayer = [aTimer.userInfo objectAtIndex:0];
    NSString* popsFor = [aTimer.userInfo objectAtIndex:1];
    PlayingCard* currentPlayingCard = [cardDeck popFor:popsFor];
    [currentPlayer.hand addCardToHand:currentPlayingCard];
    if ([currentPlayer.hand.cardsOnHand count] == 1) {
        currentPlayer.playerState = DEAL_OUT;
    }
    else {
        currentPlayer.playerState = INACTIVE;
    }
    int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
    for (int i=1;i<=2;i++) {
        [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
    }
}

- (void) resetGameForNewRound
{
    [self.cardsOnTable resetCardsOnTableForNewRound];
    self.remainingPlayersInRound = [[NSMutableArray alloc] initWithArray:allPlayers];
    [self.cardDeck resetCardDeckForNewRound];
    self.activePlayer = nil;
    [self.mainPot resetMainPotForNewRound];
    self.highestBet = 0;
    self.playerWhoBetMost = nil;
    self.gameState = SETUP;
    self.exactlyTwoPlayersAllIn = NO;
    [self.playersWhoAreAllIn removeAllObjects];
    [self.playersWhoHaveShownCards removeAllObjects];
}

- (void) showFlop
{
    for (int i=1; i<=3; i++) {
        NSString* popsFor = [NSString stringWithFormat:@"flop%i",i];
        NSNumber* numberI = [NSNumber numberWithInt:i];
        NSArray* userInfo = [NSArray arrayWithObjects:popsFor, numberI, nil];
        tableCardsTimer = [NSTimer scheduledTimerWithTimeInterval:0.2*i target:self selector:@selector(flopTimerFired:) userInfo:userInfo repeats:NO];
        NSArray* temporaryArray = [NSArray arrayWithObjects:tableCardsTimer, [NSDate date], nil];
        [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
        if (paused) {
            self.createdTimerDuringPause = YES;
        }
    }
}

- (void) flopTimerFired:(NSTimer *)aTimer
{
    NSString* popsFor = [aTimer.userInfo objectAtIndex:0];
    //NSNumber* numberI = [aTimer.userInfo objectAtIndex:1];
    PlayingCard* newPlayingCard = [cardDeck popFor:popsFor];
    [cardsOnTable.flop addObject:newPlayingCard];
    [cardsOnTable.allCards addObject:newPlayingCard];
    [self performSelector:@selector(changeGameState) withObject:nil afterDelay:0.2];
    
    int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
    for (int i=1;i<=2;i++) {
        [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
    }
}

- (void) showTurn
{
    NSString* popsFor = @"turn";
    tableCardsTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(turnTimerFired:) userInfo:popsFor repeats:NO];
    NSArray* temporaryArray = [NSArray arrayWithObjects:tableCardsTimer, [NSDate date], nil];
    [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
    if (paused) {
        self.createdTimerDuringPause = YES;
    }
}

- (void) turnTimerFired:(NSTimer *)aTimer
{
    PlayingCard* newPlayingCard = [cardDeck popFor:aTimer.userInfo];
    cardsOnTable.turn = newPlayingCard;
    [cardsOnTable.allCards addObject:newPlayingCard];
    [self performSelector:@selector(changeGameState) withObject:nil afterDelay:0.2];

    int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
    for (int i=1;i<=2;i++) {
        [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
    }
}

- (void) showRiver
{
    NSString* popsFor = @"river";
    tableCardsTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(riverTimerFired:) userInfo:popsFor repeats:NO];
    NSArray* temporaryArray = [NSArray arrayWithObjects:tableCardsTimer, [NSDate date], nil];
    [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
    if (paused) {
        self.createdTimerDuringPause = YES;
    }
}

- (void) riverTimerFired:(NSTimer *)aTimer
{
    PlayingCard* newPlayingCard = [cardDeck popFor:aTimer.userInfo];
    cardsOnTable.river = newPlayingCard;
    [cardsOnTable.allCards addObject:newPlayingCard];
    [self performSelector:@selector(changeGameState) withObject:nil afterDelay:0.2];
    
    int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
    for (int i=1;i<=2;i++) {
        [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
    }
}

- (id) init
{
    self = [super init];
    allPlayers = [[NSMutableArray alloc] init];
    remainingPlayersInRound = [[NSMutableArray alloc] init];
    currentlyRunningTimersWithCreationTimes = [[NSMutableArray alloc] init];
    cardDeck = [[CardDeck alloc] init];
    cardsOnTable = [[CardsOnTable alloc] init];
    playersWhoAreAllIn = [[NSMutableArray alloc] init];
    playersWhoHaveShownCards = [[NSMutableArray alloc] init];
    mainPot = [[MainPot alloc] init];
    self.roundsPlayed = 0;
    self.exactlyTwoPlayersAllIn = NO;
    self.yourNumber = 6;
    return self;
}

- (void) addPlayer:(Player *)aPlayer
{
    aPlayer.pokerGame = self;
    [allPlayers addObject:aPlayer];
    maxPlayers += 1;
    
    //Observer festlegen:
    [aPlayer addObserver:aPlayer forKeyPath:@"playerState" options:0 context:nil];
    [aPlayer addObserver:self forKeyPath:@"playerState" options:0 context:nil];
}

- (void) prepareGame
{
    //Reihenfolge der Spieler zufällig bestimmen:
    int nElements;
    int n;
    for (int i=1; i<maxPlayers; i++)
    {
        nElements = maxPlayers - i;
        n = (arc4random() % nElements) + i;
        [allPlayers exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    int yourIndex;
    for (Player* anyPlayer in allPlayers) {
        if (anyPlayer.isYou) {
            yourIndex = [allPlayers indexOfObject:anyPlayer];
            break;
        }
    }
    
    for (int i=0; i<maxPlayers; i++) {
        int position = i - yourIndex;
        if (position < 0) {
            position = maxPlayers + position;
        }
        Player* temporaryPlayer = (Player* ) [allPlayers objectAtIndex:position];
        temporaryPlayer.identification = [NSString stringWithFormat:@"player%i",position+1];
        if (position != 0) {
            temporaryPlayer.chips = gameSettings.startChips;
        }
        else {
            temporaryPlayer.chips = 700;
        }
        if (position==0) {
            temporaryPlayer.playerOnRightSide = (Player* ) [allPlayers objectAtIndex:(maxPlayers - 1)];
            temporaryPlayer.playerOnLeftSide = (Player* ) [allPlayers objectAtIndex:1];
        }
        else if (position==maxPlayers-1) {
            temporaryPlayer.playerOnRightSide = (Player* ) [allPlayers objectAtIndex:(maxPlayers - 2)];
            temporaryPlayer.playerOnLeftSide = (Player* ) [allPlayers objectAtIndex:0];
        }
        else {
            temporaryPlayer.playerOnLeftSide = (Player* ) [allPlayers objectAtIndex:(i+1)];
            temporaryPlayer.playerOnRightSide = (Player* ) [allPlayers objectAtIndex:(i-1)];
        }
        if (position==0) {
            temporaryPlayer.showDownCard1Frame = CGRectMake(209,201,32,44);
            temporaryPlayer.showDownCard2Frame = CGRectMake(243, 201, 32, 44);
        }
        else if (position==1) {
            temporaryPlayer.showDownCard1Frame = CGRectMake(4, 105, 32, 44);
            temporaryPlayer.showDownCard2Frame = CGRectMake(38, 105, 32, 44);
        }
        else if (position==2) {
            temporaryPlayer.showDownCard1Frame = CGRectMake(108, 20, 32, 44);
            temporaryPlayer.showDownCard2Frame = CGRectMake(142, 20, 32, 44);
        }
        else if (position==3) {
            temporaryPlayer.showDownCard1Frame = CGRectMake(300, 20, 32, 44);
            temporaryPlayer.showDownCard2Frame = CGRectMake(334, 20, 32, 44);
        }
        else if (position==4) {
            temporaryPlayer.showDownCard1Frame = CGRectMake(414, 105, 32, 44);
            temporaryPlayer.showDownCard2Frame = CGRectMake(448, 105, 32, 44);
        }
        /*player1ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(222, 203, 40, 40)];
         player2ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 107, 40, 40)];
         player3ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(121, 22, 40, 40)];
         player4ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(313, 22, 40, 40)];
         player5ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(427, 107, 40, 40)];*/
        temporaryPlayer.dealer = NO;
        temporaryPlayer.smallBlind = NO;
        temporaryPlayer.bigBlind = NO;

    }
    
    
    //Vorbereitungen für die erste Runde:
    for (Player* aPlayer in allPlayers) {
        aPlayer.nextPlayerInRound = aPlayer.playerOnLeftSide;
        aPlayer.previousPlayerInRound = aPlayer.playerOnRightSide;
    }
    self.remainingPlayersInRound = [[NSMutableArray alloc] initWithArray:allPlayers];
    
    //Blinds-Erhöhung nach Zeit?
    if ([self.gameSettings.blinds isEqualToString:@"nach Minuten"]) {
        blindsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blindsTimerFired:) userInfo:nil repeats:YES];
        self.blindsCountdown = 60*self.gameSettings.increaseBlindsAfter;
    }
    
    
    //ersten Dealer festlegen:
    n = (arc4random() % maxPlayers);
    dealer = (Player* ) [allPlayers objectAtIndex:n];
    dealer.dealer = YES;
    //sind nur zwei Spieler im Spiel, so ist der Dealer der Smallblind

    if (maxPlayers==2) {
        dealer.smallBlind = YES;
        dealer.playerOnLeftSide.bigBlind = YES;
    }
    else {
        dealer.playerOnLeftSide.smallBlind = YES;
        dealer.playerOnLeftSide.playerOnLeftSide.bigBlind = YES;
    }
    
    //Blinds setzen:
    smallBlind = gameSettings.startBlinds;
}

- (void) takeBackCardsFromPlayer:(Player *)aPlayer
{
    [aPlayer.hand.cardsOnHand removeAllObjects];
}

- (void) prepareNewRound
{
    //Spiel resetten:
    [self resetGameForNewRound];
    
    for (Player* aPlayer in allPlayers) {
        aPlayer.playerState = SET_UP;
    }
    //alle Spieler resetten:
    for (Player* aPlayer in allPlayers) {
        [aPlayer resetPlayerForNewRound];
    }
    
    //falls nur noch ein Spieler im Spiel ist: Spiel beenden:
    if ([allPlayers count] == 1) {
        [self endGame];
    }
    else {
        dealer = dealer.playerOnLeftSide;
        if (maxPlayers==2) {
            dealer.smallBlind = YES;
            dealer.playerOnLeftSide.bigBlind = YES;
        }
        else {
            dealer.playerOnLeftSide.smallBlind = YES;
            dealer.playerOnLeftSide.playerOnLeftSide.bigBlind = YES;
        }
        // Kartendeck mischen
        [cardDeck shuffle];
        // Karten ausgeben
        [self dealOut];
        //player inaktiv setzen:
    
        //Startspieler festlegen:
        firstInRound = dealer.playerOnLeftSide; //das ist der Smallblind
    
        //Blinds kassieren
        [self takeBlinds];
    }
}

- (void) takeBlinds
{
    if (dealer.playerOnLeftSide.chips > smallBlind) {
        [dealer.playerOnLeftSide bet:smallBlind asBlind:YES];
    }
    else {
        [dealer.playerOnLeftSide allIn:dealer.playerOnLeftSide.chips asBlind:YES];
    }
    if (dealer.playerOnLeftSide.playerOnLeftSide.chips > 2*smallBlind) {
        [dealer.playerOnLeftSide.playerOnLeftSide bet:(2*smallBlind) asBlind:YES];
    }
    else {
        [dealer.playerOnLeftSide.playerOnLeftSide allIn:dealer.playerOnLeftSide.playerOnLeftSide.chips asBlind:YES];
    }
}

- (void) takeBetAmount:(float)amount fromPlayer:(Player *)aPlayer asBlind:(BOOL)isBlind
{
    playerWhoBetMost = aPlayer;
    if (!isBlind) {
        PlayerState newPlayerState;
        NSNumber* playerStateAsObject;
        if (highestBet > 0 && amount > highestBet) {
            newPlayerState = RAISED;
            playerStateAsObject = [NSNumber numberWithInt:newPlayerState];
        }
        else {
            newPlayerState = BET;
            playerStateAsObject = [NSNumber numberWithInt:newPlayerState];
        }
        [aPlayer performSelector:@selector(changePlayerState:) withObject:playerStateAsObject afterDelay:0.2];
        //[aPlayer changePlayerState:playerStateAsObject];
    }
    aPlayer.chips -= (amount - aPlayer.alreadyBetChips);
    highestBet = amount;
    aPlayer.alreadyBetChips = highestBet;
}

- (void) takeCallFromPlayer:(Player *)aPlayer
{
    aPlayer.chips -= (highestBet - aPlayer.alreadyBetChips);
    //self.mainPot.chipsInPot += (highestBet - aPlayer.alreadyBetChips);
    aPlayer.alreadyBetChips = highestBet;
    PlayerState newPlayerState = CALLED;
    NSNumber* playerStateAsObject = [NSNumber numberWithInt:newPlayerState];
    [aPlayer performSelector:@selector(changePlayerState:) withObject:playerStateAsObject afterDelay:0.2];
    //[aPlayer changePlayerState:playerStateAsObject];
}

- (void) takeAllInFromPlayer:(Player* ) aPlayer asBlind:(BOOL)isBlind
{
    //SidePot erstellen:
    SidePot* sidePot = [[SidePot alloc] init];
    aPlayer.sidePot = sidePot;
    //SidePots können vollständig gefüllt sein: jeder Spieler muss so viel einzahlen, dass er voll ist:
    aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled = aPlayer.chips + aPlayer.alreadyBetChips;
    aPlayer.hasSidePot = YES;
    aPlayer.sidePot.maxChips = [remainingPlayersInRound count] * aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled;
    
    if (aPlayer.chips > highestBet) {
        highestBet = aPlayer.chips + aPlayer.alreadyBetChips;
        playerWhoBetMost = aPlayer;
    }
    
    if (aPlayer == firstInRound) {
        firstInRound = firstInRound.nextPlayerInRound;
        while (firstInRound.isAllIn) {
            if (firstInRound == aPlayer) break;
            firstInRound = firstInRound.nextPlayerInRound;
        }
    }
    
    aPlayer.alreadyBetChips += aPlayer.chips;
    aPlayer.chips = 0;
    aPlayer.isAllIn = YES;
    
    [self.mainPot.listOfAllSidePots addObject:aPlayer.sidePot];
    [aPlayer.sidePot.playersWhoPaidInThisPot addObject:aPlayer];
    
    [self.playersWhoAreAllIn addObject:aPlayer];
    [self sortPlayersWhoAreAllIn];
    if (!isBlind) {
        PlayerState newPlayerState = ALL_IN;
        NSNumber* playerStateAsObject = [NSNumber numberWithInt:newPlayerState];
        [aPlayer performSelector:@selector(changePlayerState:) withObject:playerStateAsObject afterDelay:0.2];
        //[aPlayer changePlayerState:playerStateAsObject];
    }
}

- (void) takeCheckFromPlayer:(Player *)aPlayer
{
    PlayerState newPlayerState = CHECKED;
    NSNumber* playerStateAsObject = [NSNumber numberWithInt:newPlayerState];
    [aPlayer performSelector:@selector(changePlayerState:) withObject:playerStateAsObject afterDelay:0.2];
    //[aPlayer changePlayerState:playerStateAsObject];
}

- (void) takeFoldFromPlayer:(Player *)aPlayer
{
    //Wenn der Startspieler folded: nächster in der Runde wird Startspieler
    if (aPlayer == firstInRound) {
        firstInRound = firstInRound.nextPlayerInRound;
        while (firstInRound.isAllIn) {
            if (firstInRound == aPlayer) break;
            firstInRound = firstInRound.nextPlayerInRound;
        }
    }
    //aPlayer.alreadyBetChips = 0;
    aPlayer.previousPlayerInRound.nextPlayerInRound = aPlayer.nextPlayerInRound;
    aPlayer.nextPlayerInRound.previousPlayerInRound = aPlayer.previousPlayerInRound;
    [remainingPlayersInRound removeObject:aPlayer];
    [aPlayer.hand.cardsOnHand removeAllObjects];
    PlayerState newPlayerState = FOLDED;
    NSNumber* playerStateAsObject = [NSNumber numberWithInt:newPlayerState];
    [aPlayer performSelector:@selector(changePlayerState:) withObject:playerStateAsObject afterDelay:0.2];
    //[aPlayer changePlayerState:playerStateAsObject];
}

// in dieser funktion wird die Variable PlayerState der Spieler überwacht.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"playerState"]) {
        Player* aPlayer = (Player* ) object;
        PlayerState newPlayerState = aPlayer.playerState;
        if (newPlayerState == CHECKED || newPlayerState == CALLED || newPlayerState == BET || newPlayerState == RAISED || newPlayerState == ALL_IN || newPlayerState == FOLDED) {
            [self endMoveOfPlayer:aPlayer];
        }
    }
        
}

- (void) evaluateCardValues
{
    for (Player* aPlayer in remainingPlayersInRound) {
        [aPlayer.hand defineValueOfCardsWithTableCards:self.cardsOnTable];
    }
}

//Sortiert so, dass der Spieler mit den besten Karten am Index 0 des Arrays steht.
//Danach werden alle Spieler zurückgegeben, die die besten Karten haben, im Normalfall einer, im Falle eines Splitpots mehrere:
- (NSMutableArray *) defineWinnersOfRound
{
    if ([remainingPlayersInRound count] == 1) return remainingPlayersInRound;
    [self evaluateCardValues];
    NSMutableArray* temporaryArray = [[NSMutableArray alloc] initWithArray:remainingPlayersInRound];
    Player* currentPlayer = [temporaryArray objectAtIndex:0];
    for (int i=0; i<[temporaryArray count]; i++) {
        Player* nextPlayer = [temporaryArray objectAtIndex:i];
        if (nextPlayer == currentPlayer) continue;
        //schaue zunächst nur auf den Wert der Karten: (= flush, straight, usw.)
        if (currentPlayer.hand.fiveBestCards.valueOfFiveBestCards > nextPlayer.hand.fiveBestCards.valueOfFiveBestCards) {
            [temporaryArray removeObject:nextPlayer];
            i-=1;
        }
        else if (currentPlayer.hand.fiveBestCards.valueOfFiveBestCards < nextPlayer.hand.fiveBestCards.valueOfFiveBestCards) {
            currentPlayer = nextPlayer;
            while (currentPlayer != [temporaryArray objectAtIndex:0]) {
                [temporaryArray removeObjectAtIndex:0];
            }
            i = 0; //Element entfernt, also runter mit Index
        }
        else {
        //falls der Wert der Karten gleich ist, so müssen alle Karten einzeln verglichen werden:
            for (int k=0;k<=4;k++) {
                PlayingCard* card1 = [currentPlayer.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:k];
                PlayingCard* card2 = [nextPlayer.hand.fiveBestCards.arrayOfFiveBestCards objectAtIndex:k];
                if (card1.value > card2.value) {
                    [temporaryArray removeObject:nextPlayer];
                    i-=1;
                    break;
                }
                else if (card2.value > card1.value) {
                    currentPlayer = nextPlayer;
                    while (currentPlayer != [temporaryArray objectAtIndex:0]) {
                        [temporaryArray removeObjectAtIndex:0];
                    }
                    i = 0; //Element entfernt, also runter mit Index
                    break;
                }
            }
        }
    }
    return temporaryArray;
}

- (void) endMoveOfPlayer:(Player *)aPlayer
{
    NSLog(@"%@",playerWhoBetMost.identification);
    if (aPlayer.playerState != FOLDED) {
        aPlayer.playerState = INACTIVE;
    }
    BOOL betRoundShouldBeEnded = NO;
    //Sonderfall preflop: playerWhoBetMost ist BigBlind => der darf nochmal ziehen
    if ([remainingPlayersInRound count] > 1) {
        if (gameState == PRE_FLOP && highestBet == 2*smallBlind) {
            if (activePlayer != playerWhoBetMost) {
                while (activePlayer.nextPlayerInRound.isAllIn) {
                    activePlayer = activePlayer.nextPlayerInRound;
                    if (activePlayer == playerWhoBetMost) {
                        betRoundShouldBeEnded = YES;
                        break;
                    }
                }
            }
            else {
                betRoundShouldBeEnded = YES;
            }
        }
        else {
            if (activePlayer.nextPlayerInRound != playerWhoBetMost) {
                while (activePlayer.nextPlayerInRound.isAllIn) {
                    activePlayer = activePlayer.nextPlayerInRound;
                    if (activePlayer.nextPlayerInRound == playerWhoBetMost) {
                        betRoundShouldBeEnded = YES;
                        break;
                    }
                }
            }
            else {
                betRoundShouldBeEnded = YES;
            }
        }
        if (betRoundShouldBeEnded) {
            [self endBetRound];
        }
        else {
            activePlayer = activePlayer.nextPlayerInRound;
            activePlayer.playerState = ACTIVE;
        }
    }
    else {
        [self endBetRound];
    }
}

- (void) changeGameState
{
    if (gameState == PRE_FLOP) self.gameState =  FLOP1;
    else if (gameState == FLOP1) self.gameState = FLOP2;
    else if (gameState == FLOP2) self.gameState = FLOP;
    else if (gameState == FLOP) self.gameState = TURN;
    else if (gameState == TURN) self.gameState = RIVER;
    else if (gameState == SETUP) self.gameState = PRE_FLOP;
}

- (NSMutableArray* ) sharePotAmongWinners:(NSMutableArray *)winners
{
    float divider = [winners count];
    for (Player* winner in winners) {
        NSLog(@"%@", winner.identification);
    }
    NSMutableArray* winnersCopy = [NSMutableArray arrayWithArray:winners];
    NSMutableArray* playersWhoAreAllInCopy = [NSMutableArray arrayWithArray:playersWhoAreAllIn];
    /* Vorgehensweise:
     - Die Sidepots aller Spieler die nicht zu den Gewinnern gehören werden in den nächst größeren Sidepot geschüttet
     - Gewinner mit Sidepot kriegen ihren Anteil aus dem Sidepot zurück
     - danach wird der mainPot an die verbleibenden Gewinner oder denjenigen mit den nächstbesten Karten vergeben
     */
    while (true) {
        if ([playersWhoAreAllIn count] == 0) {
            break;
        }
        while (true) {
            if ([playersWhoAreAllIn count] == 0) {
                break;
            }
            Player* playerWithSidePot = [playersWhoAreAllIn objectAtIndex:0];
            if (![winners containsObject:playerWithSidePot]) {
                if ([playersWhoAreAllIn count] != 1) {
                    Player* playerWithNextBiggerSidePot = [playersWhoAreAllIn objectAtIndex:1];
                    playerWithNextBiggerSidePot.sidePot.chipsInPot += playerWithSidePot.sidePot.chipsInPot;
                    playerWithSidePot.sidePot.chipsInPot = 0;
                }
                else {
                    self.mainPot.chipsInPot += playerWithSidePot.sidePot.chipsInPot;
                    playerWithSidePot.sidePot.chipsInPot = 0;
                }
                [playersWhoAreAllIn removeObjectAtIndex:0];
            }
            else {
                for (Player* winner in winners) {
                    int numberAsIntTimesHundred = playerWithSidePot.sidePot.chipsInPot / divider * 100;
                    float roundedNumber = numberAsIntTimesHundred / 100.0;
                    winner.chips += roundedNumber;
                }
                self.mainPot.allChipsInAllPots -= playerWithSidePot.sidePot.chipsInPot;
                playerWithSidePot.sidePot.chipsInPot = 0;
                [playersWhoAreAllIn removeObjectAtIndex:0];
                divider -= 1;
                [winners removeObject:playerWithSidePot];
                if ([winners count] == 0) {
                    //alle Gewinner schon gefunden, also kann die Schleife abgebrochen werden:
                    [playersWhoAreAllIn removeAllObjects];
                }
                break;
            }
        }
    }
    //das Array playersWhoAreAllIn wird geleert und mit den Gewinnern gefüllt, die all in sind
    /*[playersWhoAreAllIn removeAllObjects];
    for (Player* winner in winners) {
        if (winner.hasSidePot == YES) {
            [playersWhoAreAllIn addObject:winner];
        }
    }
    //sortiere das Array wieder so, dass der Spieler mit dem kleinsten sidePot vorne ist:
    [self sortPlayersWhoAreAllIn];
    //dann gehe nacheinander alle Sidepots ab und verteile sie auf die Sieger:
    //dabei ist zu beachten: der mit dem kleinsten Sidepot kriegt nur einen Bruchteil seines Sidepots zurück. der mit dem zweitkleinsten kriegt einen Bruchteil seines und des nächstkleineren Sidepots und so weiter.
    for (int i=0; i<[playersWhoAreAllIn count]; i++) {
        Player* playerWithSidePot = [playersWhoAreAllIn objectAtIndex:i];
        for (Player* winner in winners) {
            int numberAsIntTimesHundred = playerWithSidePot.sidePot.chipsInPot / divider * 100;
            float roundedNumber = numberAsIntTimesHundred / 100.0;
            winner.chips += roundedNumber;
        }
        self.mainPot.allChipsInAllPots -= playerWithSidePot.sidePot.chipsInPot;
        divider -= 1;
        playerWithSidePot.sidePot.chipsInPot = 0;
        [winners removeObject:playerWithSidePot];
    }*/
    
    //falls auch Player ohne sidePot unter den Gewinnern sind, bekommen diese den mainPot
    if ([winners count] != 0) {
        for (Player* winner in winners) {
            int numberAsIntTimesHundred = self.mainPot.chipsInPot / divider * 100;
            float roundedNumber = numberAsIntTimesHundred / 100.0;
            winner.chips += roundedNumber;
        }
        self.mainPot.allChipsInAllPots -= self.mainPot.chipsInPot;
        self.mainPot.chipsInPot = 0;
    }
    
    //ersetze winners und playersWhoAreAllin durch ihre Kopien:
    winners = winnersCopy;
    playersWhoAreAllIn = playersWhoAreAllInCopy;
    
    //gib jetzt alle Gewinner zurück (dies ist notwendig falls nochmals Gewinner bestimmt werden müssen, wenn der Pot noch nicht leer ist.
    return winners;
}

- (void) endBetRound
{
    [self distributeChipsOnPots];
    for (Player* aPlayer in self.remainingPlayersInRound) {
        aPlayer.playerState = INACTIVE;
    }
    for (Player* aPlayer in allPlayers) {
        aPlayer.alreadyBetChips = 0;
    }
    highestBet = 0;
    //Es gibt drei vier Möglichkeiten, was nach einer Bet-Round passieren kann:
    /*  1) gameState == RIVER oder nur noch ein Spieler übrig => Gewinner ermitteln:
        2) alle Spieler (außer höchstens einer sind all in), aber insgesamt mehr als 2 Spieler
            => nacheinander alle Karten aufdecken, kein Spieler kommt mehr dran, dann Sieger ermitteln
        3) nur noch 2 Spieler da, mindestens einer all in: beide decken ihre Karten auf, Karten in der Mitte werden nacheinander aufgedeckt
        4) ansonsten => Spiel läuft normal weiter:
     */
    if (gameState == RIVER || [remainingPlayersInRound count] == 1) {
        self.gameState = SHOW_DOWN;
        [self startShowDown];
    }
    else {
        if ([remainingPlayersInRound count] - [playersWhoAreAllIn count] <= 1) {
            if ([remainingPlayersInRound count] == 2) {
                [self startTwoPlayersAllInShowDown];
            }
            else {
                [self startMoreThanTwoPlayersAllInShowDown];
            }
        }
        else {
            [self performSelector:@selector(startBetRound) withObject:nil afterDelay:3.0];
        }
    }
}

- (void) sortPlayersWhoAreAllIn
{
    self.playersWhoAreAllIn = [NSMutableArray arrayWithArray:[playersWhoAreAllIn sortedArrayUsingComparator:^(Player* player1, Player* player2) {
        if (player1.sidePot.maxChips < player2.sidePot.maxChips) return (NSComparisonResult) NSOrderedAscending;
        else if (player1.sidePot.maxChips > player2.sidePot.maxChips) return (NSComparisonResult) NSOrderedDescending;
        return (NSComparisonResult) NSOrderedSame;
    }]];
}

- (void) distributeChipsOnPots
{
    for (Player* anyPlayer in allPlayers) {
        mainPot.allChipsInAllPots += anyPlayer.alreadyBetChips;
    }
    if ([playersWhoAreAllIn count] != 0) {
        //SidePots der Größe nach sortieren:
        [self sortPlayersWhoAreAllIn];
        for (int i=0; i<[playersWhoAreAllIn count]; i++) {
            Player* aPlayer = [playersWhoAreAllIn objectAtIndex:i];
            NSLog(@"%f",aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled);
        }
        Player* playerWithNextSmallerSidePot = nil;
        for (int i=0; i<[playersWhoAreAllIn count]; i++) {
            Player* aPlayer = (Player* ) [playersWhoAreAllIn objectAtIndex:i];
            if (aPlayer.sidePot.isFilled == YES) {
                continue;
            }
            else {
                aPlayer.sidePot.chipsInPot = self.mainPot.chipsInPot;
                self.mainPot.chipsInPot = 0;
            }
            if (playerWithNextSmallerSidePot != nil) {
                aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled -= playerWithNextSmallerSidePot.sidePot.chipsAmountNeededFromEachPlayerToBeFilled;
            }
            NSLog(@"%f",aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled);
            for (Player* anyPlayer in allPlayers) {
                if (anyPlayer.alreadyBetChips >= aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled) {
                    aPlayer.sidePot.chipsInPot += aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled;
                    anyPlayer.alreadyBetChips -= aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled;
                }
                else {
                    aPlayer.sidePot.chipsInPot += anyPlayer.alreadyBetChips;
                    anyPlayer.alreadyBetChips = 0;
                }
                //Alle Spieler, die noch im Spiel sind, werden in die Liste der für diesen Pot bezahlenden Spieler eingetragen
                if ([remainingPlayersInRound containsObject:anyPlayer]) {
                    [aPlayer.sidePot.playersWhoPaidInThisPot addObject:anyPlayer];
                }
            }
            if (playerWithNextSmallerSidePot != nil) {
                aPlayer.sidePot.chipsAmountNeededFromEachPlayerToBeFilled += playerWithNextSmallerSidePot.sidePot.chipsAmountNeededFromEachPlayerToBeFilled;
            }
            aPlayer.sidePot.isFilled = YES;
            playerWithNextSmallerSidePot = aPlayer;
        }
    }
    for (Player* anyPlayer in allPlayers) {
        self.mainPot.chipsInPot += anyPlayer.alreadyBetChips;
    }
}

- (void) startBetRound
{
    if (gameState == SETUP) {
        [self changeGameState]; //wechselt zu preflop
        activePlayer = firstInRound.playerOnLeftSide.playerOnLeftSide;
    }
    else {
        activePlayer = firstInRound;
        playerWhoBetMost = activePlayer;
        if (gameState == PRE_FLOP) {
            [self showFlop];
        }
        else if (gameState == FLOP) {
            [self showTurn];
        }
        else if (gameState == TURN) {
            [self showRiver];
        }
    }
    activePlayer.playerState = ACTIVE;
}

- (void) endRound
{
    //Chips verteilen:
    while (self.mainPot.allChipsInAllPots != 0) {
        NSLog(@"%f", self.mainPot.allChipsInAllPots);
        NSMutableArray* winners = [[NSMutableArray alloc] initWithArray:(NSMutableArray* )[self defineWinnersOfRound]];
        NSMutableArray* alreadyPaidWinners = [self sharePotAmongWinners:winners];
        for (Player* alreadyPaidWinner in alreadyPaidWinners) {
            [remainingPlayersInRound removeObject:alreadyPaidWinner];
        }
    }
    for (int i=0; i<[allPlayers count]; i++) {
        Player* aPlayer = [allPlayers objectAtIndex:i];
        if (aPlayer.chips == 0) {
            aPlayer.playerState = LOST;
            [allPlayers removeObjectAtIndex:i];
            maxPlayers -= 1;
            i--;
            aPlayer.playerOnRightSide.playerOnLeftSide = aPlayer.playerOnLeftSide;
            aPlayer.playerOnLeftSide.playerOnRightSide = aPlayer.playerOnRightSide;
        }
    }
    /*if ([allPlayers count] == 1) { //nur noch ein Spieler übrig? => Spiel vorbei
        [self endGame];
    }
    else {*/
        //Rundenzahl erhöhen:
        self.roundsPlayed += 1;
        //Wenn nötig: Blinds erhöhen
        if ([self.gameSettings.blinds isEqualToString:@"nach Runden"] && roundsPlayed % self.gameSettings.increaseBlindsAfter == 0) {
            [self increaseBlinds];
        }
        //alles für neue Runde resetten:
        [self prepareNewRound];
    if ([allPlayers count] > 1) {
        [self performSelector:@selector(startBetRound) withObject:nil afterDelay:3.0];
    }
    //}
}

- (void) endGame
{
    self.gameState = ENDED;
}

- (void) startShowDown
{
    //zunächst jeweils die Kartenstärke ermitteln:
    for (Player* remainingPlayer in remainingPlayersInRound) {
        [remainingPlayer.hand defineValueOfCardsWithTableCards:self.cardsOnTable];
    }
    activePlayer = playerWhoBetMost;
    [self showDownForPlayer:activePlayer];
}

- (void) showDownTimerFires:(NSTimer *)aTimer
{
    //Alle Spieler haben gezeigt oder gefoldet
    if (activePlayer == playerWhoBetMost && [playersWhoHaveShownCards containsObject:activePlayer]) {
        [self performSelector:@selector(endRound) withObject:nil afterDelay:1.5];
    }
    else {
        if (!activePlayer.isYou) {
            if ([aTimer.userInfo isEqualToString:@"showCards"]) {
                [activePlayer showCards:YES]; //Die YES-Übergabe bedeutet, dass er die Karten zeigen muss!
            }
            else if ([aTimer.userInfo isEqualToString:@"mayShowCards"]) {
                [activePlayer mayShowCardsNow];
            }
        }
        else {
            if ([aTimer.userInfo isEqualToString:@"mayShowCards"]) {
                activePlayer.mayShowCards = NO;
                if (!activePlayer.showsCards) {
                    activePlayer.throwsCardsAway = YES;
                }
            }
            else {
                [activePlayer showCards:YES];
            }
        }
        //Nur ein Spieler, der durfte zeigen
        if ([remainingPlayersInRound count] == 1) {
            [self performSelector:@selector(endRound) withObject:nil afterDelay:1.5];
        }
        else {
            activePlayer = activePlayer.nextPlayerInRound;
            [self showDownForPlayer:activePlayer];
        }

    }

    int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
    for (int i=1;i<=2;i++) {
        [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
    }

}

- (void) showDownForPlayer:(Player *)aPlayer
{
    NSString* userInfo = [[NSString alloc] init];
    if (aPlayer == playerWhoBetMost && [remainingPlayersInRound count] > 1) userInfo = @"showCards";
    else if (aPlayer == playerWhoBetMost) {
        userInfo = @"mayShowCards";
    }
    if (!aPlayer.hasSidePot) {
        for (int i=[playersWhoHaveShownCards count]-1; i>=0; i--) {
            Player* playerWhoHasShownCards = (Player* ) [playersWhoHaveShownCards objectAtIndex:i];
            if (!playerWhoHasShownCards.hasSidePot) {
                //vergleiche Karten:
                //bessere Karten?
                if ([aPlayer hasBetterCardsThan:playerWhoHasShownCards]) {
                    userInfo = @"showCards";
                    break;
                }
                //gleich gute Karten?
                else if ([aPlayer hasEqualCardsAs:playerWhoHasShownCards]) {
                    userInfo = @"showCards";
                    break;
                }
                else {
                    //gewinnt sicher nichts mehr, kann als aus den remaining Players entfernt werden:
                    //[remainingPlayersInRound removeObject:aPlayer];
                    aPlayer.previousPlayerInRound.nextPlayerInRound = aPlayer.nextPlayerInRound;
                    aPlayer.nextPlayerInRound.previousPlayerInRound = aPlayer.previousPlayerInRound;
                    userInfo = @"mayShowCards";
                    break;
                }
            }
            //weitere Möglichkeit: alle Spieler vor ihm sind all in, dann wird i bis 0 laufen:
            //in diesem Fall muss der Spieler seine Karten auf jeden Fall zeigen:
            if (i==0) {
                userInfo = @"showCards";
            }
        }
    }
    else {
        [self sortPlayersWhoAreAllIn];
        for (int i=[playersWhoHaveShownCards count]-1; i>=0; i--) {
            //wie oben:
            Player* playerWhoHasShownCards = [playersWhoHaveShownCards objectAtIndex:i];
            if (!playerWhoHasShownCards.hasSidePot) {
                if ([playerWhoHasShownCards hasBetterCardsThan:aPlayer]) {
                    //gewinnt sicher nichts mehr, kann als aus den remaining Players entfernt werden:
                    //[remainingPlayersInRound removeObject:aPlayer];
                    aPlayer.previousPlayerInRound.nextPlayerInRound = aPlayer.nextPlayerInRound;
                    aPlayer.nextPlayerInRound.previousPlayerInRound = aPlayer.previousPlayerInRound;
                    userInfo = @"mayShowCards";
                    break;
                }
            }
            else {
                if ([playersWhoAreAllIn indexOfObject:aPlayer] < [playersWhoAreAllIn indexOfObject:playerWhoHasShownCards]) {
                    if ([playerWhoHasShownCards hasBetterCardsThan:aPlayer]) {
                        //gewinnt sicher nichts mehr, kann als aus den remaining Players entfernt werden:
                        //[remainingPlayersInRound removeObject:aPlayer];
                        aPlayer.previousPlayerInRound.nextPlayerInRound = aPlayer.nextPlayerInRound;
                        aPlayer.nextPlayerInRound.previousPlayerInRound = aPlayer.previousPlayerInRound;
                        userInfo = @"mayShowCards";
                        break;
                    }
                }
            }
            //keiner der Spieler, die mehr gezahlt haben, hat bessere Karten:
            if (i==0) {
                userInfo = @"showCards";
            }
        }
    }
    
    //falls es ein Computer ist: Aktion nach 1,5 Sekunde ausführen.
    //falls es ein Spieler ist: Aktion muss in den nächsten 1,5 Sekunden ausgeführt werden:
    if (aPlayer.isYou && [userInfo isEqualToString:@"mayShowCards"] && ![playersWhoHaveShownCards containsObject:aPlayer] && !aPlayer.doesNotWinAnything) {
        [aPlayer mayShowCardsNow];
    }
    
    showDownTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(showDownTimerFires:) userInfo:userInfo repeats:NO];
    NSArray* temporaryArray = [NSArray arrayWithObjects:showDownTimer, [NSDate date], nil];
    [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
    if (paused) {
        self.createdTimerDuringPause = YES;
    }
}

- (void) startTwoPlayersAllInShowDown
{
    //counter For Timer legt fest wie oft der Timer repeaten soll
    if (self.gameState == PRE_FLOP) {
        counterForTimer = 4;
    }
    else if (self.gameState == FLOP) {
        counterForTimer = 3;
    }
    else if (self.gameState == TURN) {
        counterForTimer = 2;
    }
    else if (self.gameState == RIVER) {
        counterForTimer = 1;
    }
    self.exactlyTwoPlayersAllIn = YES;
    showDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(twoPlayersAllInShowDownTimerFired:) userInfo:nil repeats:YES];
    NSArray* temporaryArray = [NSArray arrayWithObjects:showDownTimer, [NSDate date], nil];
    [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
    if (paused) {
        self.createdTimerDuringPause = YES;
    }
}

- (void) twoPlayersAllInShowDownTimerFired: (NSTimer* ) aTimer
{
    counterForTimer -= 1;
    if (counterForTimer == 3) {
        [self showFlop];
        //self.gameState = FLOP;
    }
    else if (counterForTimer == 2) {
        [self showTurn];
        //self.gameState = TURN;
    }
    else if (counterForTimer == 1) {
        [self showRiver];
        //self.gameState = RIVER;
    }
    else if (counterForTimer == 0) {
        Player* player1 = [remainingPlayersInRound objectAtIndex:0];
        [player1.hand defineValueOfCardsWithTableCards:cardsOnTable];
        [player1 showCards:YES]; //Karten wurden zwar schon gezeigt, so kommt aber noch die Animation hinzu
    }
    else if (counterForTimer == -1) {
        Player* player2 = [remainingPlayersInRound objectAtIndex:1];
        [player2.hand defineValueOfCardsWithTableCards:cardsOnTable];
        [player2 showCards:YES]; 
        [aTimer invalidate];
        int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
        for (int i=1;i<=2;i++) {
            [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
        }
        [self performSelector:@selector(endRound) withObject:nil afterDelay:2.0];
    }
}

- (void) startMoreThanTwoPlayersAllInShowDown
{
    //counter For Timer legt fest wie oft der Timer repeaten soll
    if (self.gameState == PRE_FLOP) {
        counterForTimer = 4;
    }
    else if (self.gameState == FLOP) {
        counterForTimer = 3;
    }
    else if (self.gameState == TURN) {
        counterForTimer = 2;
    }
    else if (self.gameState == RIVER) {
        counterForTimer = 1;
    }
    showDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moreThanTwoPlayersAllInShowDownTimerFired:) userInfo:nil repeats:YES];
    NSArray* temporaryArray = [NSArray arrayWithObjects:showDownTimer, [NSDate date], nil];
    [self.currentlyRunningTimersWithCreationTimes addObjectsFromArray:temporaryArray];
    if (paused) {
        self.createdTimerDuringPause = YES;
    }
}

- (void) moreThanTwoPlayersAllInShowDownTimerFired:(NSTimer *)aTimer
{
    counterForTimer -= 1;
    if (counterForTimer == 3) {
        [self showFlop];
        //self.gameState = FLOP;
    }
    else if (counterForTimer == 2) {
        [self showTurn];
        //self.gameState = TURN;
    }
    else if (counterForTimer == 1) {
        [self showRiver];
        //self.gameState = RIVER;
    }
    else if (counterForTimer == 0) {        
        [aTimer invalidate];
        int index = [self.currentlyRunningTimersWithCreationTimes indexOfObject:aTimer];
        for (int i=1;i<=2;i++) {
            [currentlyRunningTimersWithCreationTimes removeObjectAtIndex:index]; //alle Timer und zugehörtige Startzeiten wieder rauswerfen.
        }
        [self endBetRound];
    }
}

- (void) increaseBlinds
{
    self.smallBlind *= 2;
}

- (void) blindsTimerFired:(NSTimer *)aTimer
{
    if (self.blindsCountdown > 0) {
        self.blindsCountdown -= 1;
    }
    else {
        [self increaseBlinds];
        self.blindsCountdown = self.gameSettings.increaseBlindsAfter*60;
    }
}

@end
