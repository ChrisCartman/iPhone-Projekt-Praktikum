//
//  PokerGame.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "CardDeck.h"
#import "CardsOnTable.h"
#import "Enum_PlayerState.h"
#import "Enum_GameState.h"
#import "GameSettings.h"
#import "MainPot.h"

@interface PokerGame : NSObject
{
    NSMutableArray* allPlayers;
    NSMutableArray* remainingPlayersInRound;
    Player* activePlayer;
    int maxPlayers;
    CardDeck* cardDeck;
    float smallBlind;
    float highestBet;
    CardsOnTable* cardsOnTable;
    Player* playerWhoBetMost;
    Player* dealer;
    int round;
    Player* firstInRound;
    GameState gameState;
    MainPot* mainPot;
    NSMutableArray* playersWhoHaveShownCards;
}

@property (nonatomic, retain) NSMutableArray* remainingPlayersInRound;
@property (nonatomic, retain) CardsOnTable* cardsOnTable;
@property (nonatomic, retain) NSArray* allPlayers;
@property (nonatomic, retain) CardDeck* cardDeck;
@property (nonatomic, retain) Player* activePlayer;
@property (nonatomic, assign) float smallBlind;
@property (nonatomic, assign) float highestBet;
@property (nonatomic, retain) Player* playerWhoBetMost;
@property (nonatomic, retain) Player* firstInRound;
@property (nonatomic, assign) GameState gameState;
@property (nonatomic, retain) GameSettings* gameSettings;
@property (nonatomic, assign) int maxPlayers;
@property (nonatomic, retain) Player* dealer;
@property (nonatomic, retain) NSMutableArray* playersWhoAreAllIn;
@property (nonatomic, retain) MainPot* mainPot;
@property (nonatomic, retain) NSMutableArray* playersWhoHaveShownCards;
@property (nonatomic, retain) NSTimer* showDownTimer;
@property (nonatomic, assign) int counterForTimer;
@property (nonatomic, retain) NSTimer* dealOutTimer;
@property (nonatomic, retain) NSTimer* tableCardsTimer;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) BOOL createdTimerDuringPause;
@property (nonatomic, assign) int roundsPlayed;

@property (nonatomic, retain) NSTimer* blindsTimer;
@property (nonatomic, assign) int blindsCountdown;

//Idee: um das Spiel pausieren zu können, soll es einen Pointer geben, der immer auf den aktuellen Timer zeigt. Sobald Pause gedrückt wird, wie das TimeInterval des Timers auf eine beliebig große Zal gesetzt
@property (nonatomic, retain) NSMutableArray* currentlyRunningTimersWithCreationTimes;



/* Erklärungen zu den Begriffen:
 Game: ein komplettes Pokerspiel, das heißt: Ende, wenn nur noch ein Spieler am Tisch sitzt.
 Round: eine Spielrunde, das heißt: Ende, wenn der Pott an den (die) gewinnenden Spieler ausgeschüttet wird
 BetRound: Wettrunde (gibt es einmal vor dem Flop, einmal nach dem Flop, einmal nach dem Turn und einmal nach dem River) */

- (void) prepareGame;
- (void) addPlayer: (Player* ) aPlayer;
- (void) increaseBlinds;
- (void) startNewRound;
- (void) activateNextPlayer;
- (void) dealOut;
- (void) prepareNewRound;
- (Player* ) defineWinnersOfRound;
- (Player* ) defineWinnerOfGame;
- (void) endBetRound;
- (void) endRound;
- (void) endGame;
- (void) showFlop;
- (void) showTurn;
- (void) showRiver;
- (void) endMoveOfPlayer: (Player* ) aPlayer; //Startet außerdem den Zug des nächsten Spielers, bzw. beendet die Bet-Round
- (NSMutableArray* ) sortPlayers_BestCardsFirst;
- (void) takeBlinds;
- (void) startBetRound;
- (void) changeGameState;
- (NSMutableArray* ) sharePotAmongWinners: (NSMutableArray* ) winners;
- (void) takeBetAmount: (float) amount fromPlayer: (Player* ) aPlayer asBlind: (BOOL) isBlind;
- (void) takeCallFromPlayer: (Player* ) aPlayer;
- (void) takeFoldFromPlayer: (Player* ) aPlayer;
- (void) takeCheckFromPlayer: (Player* ) aPlayer;
- (void) takeAllInFromPlayer: (Player* ) aPlayer asBlind:(BOOL) isBlind;
- (void) evaluateCardValues;
- (void) takeBackCardsFromPlayer:(Player* ) aPlayer;
- (void) distributeChipsOnPots;
- (void) sortPlayersWhoAreAllIn;
- (void) startShowDown;
- (void) showCardsOfPlayer: (Player* ) aPlayer;
- (void) showDownTimerFires: (NSTimer* ) aTimer;
- (void) showDownForPlayer: (Player* ) aPlayer;
- (void) resetGameForNewRound;
- (void) startTwoPlayersAllInShowDown;
- (void) startMoreThanTwoPlayersAllInShowDown;
- (void) twoPlayersAllInShowDownTimerFired: (NSTimer* ) aTimer;
- (void) moreThanTwoPlayersAllInShowDownTimerFired: (NSTimer* ) aTimer;
- (void) dealOutTimerFired: (NSTimer* ) aTimer;
- (void) flopTimerFired: (NSTimer* ) aTimer;
- (void) turnTimerFired: (NSTimer* ) aTimer;
- (void) riverTimerFired: (NSTimer* ) aTimer;
- (void) blindsTimerFired: (NSTimer* ) aTimer;

@end
