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
//#include "Functions.h"
#import "AppDelegate.h"
#import "ModifiedSlider.h"

@interface GameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
{
    BOOL paused;
    Player* you;
}
@property(nonatomic, retain) IBOutlet UIImageView*player1Box;
@property(nonatomic, retain) IBOutlet UIImageView*player2Box;
@property(nonatomic, retain) IBOutlet UIImageView*player3Box;
@property(nonatomic, retain) IBOutlet UIImageView*player4Box;
@property(nonatomic, retain) IBOutlet UIImageView*player5Box;

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

@property(nonatomic, retain) IBOutlet UILabel* playerCountdownLabel;

@property(nonatomic, retain) IBOutlet UILabel* betLabel;
@property(nonatomic, retain) IBOutlet ModifiedSlider* betSlider;
@property(nonatomic, retain) UISegmentedControl* foldButton;
@property(nonatomic, retain) UISegmentedControl* betButton;

@property(nonatomic, retain) IBOutlet UILabel* effectLabel1;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel2;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel3;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel4;
@property(nonatomic, retain) IBOutlet UILabel* effectLabel5;

@property (nonatomic, retain) IBOutlet UILabel* blindsCountdownLabel;
@property (nonatomic, retain) IBOutlet UILabel* roundsPlayedLabel;
@property (nonatomic, retain) IBOutlet UILabel* blindsIncreasedLabel;

@property(nonatomic, retain) IBOutlet UISegmentedControl* showCardsButton;
@property(nonatomic, retain) IBOutlet UISegmentedControl* throwCardsAwayButton;

@property(nonatomic, retain) IBOutlet UISegmentedControl* pauseButton;
@property(nonatomic, retain) IBOutlet UILabel* pauseLabel;

@property(nonatomic, retain) NSMutableArray* currentlyRunningTimersWithCreationsTimes;
@property(nonatomic, retain) NSMutableArray* timesToGoForCurrentlyRunningTimers;
@property(nonatomic, retain) UITableView* pauseTableView;
@property(nonatomic, retain) IBOutlet UIImageView* table;
@property(nonatomic, retain) NSMutableArray* temporaryOutletsAndBadCards; //nur für Animationen von Bedeutung

@property(nonatomic, strong) AVAudioPlayer* cardSoundPlayer;
@property(nonatomic, strong) AVAudioPlayer* foldSoundPlayer;
@property(nonatomic, strong) AVAudioPlayer* moneySoundPlayer;
@property(nonatomic, strong) AVAudioPlayer* countdownSoundPlayer;
@property(nonatomic, strong) AVAudioPlayer* winnerSoundPlayer;

@property (nonatomic, strong) UILabel* player1FoldFadeLabel;
@property (nonatomic, strong) UILabel* player2FoldFadeLabel;
@property (nonatomic, strong) UILabel* player3FoldFadeLabel;
@property (nonatomic, strong) UILabel* player4FoldFadeLabel;
@property (nonatomic, strong) UILabel* player5FoldFadeLabel;

@property (nonatomic, assign) BOOL paused;

@property (nonatomic, strong) IBOutlet UIButton* sliderSensibilityButton;

@property (nonatomic, strong) IBOutlet UIImageView* winnersCrown;

@property (nonatomic, strong) Player* you;

- (void) changePlayerOutlets_chips: (Player* ) aPlayer;
- (void) changePlayerOutlets_alreadyBetChips: (Player* ) aPlayer;
- (void) changePlayerOutlets_cards: (Player* ) aPlayer;
- (void) changePlayerOutlets_activePlayer: (Player* ) aPlayer;
- (void) changePlayerOutlets_sidePot: (Player* ) aPlayer;
- (void) changePlayerOutlets_mayShowCards: (Player* ) aPlayer;
- (void) changeGameOutlets_pot;
- (void) changeGameOutlets_cards;
- (void) changeGameOutlets_blindsCountdown;
- (void) changeGameOutlets_roundsPlayed;
- (void) changeGameOutlets_playerCountDown: (Player* ) aPlayer;
- (void) changePlayerOutlets_lost: (Player* ) aPlayer;
- (void) changePlayerOutlets_won: (Player* ) aPlayer;


- (IBAction) changeBetSliderValue:(id)sender;
- (IBAction) betButtonPressed:(id)sender;
- (IBAction) foldButtonPressed:(id)sender;


- (void) showAnimationAtTheEndOfMoveOfPlayer: (Player* ) aPlayer;
- (void) showAnimationWhenPlayerShowsCards: (Player* ) aPlayer;
- (void) showAnimationWhenCardPopsFromDeck;
- (void) showAnimationWhenPlayerFolds: (Player* ) aPlayer;
- (void) showAnimationWhenGameIsPaused;
- (void) showAnimationWhenPlayer: (Player* ) aPlayer showsCard: (UIImageView* ) card1 andCard: (UIImageView* ) card2 fiveBestCardsAnimated:(BOOL) animated;
- (void) showAnimationWhenBlindsAreIncreased;
- (void) showAnimationForFiveBestCardsOfPlayer: (Player* ) aPlayer withCard: (UIImageView* ) card1 andCard: (UIImageView* ) card2;


- (void) resetTemporaryOutletsAndBadCards;
- (void) removeTemporaryOutlet:(UIImageView* ) outlet;

- (void) resetObservationForSidePots;
- (void) fadeOutLabel: (UILabel* ) effectLabel duration: (float) secs option: (UIViewAnimationOptions) option;
- (void) movePlayingCardFromFrame: (CGRect) startFrame toDestinationFrame: (CGRect) destinationFrame duration: (float) secs option: (UIViewAnimationOptions) option;
- (void) showCardsOfPlayer: (Player* ) aPlayer withAnimation: (BOOL) animated;
- (void) playerThrowsCardsAway: (Player* ) aPlayer;

- (void) pauseRunningTimer: (NSTimer* ) timer creationTime: (NSDate* ) creationTime;
- (void) unpauseRunningTimer: (NSTimer* ) timer timeToGo: (NSTimeInterval) timeToGo;

- (void) showAnimationWhenPlayerWonGame: (CGRect) positionOfProfilePicture;

- (void) resetAnimatedOutlets;

- (void) pauseOrUnpause;

- (void) setUpGraphics;




- (IBAction)cardsTouchDown:(id)sender;
- (IBAction)cardsTouchUp:(id)sender;
- (IBAction)showCardsButtonClicked:(id)sender;
- (IBAction)throwCardsAwayButtonClicked:(id)sender;
- (IBAction)changeSliderSensibility:(id)sender;

@end
