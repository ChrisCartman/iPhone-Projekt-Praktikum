//
//  GameViewController.h
//  Poker iPhone App
//
//  Created by Lion User on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "PokerGame.h"
#include "Functions.h"

@interface GameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
{
    BOOL paused;
}

@property (nonatomic, retain) UIImageView* cardDeckImage;

@property(nonatomic, retain) IBOutlet UILabel* player1NameLabel;
@property(nonatomic, retain) IBOutlet UILabel* player2NameLabel;
@property(nonatomic, retain) IBOutlet UILabel* player3NameLabel;
@property(nonatomic, retain) IBOutlet UILabel* player4NameLabel;
@property(nonatomic, retain) IBOutlet UILabel* player5NameLabel;
@property(nonatomic, retain) IBOutlet UILabel* player1ChipsLabel;
@property(nonatomic, retain) IBOutlet UILabel* player1AlreadyBetChipsLabel;
@property(nonatomic, retain) IBOutlet UIImageView* player1ProfilePictureImage;
@property(nonatomic, retain) IBOutlet UIImageView* player1CardOne;
@property(nonatomic, retain) IBOutlet UIImageView* player1CardTwo;
@property(nonatomic, retain) IBOutlet UILabel* player2ChipsLabel;
@property(nonatomic, retain) IBOutlet UILabel* player2AlreadyBetChipsLabel;
@property(nonatomic, retain) IBOutlet UIImageView* player2ProfilePictureImage;
@property(nonatomic, retain) IBOutlet UIImageView* player2CardOne;
@property(nonatomic, retain) IBOutlet UIImageView* player2CardTwo;
@property(nonatomic, retain) IBOutlet UILabel* player3ChipsLabel;
@property(nonatomic, retain) IBOutlet UILabel* player3AlreadyBetChipsLabel;
@property(nonatomic, retain) IBOutlet UIImageView* player3ProfilePictureImage;
@property(nonatomic, retain) IBOutlet UIImageView* player3CardOne;
@property(nonatomic, retain) IBOutlet UIImageView* player3CardTwo;
@property(nonatomic, retain) IBOutlet UILabel* player4ChipsLabel;
@property(nonatomic, retain) IBOutlet UILabel* player4AlreadyBetChipsLabel;
@property(nonatomic, retain) IBOutlet UIImageView* player4ProfilePictureImage;
@property(nonatomic, retain) IBOutlet UIImageView* player4CardOne;
@property(nonatomic, retain) IBOutlet UIImageView* player4CardTwo;
@property(nonatomic, retain) IBOutlet UILabel* player5ChipsLabel;
@property(nonatomic, retain) IBOutlet UILabel* player5AlreadyBetChipsLabel;
@property(nonatomic, retain) IBOutlet UIImageView* player5ProfilePictureImage;
@property(nonatomic, retain) IBOutlet UIImageView* player5CardOne;
@property(nonatomic, retain) IBOutlet UIImageView* player5CardTwo;
@property(nonatomic, retain) IBOutlet UIImageView* flopCardOneImage;
@property(nonatomic, retain) IBOutlet UIImageView* flopCardTwoImage;
@property(nonatomic, retain) IBOutlet UIImageView* flopCardThreeImage;
@property(nonatomic, retain) IBOutlet UIImageView* turnCardImage;
@property(nonatomic, retain) IBOutlet UIImageView* riverCardImage;
@property(nonatomic, retain) IBOutlet UILabel* potLabel;
@property(nonatomic, retain) IBOutlet UILabel* sidePotLabel1;
@property(nonatomic, retain) IBOutlet UILabel* sidePotLabel2;
@property(nonatomic, retain) IBOutlet UILabel* sidePotLabel3;
@property(nonatomic, retain) IBOutlet UILabel* sidePotLabel4;
@property(nonatomic, retain) IBOutlet UILabel* sidePotLabel5;
@property(nonatomic, retain) PokerGame* pokerGame;

@property(nonatomic, retain) IBOutlet UILabel* betLabel;
@property(nonatomic, retain) IBOutlet UISlider* betSlider;
@property(nonatomic, retain) UISegmentedControl* foldButton;
@property(nonatomic, retain) UISegmentedControl* betButton;

@property(nonatomic, retain) IBOutlet UILabel* effectLabel1;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel2;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel3;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel4;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel5;

@property(nonatomic, retain) IBOutlet UISegmentedControl* showCardsButton;
@property(nonatomic, retain) IBOutlet UISegmentedControl* throwCardsAwayButton;

@property(nonatomic, retain) IBOutlet UISegmentedControl* pauseButton;

@property(nonatomic, retain) NSMutableArray* currentlyRunningTimersWithCreationsTimes;
@property(nonatomic, retain) NSMutableArray* timesToGoForCurrentlyRunningTimers;
@property(nonatomic, retain) UITableView* pauseTableView;
@property(nonatomic, retain) IBOutlet UIImageView* table;

- (void) setUpGraphics;

- (void) changePlayerOutlets_chips: (Player* ) aPlayer;
- (void) changePlayerOutlets_alreadyBetChips: (Player* ) aPlayer;
- (void) changePlayerOutlets_cards: (Player* ) aPlayer;
- (void) changePlayerOutlets_activePlayer: (Player* ) aPlayer;
- (void) changePlayerOutlets_sidePot: (Player* ) aPlayer;
- (void) changePlayerOutlets_mayShowCards: (Player* ) aPlayer;
- (void) changeGameOutlets_pot;
- (void) changeGameOutlets_cards;
- (IBAction) changeBetSliderValue:(id)sender;
- (IBAction) betButtonPressed:(id)sender;
- (IBAction) foldButtonPressed:(id)sender;

- (void) showAnimationAtTheEndOfMoveOfPlayer: (Player* ) aPlayer;
- (void) showAnimationWhenPlayerShowsCards: (Player* ) aPlayer;
- (void) showAnimationWhenCardPopsFromDeck;
- (void) showAnimationWhenPlayerFolds: (Player* ) aPlayer;
- (void) showAnimationWhenGameIsPaused;

- (void) removeTemporaryOutlet:(UIImageView* ) outlet;

- (void) resetObservationForSidePots;
- (void) fadeOutLabel: (UILabel* ) effectLabel duration: (float) secs option: (UIViewAnimationOptions) option;
- (void) movePlayingCardFromFrame: (CGRect) startFrame toDestinationFrame: (CGRect) destinationFrame duration: (float) secs option: (UIViewAnimationOptions) option;
- (void) showCardsOfPlayer: (Player* ) aPlayer withAnimation: (BOOL) animated;
- (void) playerThrowsCardsAway: (Player* ) aPlayer;

- (void) pauseOfUnpause;

- (void) pauseRunningTimer: (NSTimer* ) timer creationTime: (NSDate* ) creationTime;
- (void) unpauseRunningTimer: (NSTimer* ) timer timeToGo: (NSTimeInterval) timeToGo;


- (IBAction)showCardsButtonClicked:(id)sender;
- (IBAction)throwCardsAwayButtonClicked:(id)sender;

@end
