//
//  Player.h
//  Poker iPhone App
//
//  Created by Christian Klumpp on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hand.h"
#import "SidePot.h"
#import "Enum_PlayerState.h"
#import "PlayerProfile.h"

@class PokerGame;

@interface Player : NSObject
{
    Hand* hand;
    PlayerState playerState;
    Player* nextPlayerInRound;
    Player* previousPlayerInRound;
    Player* playerOnLeftSide;
    Player* playerOnRightSide;
    BOOL dealer;
    BOOL smallBlind;
    BOOL bigBlind;
    float chips;
    PokerGame* pokerGame;
    float alreadyBetChips;
    SidePot* sidePot;
    float chipsWon; //Diese Variable wird wichtig bei der Verteilung der Chips am Ende jeder Runde
    
    //Countdown von (z.B.) 20 sek pro Zug:
    int counter;
    
    // nicht ideal, aber für Tests geeignet:
    BOOL isYou;
    NSMutableArray* currentlyRunningTimersWithCreationTimes;
    
    
    //Variablen KI
    
    int outs;
    float cardOddsFlop;
    float cardOddsTurn;
    float cardOddsRiver;
    float potOdds;
    bool cardOddsFlopIsHigher;
    bool cardOddsTurnIsHigher;
    bool cardOddsRiverIsHigher;
    //bool cardOddsIsHigher;
    float cardOdds;
    CardValues cardValues;
    int valueOfHighestPair;
    bool flushExpectation;
    bool openStraightExpectation;
    bool openStraightAtOneEnd;
}

@property (nonatomic, retain) Hand* hand;
@property (nonatomic, assign) PlayerState playerState;
@property (nonatomic, retain) Player* nextPlayerInRound;
@property (nonatomic, retain) Player* previousPlayerInRound;
@property (nonatomic, retain) Player* playerOnLeftSide;
@property (nonatomic, retain) Player* playerOnRightSide;
@property (nonatomic, assign) BOOL smallBlind;
@property (nonatomic, assign) BOOL dealer;
@property (nonatomic, assign) BOOL bigBlind;
@property (nonatomic, assign) float chips;
@property (nonatomic, retain) PokerGame* pokerGame;
@property (nonatomic, assign) float alreadyBetChips;
@property (nonatomic, assign) int counter;
@property (nonatomic, assign) BOOL isYou;
@property (nonatomic, retain) NSString* identification; //soll Werte annehmen wie @"player1", @"player2" und so weiter, dient dazu einen Player mit seinen Outlets zu identifizieren
@property (nonatomic, assign) BOOL isAllIn;
@property (nonatomic, assign) BOOL hasSidePot;
@property (nonatomic, retain) SidePot* sidePot;
@property (nonatomic, strong) NSTimer* countdownTimer;
@property (nonatomic, assign) float chipsWon;
@property (nonatomic, assign) BOOL showsCards;
@property (nonatomic, assign) BOOL throwsCardsAway;
@property (nonatomic, assign) BOOL mayShowCards;
@property (nonatomic, assign) BOOL doesNotWinAnything;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) BOOL createdTimerDuringPause;
@property (nonatomic, assign) CGRect showDownCard1Frame;
@property (nonatomic, assign) CGRect showDownCard2Frame;
@property (nonatomic, retain) PlayerProfile* playerProfile;

//Idee: um das Spiel pausieren zu können, soll es einen Pointer geben, der immer auf den aktuellen Timer zeigt. Sobald Pause gedrückt wird, wie das TimeInterval des Timers auf eine beliebig große Zal gesetzt
@property (nonatomic, retain) NSMutableArray* currentlyRunningTimersWithCreationTimes;


//properties KI
@property(nonatomic,assign) int outs;
@property(nonatomic,assign)float cardOdds;
@property(nonatomic,assign) BOOL cardOddFlopIsHigher;
@property(nonatomic,assign) BOOL cardOddTurnIsHigher;
@property(nonatomic,assign) BOOL cardOddRiverIsHigher;
//@property (nonatomic,assign) bool cardOddsIsHigher;
@property (nonatomic,retain) Pot *pot;
@property (nonatomic, assign) CardValues cardValues;
@property (nonatomic, assign) int valueOfHighestPair;
@property (nonatomic, retain) NSDictionary *preFlopDict;
@property (nonatomic, assign) int cardPairSuit;
@property (nonatomic,retain) NSString *cardPairKey;
@property (nonatomic, assign) BOOL hasAlreadyBluffed;




- (void) bet: (float) amount asBlind: (BOOL) isBlind;
- (void) call;
- (void) fold;
- (void) check;
- (void) allIn: (float) amount asBlind: (BOOL) isBlind;
- (void) prepareMove;
- (void) startMove;
- (void) startCountdown;
- (void) stopCountdown: (NSTimer* ) timer;
- (void) makeRandomBet; //Testmethode (später löschen!)
- (BOOL) hasBetterCardsThan: (Player* ) aPlayer;
- (BOOL) hasEqualCardsAs: (Player* ) aPlayer;
- (void) showCards: (BOOL) required;
- (void) mayShowCardsNow;
- (void) resetPlayerForNewRound;
- (void) changePlayerState: (NSNumber* ) playerStateAsObject;

- (void) makeBetDecision: (int) maxBet betProbabilityParameter: (int) betParameter foldProbabilityParamter: (int) foldParameter callEverything: (BOOL) callsEverything;

//Methoden KI
- (void) preparePreFlop;
- (void) handStrength;

- (BOOL) expectPair;
- (BOOL) expectThreeOfAKind;
- (BOOL) expectFlush;
- (BOOL) expectOpenStraight;
- (BOOL) expectGutshot;
- (BOOL) expectDoubleGutshot;
- (BOOL) expectFlushAndGutshot;
- (BOOL) expectFlushAndOpenStraight;

- (int)  calculateOuts;
- (void) calculateCardOdds;
- (void) calculatePotOdds;
- (void) compareOdds;
- (void) makeBet;

- (void) makeBluffDecision: (float) potChips;

- (float) playerHasWonMoreThanAverage: (Player* ) aPlayer;


@end
