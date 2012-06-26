//
//  GameViewController.m
//  Poker iPhone App
//
//  Created by Lion User on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize cardDeckImage;

@synthesize player1CardOne;
@synthesize player1CardTwo;
@synthesize player1NameLabel;
@synthesize player2CardOne;
@synthesize player2CardTwo;
@synthesize player3CardOne;
@synthesize player3CardTwo;
@synthesize player4CardOne;
@synthesize player4CardTwo;
@synthesize player5CardOne;
@synthesize player5CardTwo;
@synthesize player2NameLabel;
@synthesize player3NameLabel;
@synthesize player4NameLabel;
@synthesize player5NameLabel;
@synthesize player1ChipsLabel;
@synthesize player2ChipsLabel;
@synthesize player3ChipsLabel;
@synthesize player4ChipsLabel;
@synthesize player5ChipsLabel;
@synthesize player1ProfilePictureImage;
@synthesize player2ProfilePictureImage;
@synthesize player3ProfilePictureImage;
@synthesize player4ProfilePictureImage;
@synthesize player5ProfilePictureImage;
@synthesize player1AlreadyBetChipsLabel;
@synthesize player2AlreadyBetChipsLabel;
@synthesize player3AlreadyBetChipsLabel;
@synthesize player4AlreadyBetChipsLabel;
@synthesize player5AlreadyBetChipsLabel;
@synthesize flopCardOneImage;
@synthesize flopCardTwoImage;
@synthesize flopCardThreeImage;
@synthesize turnCardImage;
@synthesize riverCardImage;
@synthesize potLabel;
@synthesize sidePotLabel1;
@synthesize sidePotLabel2;
@synthesize sidePotLabel3;
@synthesize sidePotLabel4;
@synthesize sidePotLabel5;
@synthesize pokerGame;

@synthesize foldButton;
@synthesize betLabel;
@synthesize betButton;
@synthesize betSlider;

@synthesize effectLabel1;
@synthesize effectLabel2;
@synthesize effectLabel3;
@synthesize effectLabel4;
@synthesize effectLabel5;

@synthesize roundsPlayedLabel;
@synthesize blindsCountdownLabel;
@synthesize blindsIncreasedLabel;

@synthesize showCardsButton;
@synthesize throwCardsAwayButton;

@synthesize pauseButton;
@synthesize pauseTableView;
@synthesize pauseLabel;

@synthesize currentlyRunningTimersWithCreationsTimes;
@synthesize timesToGoForCurrentlyRunningTimers;

@synthesize table;

@synthesize temporaryOutletsAndBadCards;

@synthesize cardSoundPlayer;
@synthesize foldSoundPlayer;
@synthesize moneySoundPlayer;

@synthesize playerCountdownLabel;
@synthesize countdownSoundPlayer;

//User-Interaction:
- (IBAction) changeBetSliderValue:(id)sender
{
    betLabel.text = [[[NSNumber numberWithFloat:roundNumberOnTwoFigures(betSlider.value)] stringValue] stringByAppendingString:@"$"];
    if (betSlider.value == 0) {
        // betButton.titleLabel.text = @"Check";
        [betButton setTitle:@"Check" forSegmentAtIndex:0];    }
    else if (betSlider.value == betSlider.minimumValue && betSlider.value != 0) {
        //betButton.titleLabel.text = @"Call";
        [betButton setTitle:@"Call" forSegmentAtIndex:0]; 
    }
    else if (betSlider.value == betSlider.maximumValue) {
        //betButton.titleLabel.text = @"All in";
        [betButton setTitle:@"All in" forSegmentAtIndex:0]; 
    }
    else {
        // betButton.titleLabel.text = @"Bet";
        [betButton setTitle:@"Bet" forSegmentAtIndex:0]; 
    }
}

- (IBAction) betButtonPressed:(id)sender
{
    Player* aPlayer = pokerGame.activePlayer;
    if (betSlider.value == 0) {
        [aPlayer check];
    }
    else if (betSlider.value == betSlider.minimumValue) {
        [aPlayer call];
    }
    else if (betSlider.value == betSlider.maximumValue) {
        [aPlayer allIn:roundNumberOnTwoFigures(betSlider.value) asBlind:NO];
    }
    else {
        [aPlayer bet:roundNumberOnTwoFigures(betSlider.value) asBlind:NO];
    }
}

- (IBAction)foldButtonPressed:(id)sender
{
    Player* aPlayer = pokerGame.activePlayer;
    [aPlayer fold];
}

- (IBAction)showCardsButtonClicked:(id)sender
{
    Player* aPlayer = pokerGame.activePlayer;
    [aPlayer showCards:NO];
    aPlayer.mayShowCards = NO;
    [pokerGame.showDownTimer fire];
}

- (void) playerThrowsCardsAway:(Player *)aPlayer
{
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        player1CardOne.image = nil;
        player1CardTwo.image = nil;
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        player2CardOne.image = nil;
        player2CardTwo.image = nil;
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        player3CardOne.image = nil;
        player3CardTwo.image = nil;
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        player4CardOne.image = nil;
        player4CardTwo.image = nil;
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        player5CardOne.image = nil;
        player5CardTwo.image = nil;
    }
    [self showAnimationWhenPlayerFolds:aPlayer];
}

- (IBAction)throwCardsAwayButtonClicked:(id)sender
{
    Player* aPlayer = pokerGame.activePlayer;
    aPlayer.mayShowCards = NO;
    [self playerThrowsCardsAway:aPlayer];
    [pokerGame.showDownTimer fire];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setUpPlayers
{
    //Spieler erstellen:
    Player* player1 = [[Player alloc] init];
    [pokerGame addPlayer:player1];
    [player1 addObserver:self forKeyPath:@"alreadyBetChips" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"chips" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"playerState" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"hasSidePot" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"showsCards" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"mayShowCards" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];
    [player1 addObserver:self forKeyPath:@"counter" options:0 context:nil];
    // jeder Spieler wird mit seinen Outlets verknüpft
    Player* player2 = [[Player alloc] init];
    [pokerGame addPlayer:player2];
    [player2 addObserver:self forKeyPath:@"alreadyBetChips" options:0 context:nil];
    [player2 addObserver:self forKeyPath:@"chips" options:0 context:nil];
    [player2 addObserver:self forKeyPath:@"playerState" options:0 context:nil];
    [player2 addObserver:self forKeyPath:@"hasSidePot" options:0 context:nil];
    [player2 addObserver:self forKeyPath:@"showsCards" options:0 context:nil];
    [player2 addObserver:self forKeyPath:@"mayShowCards" options:0 context:nil];
    [player2 addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];;
    [player2 addObserver:self forKeyPath:@"counter" options:0 context:nil];
    if (pokerGame.gameSettings.anzahlKI > 1) {
        Player* player3 = [[Player alloc] init];
        [pokerGame addPlayer:player3];
        [player3 addObserver:self forKeyPath:@"alreadyBetChips" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"chips" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"playerState" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"hasSidePot2" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"showsCards" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"mayShowCards" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];
        [player3 addObserver:self forKeyPath:@"counter" options:0 context:nil];
    }
    if (pokerGame.gameSettings.anzahlKI > 2) {
        Player* player4 = [[Player alloc] init];
        [pokerGame addPlayer:player4];
        [player4 addObserver:self forKeyPath:@"alreadyBetChips" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"chips" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"playerState" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"hasSidePot" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"showsCards" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"mayShowCards" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];
        [player4 addObserver:self forKeyPath:@"counter" options:0 context:nil];
    }
    if (pokerGame.gameSettings.anzahlKI > 3) {
        Player* player5 = [[Player alloc] init];
        [pokerGame addPlayer:player5];
        [player5 addObserver:self forKeyPath:@"alreadyBetChips" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"chips" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"playerState" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"hasSidePot" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"showsCards" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"mayShowCards" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];
        [player5 addObserver:self forKeyPath:@"counter" options:0 context:nil];
    }
}

// diese Funktionen ändert die Ausgaben auf dem Bildschirm und passt sie an die internen Werte an
- (void) changePlayerOutlets_chips: (Player* ) aPlayer
{
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        player1ChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.chips] stringValue] stringByAppendingString:@"$"];
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        player2ChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.chips] stringValue] stringByAppendingString:@"$"];
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        player3ChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.chips] stringValue] stringByAppendingString:@"$"];
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        player4ChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.chips] stringValue] stringByAppendingString:@"$"];
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        player5ChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.chips] stringValue] stringByAppendingString:@"$"];
    }
}

- (void) showCardsOfPlayer:(Player *)aPlayer withAnimation:(BOOL)animated
{
    UIImageView* card1;
    UIImageView* card2;
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        card1 = player1CardOne;
        card2 = player1CardTwo;
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        card1 = player2CardOne;
        card2 = player2CardTwo;
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        card1 = player3CardOne;
        card2 = player3CardTwo;
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        card1 = player4CardOne;
        card2 = player4CardTwo;
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        card1 = player5CardOne;
        card2 = player5CardTwo;
    }
    if (!([pokerGame.remainingPlayersInRound count] == 2 && (pokerGame.firstInRound.isAllIn || pokerGame.firstInRound.nextPlayerInRound.isAllIn))) {
        [self showAnimationWhenPlayer:aPlayer showsCard:card1 andCard:card2];
    }
    if (animated) {
        [self showAnimationWhenPlayerShowsCards:aPlayer]; //Diese Animation lässt die Kartenstärke aufblinken
    }
}

- (void) changePlayerOutlets_alreadyBetChips:(Player *)aPlayer
{
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        if (aPlayer.alreadyBetChips != 0) {
            player1AlreadyBetChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.alreadyBetChips] stringValue] stringByAppendingString:@"$"];
        }
        else {
            player1AlreadyBetChipsLabel.text = @"";
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        if (aPlayer.alreadyBetChips != 0) {
            player2AlreadyBetChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.alreadyBetChips] stringValue] stringByAppendingString:@"$"];
        }
        else {
            player2AlreadyBetChipsLabel.text = @"";
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        if (aPlayer.alreadyBetChips != 0) {
            player3AlreadyBetChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.alreadyBetChips] stringValue] stringByAppendingString:@"$"];
        }
        else {
            player3AlreadyBetChipsLabel.text = @"";
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        if (aPlayer.alreadyBetChips != 0) {
            player4AlreadyBetChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.alreadyBetChips] stringValue] stringByAppendingString:@"$"];
        }
        else {
            player4AlreadyBetChipsLabel.text = @"";
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        if (aPlayer.alreadyBetChips != 0) {
            player5AlreadyBetChipsLabel.text = [[[NSNumber numberWithFloat:aPlayer.alreadyBetChips] stringValue] stringByAppendingString:@"$"];
        }
        else {
            player5AlreadyBetChipsLabel.text = @"";
        }
    }
}

- (void) changePlayerOutlets_cards:(Player *)aPlayer
{
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        if (aPlayer.playerState == FOLDED || aPlayer.playerState == SET_UP) {
            player1CardOne.image = nil;
            player1CardTwo.image = nil;
        }
        else {
            if (aPlayer.isYou) {
                player1CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player1CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
                }
            }
            else {
                player1CardOne.image = [UIImage imageNamed:@"Nathan.PNG"];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player1CardTwo.image = [UIImage imageNamed:@"Nathan.PNG"];
                }
            }
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        if (aPlayer.playerState == FOLDED || aPlayer.playerState == SET_UP) {
            player2CardOne.image = nil;
            player2CardTwo.image = nil;
        }
        else {
            if (aPlayer.isYou) {
                player2CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player2CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
                }
            }
            else {
                player2CardOne.image = [UIImage imageNamed:@"Nathan.PNG"];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player2CardTwo.image = [UIImage imageNamed:@"Nathan.PNG"];
                }
            }
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        if (aPlayer.playerState == FOLDED || aPlayer.playerState == SET_UP) {
            player3CardOne.image = nil;
            player3CardTwo.image = nil;
        }
        else {
            if (aPlayer.isYou) {
                player3CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player3CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
                }
            }
            else {
                player3CardOne.image = [UIImage imageNamed:@"Nathan.PNG"];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player3CardTwo.image = [UIImage imageNamed:@"Nathan.PNG"];
                }
            }
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        if (aPlayer.playerState == FOLDED || aPlayer.playerState == SET_UP) {
            player4CardOne.image = nil;
            player4CardTwo.image = nil;

        }
        else {
            if (aPlayer.isYou) {
                player4CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player4CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
                }
            }
            else {
                player4CardOne.image = [UIImage imageNamed:@"Nathan.PNG"];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player4CardTwo.image = [UIImage imageNamed:@"Nathan.PNG"];
                }
            }
        }
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        if (aPlayer.playerState == FOLDED || aPlayer.playerState == SET_UP) {
            player5CardOne.image = nil;
            player5CardTwo.image = nil;
        }
        else {
            if (aPlayer.isYou) {
                player5CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player5CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
                }
            }
            else {
                player5CardOne.image = [UIImage imageNamed:@"Nathan.PNG"];
                if ([aPlayer.hand.cardsOnHand count] > 1) {
                    player5CardTwo.image = [UIImage imageNamed:@"Nathan.PNG"];
                }
            }
        }
    }
}

- (void) changePlayerOutlets_activePlayer: (Player* ) aPlayer
{
    //Falls man selbst dran ist: Outlets sichtbar machen:
    
    if (aPlayer.playerState == ACTIVE) {
        betLabel.hidden = NO;
        betButton.hidden = NO;
        foldButton.hidden = NO;
        betSlider.hidden = NO;
        if (pokerGame.highestBet - aPlayer.alreadyBetChips >= aPlayer.chips) {
            betSlider.minimumValue = aPlayer.chips;
        }
        else {
            betSlider.minimumValue = pokerGame.highestBet - aPlayer.alreadyBetChips;
        }
        betSlider.maximumValue = aPlayer.chips;
        betSlider.value = betSlider.minimumValue;
        betLabel.text = [[[NSNumber numberWithFloat:betSlider.value] stringValue] stringByAppendingString:@"$"];
        if (betSlider.value == 0) {
            /*[betButton setTitle:@"Check" forState:UIControlStateNormal];
             [betButton setTitle:@"Check" forState:UIControlStateApplication];
             [betButton setTitle:@"Check" forState:UIControlStateDisabled];
             [betButton setTitle:@"Check" forState:UIControlStateSelected];
             [betButton setTitle:@"Check" forState:UIControlStateReserved];
             [betButton setTitle:@"Check" forState:UIControlStateHighlighted];*/
            //betButton.titleLabel.text = @"Check";
            [betButton setTitle:@"Check" forSegmentAtIndex:0]; 
        }
        else if (betSlider.value == betSlider.minimumValue) {
            /* [betButton setTitle:@"Call" forState:UIControlStateNormal];
             [betButton setTitle:@"Call" forState:UIControlStateApplication];
             [betButton setTitle:@"Call" forState:UIControlStateDisabled];
             [betButton setTitle:@"Call" forState:UIControlStateSelected];
             [betButton setTitle:@"Call" forState:UIControlStateReserved];
             [betButton setTitle:@"Call" forState:UIControlStateHighlighted];*/
            [betButton setTitle:@"Call" forSegmentAtIndex:0]; 
            
            //betButton.titleLabel.text = @"Call";
        }
        else {
            /*[betButton setTitle:@"Bet" forState:UIControlStateNormal];
             [betButton setTitle:@"Bet" forState:UIControlStateApplication];
             [betButton setTitle:@"Bet" forState:UIControlStateDisabled];
             [betButton setTitle:@"Bet" forState:UIControlStateSelected];
             [betButton setTitle:@"Bet" forState:UIControlStateReserved];
             [betButton setTitle:@"Bet" forState:UIControlStateHighlighted];*/
            //betButton.titleLabel.text = @"Bet";
            [betButton setTitle:@"Bet" forSegmentAtIndex:0]; 
        }
    }
    else {
        betLabel.hidden = YES;
        betButton.hidden = YES;
        foldButton.hidden = YES;
        betSlider.hidden = YES;
    }
}

- (void) changePlayerOutlets_mayShowCards:(Player *)aPlayer
{
    if (aPlayer.mayShowCards) {
        showCardsButton.hidden = NO;
        throwCardsAwayButton.hidden = NO;
    }
    else {
        showCardsButton.hidden = YES;
        throwCardsAwayButton.hidden = YES;
    }
}

- (void) changeGameOutlets_pot
{
    potLabel.text = [[[NSNumber numberWithFloat:pokerGame.mainPot.chipsInPot] stringValue] stringByAppendingString:@"$"];
}

- (void) changeGameOutlets_cards
{
    if (pokerGame.gameState == FLOP1) {
        flopCardOneImage.image = [[pokerGame.cardsOnTable.flop objectAtIndex:0] playingCardImage];
    }
    else if (pokerGame.gameState == FLOP2) {
        flopCardTwoImage.image = [[pokerGame.cardsOnTable.flop objectAtIndex:1] playingCardImage];
    }
    else if (pokerGame.gameState == FLOP) {
        flopCardThreeImage.image = [[pokerGame.cardsOnTable.flop objectAtIndex:2] playingCardImage];
    }
    else if (pokerGame.gameState == TURN) {
        turnCardImage.image = pokerGame.cardsOnTable.turn.playingCardImage;
    }
    else if (pokerGame.gameState == RIVER) {
        UIImage* testImage = pokerGame.cardsOnTable.river.playingCardImage;
        riverCardImage.image = testImage;
    }
    else {
        flopCardOneImage.image = nil;
        flopCardTwoImage.image = nil;
        flopCardThreeImage.image = nil;
        turnCardImage.image = nil;
        riverCardImage.image = nil;
    }
}

- (void) changePlayerOutlets_sidePot:(Player *)aPlayer
{
    if (aPlayer.hasSidePot == YES) {
        if ([aPlayer.identification isEqualToString:@"player1"]) {
            sidePotLabel1.hidden = NO;
            sidePotLabel1.text = [[[NSNumber numberWithFloat:aPlayer.sidePot.chipsInPot] stringValue]   stringByAppendingString:@"$ (SP)"];
        }
        else if ([aPlayer.identification isEqualToString:@"player2"]) {
            sidePotLabel2.hidden = NO;
            sidePotLabel2.text = [[[NSNumber numberWithFloat:aPlayer.sidePot.chipsInPot] stringValue] stringByAppendingString:@"$ (SP)"];
        }
        else if ([aPlayer.identification isEqualToString:@"player3"]) {
            sidePotLabel3.hidden = NO;
            sidePotLabel3.text = [[[NSNumber numberWithFloat:aPlayer.sidePot.chipsInPot] stringValue] stringByAppendingString:@"$ (SP)"];
        }
        else if ([aPlayer.identification isEqualToString:@"player4"]) {
            sidePotLabel4.hidden = NO;
            sidePotLabel4.text = [[[NSNumber numberWithFloat:aPlayer.sidePot.chipsInPot] stringValue] stringByAppendingString:@"$ (SP)"];
        }
        else if ([aPlayer.identification isEqualToString:@"player5"]) {
            sidePotLabel5.hidden = NO;
            sidePotLabel5.text = [[[NSNumber numberWithFloat:aPlayer.sidePot.chipsInPot] stringValue] stringByAppendingString:@"$ (SP)"];
        }
    }
    else {
        sidePotLabel1.hidden = YES;
        sidePotLabel2.hidden = YES;
        sidePotLabel3.hidden = YES;
        sidePotLabel4.hidden = YES;
        sidePotLabel5.hidden = YES;
    }
}

- (void) showAnimationAtTheEndOfMoveOfPlayer:(Player *)aPlayer
{
    NSString* soundFilePath;
    UILabel* effectLabel;
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        effectLabel = effectLabel1;
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        effectLabel = effectLabel2;
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        effectLabel = effectLabel3;
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        effectLabel = effectLabel4;
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        effectLabel = effectLabel5;
    }
    if (aPlayer.playerState == CHECKED) {
        effectLabel.text = @"Check!";
        effectLabel.textColor = [UIColor greenColor];
        soundFilePath = [[NSBundle mainBundle] pathForResource:@"check" ofType:@"wav"];

    }
    else if (aPlayer.playerState == CALLED) {
        effectLabel.text = @"Call!";
        effectLabel.textColor = [UIColor greenColor];
        soundFilePath = [[NSBundle mainBundle] pathForResource:@"money" ofType:@"wav"];
    }
    else if (aPlayer.playerState == RAISED) {
        effectLabel.text = @"Raise!";
        effectLabel.textColor = [UIColor orangeColor];
        soundFilePath = [[NSBundle mainBundle] pathForResource:@"money" ofType:@"wav"];
    }
    else if (aPlayer.playerState == BET) {
        effectLabel.text = @"Bet!";
        effectLabel.textColor = [UIColor orangeColor];
        soundFilePath = [[NSBundle mainBundle] pathForResource:@"money" ofType:@"wav"];
    }
    else if (aPlayer.playerState == ALL_IN) {
        effectLabel.text = @"ALL IN!";
        effectLabel.textColor = [UIColor orangeColor];
        soundFilePath = [[NSBundle mainBundle] pathForResource:@"money" ofType:@"wav"];
    }
    else if (aPlayer.playerState == FOLDED) {
        effectLabel.text = @"Fold!";
        effectLabel.textColor = [UIColor redColor];
        soundFilePath = [[NSBundle mainBundle] pathForResource:@"fold" ofType:@"wav"];
    }
    
    moneySoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:nil];
    moneySoundPlayer.delegate = self;
    moneySoundPlayer.volume = 0.2;
    [moneySoundPlayer prepareToPlay];
    BOOL ok = [moneySoundPlayer play];
    NSLog(@"ok: %@", ok ? @"Y" : @"N");
    
    [effectLabel bringSubviewToFront:self.view];
    effectLabel.alpha = 1.0;
    [self fadeOutLabel:effectLabel duration:2.0 option:nil];
}

- (void) showAnimationWhenPlayerShowsCards:(Player *)aPlayer
{
    UILabel* effectLabel;
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        effectLabel = effectLabel1;
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        effectLabel = effectLabel2;
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        effectLabel = effectLabel3;
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        effectLabel = effectLabel4;
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        effectLabel = effectLabel5;
    }
    effectLabel.text = aPlayer.hand.fiveBestCards.cardValuesAsString;
    [effectLabel bringSubviewToFront:self.view];
    if (aPlayer.doesNotWinAnything) {
        effectLabel.textColor = [UIColor redColor];
    }
    else {
        effectLabel.textColor = [UIColor greenColor];
    }
    effectLabel.alpha = 1.0;
    [self fadeOutLabel:effectLabel duration:2.0 option:nil];    
}

- (void) showAnimationWhenPlayer: (Player* ) aPlayer showsCard:(UIImageView *)card1 andCard:(UIImageView *)card2
{
    CGRect startFrame1;
    CGRect destinationFrame1;
    CGRect startFrame2;
    CGRect destinationFrame2;
    if (!aPlayer.isYou) {
        destinationFrame1 = CGRectMake(card1.frame.origin.x + 16.0, card1.frame.origin.y, 1, 44);
        destinationFrame2 = CGRectMake(card2.frame.origin.x + 16.0, card2.frame.origin.y, 1, 44);
        startFrame1 = card1.frame;
        startFrame2 = card2.frame;
    }
    else {
        destinationFrame1 = CGRectMake(card1.frame.origin.x, card1.frame.origin.y - 15, 32, 44);
        destinationFrame2 = CGRectMake(card2.frame.origin.x, card2.frame.origin.y - 15, 32, 44);
    }

    //Sound abspielen:
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"cards1" ofType:@"wav"];
    cardSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:nil];
    cardSoundPlayer.delegate = self;
    cardSoundPlayer.volume = 0.1;
    [cardSoundPlayer prepareToPlay];
    [cardSoundPlayer play];
    
    [UIView animateWithDuration:0.15 animations:^{
        card1.frame = destinationFrame1;
        card2.frame = destinationFrame2;
    }
    completion:^(BOOL finished) {
            if (finished) {
                if (!aPlayer.isYou) {
                    card1.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
                    card2.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
                    [UIView animateWithDuration:0.15 animations:^{
                        card1.frame = startFrame1;
                        card2.frame = startFrame2;
                    }  completion:^(BOOL finished) {
                        if (finished) {
                            [self showAnimationForFiveBestCardsOfPlayer:aPlayer withCard:card1 andCard:card2];
                        }
                    }];
                }
                else {
                    [self showAnimationForFiveBestCardsOfPlayer:aPlayer withCard:card1 andCard:card2];
                }
            }
        }];
}

- (void) showAnimationForFiveBestCardsOfPlayer:(Player *)aPlayer withCard:(UIImageView *)card1 andCard:(UIImageView *)card2
{
    [self resetTemporaryOutletsAndBadCards];
    NSMutableArray* goodCards = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray* badCards = [[NSMutableArray alloc] initWithCapacity:2];
    PlayingCard* currentPlayingCard;
    currentPlayingCard = [aPlayer.hand.cardsOnHand objectAtIndex:0];
    if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
        [goodCards addObject:card1];
    }
    else {
        [badCards addObject:card1];
    }
    
    currentPlayingCard = [aPlayer.hand.cardsOnHand objectAtIndex:1];
    if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
        [goodCards addObject:card2];
    }
    else {
        [badCards addObject:card2];
    }
    
    if ([pokerGame.cardsOnTable.flop count] != 0) {
        currentPlayingCard = [pokerGame.cardsOnTable.flop objectAtIndex:0];
        if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
            [goodCards addObject:flopCardOneImage];
        }
        else {
            [badCards addObject:flopCardOneImage];
        }
    
        currentPlayingCard = [pokerGame.cardsOnTable.flop objectAtIndex:1];
        if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
            [goodCards addObject:flopCardTwoImage];
        }
        else {
            [badCards addObject:flopCardTwoImage];
        } 
    
        currentPlayingCard = [pokerGame.cardsOnTable.flop objectAtIndex:2];
        if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
            [goodCards addObject:flopCardThreeImage];
        }
        else {
            [badCards addObject:flopCardThreeImage];
        }
    }
    if (pokerGame.cardsOnTable.turn != nil) {
        currentPlayingCard = pokerGame.cardsOnTable.turn;
        if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
            [goodCards addObject:turnCardImage];
        }
        else {
            [badCards addObject:turnCardImage];
        }
    }
    
    if (pokerGame.cardsOnTable.river != nil) {
        currentPlayingCard = pokerGame.cardsOnTable.river;
        if ([aPlayer.hand.fiveBestCards.arrayOfFiveBestCards containsObject:currentPlayingCard]) {
            [goodCards addObject:riverCardImage];
        }
        else {
            [badCards addObject:riverCardImage];
        }
    }
    if (temporaryOutletsAndBadCards == nil) {
        temporaryOutletsAndBadCards = [[NSMutableArray alloc] initWithCapacity:5];
    }
    for (UIImageView* imageView in badCards) {
        UILabel* aLabel = [[UILabel alloc] initWithFrame:imageView.frame];
        [self.view addSubview:aLabel];
        [self.view bringSubviewToFront:aLabel];
        [temporaryOutletsAndBadCards addObject:aLabel];
        aLabel.backgroundColor = [UIColor darkGrayColor];
        aLabel.text = @"";
        aLabel.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        for (UILabel* label in temporaryOutletsAndBadCards) {
            label.alpha = 0.7;
        }
    }
        completion:nil
    ];
}

- (void) resetTemporaryOutletsAndBadCards
{
    for (UILabel* aLabel in temporaryOutletsAndBadCards) {
        [aLabel removeFromSuperview];
    }
    [temporaryOutletsAndBadCards removeAllObjects];
}

- (void) showAnimationWhenGameIsPaused
{
    NSMutableArray* allOutlets = [NSMutableArray arrayWithArray:[self.view subviews]];
    [allOutlets removeObject:pauseTableView];
    if (paused) {
        pauseTableView.alpha = 0.0;
        pauseTableView.hidden = NO;
        if (pauseLabel == nil) {
            pauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,480,300)];
            pauseLabel.text = @"";
            pauseLabel.backgroundColor = [UIColor lightGrayColor];
        }
        pauseLabel.hidden = NO;
        pauseLabel.alpha = 0.0;
        [self.view addSubview:pauseLabel];
        [self.view bringSubviewToFront:pauseLabel];
        [self.view bringSubviewToFront:pauseTableView];

        [UIView animateWithDuration:1.0 animations:^{
            pauseLabel.alpha = 0.8;
            pauseTableView.alpha = 1.0;
            //self.view.backgroundColor = [UIColor lightGrayColor];
        }
        completion:nil];
    }
    else {
        [UIView animateWithDuration:1.0 animations:^{
            pauseLabel.alpha = 0.0;
            pauseTableView.alpha = 0.0;
        }
    completion:^(BOOL finished) {
        if (finished) {
            self.pauseTableView.hidden = YES;
            pauseLabel.hidden = YES;
            
            //Outlets enablen:
            betSlider.userInteractionEnabled = YES;
            betButton.userInteractionEnabled = YES;
            foldButton.userInteractionEnabled = YES;
            showCardsButton.userInteractionEnabled = YES;
            throwCardsAwayButton.userInteractionEnabled = YES;
            pauseButton.userInteractionEnabled = YES;
        }
    } ];
    }
    
}

- (void) showAnimationWhenCardPopsFromDeck
{
    CGRect destinationFrame;
    CGRect startFrame = cardDeckImage.frame;
    if ([pokerGame.cardDeck.popsFor isEqualToString:@"player1_1"]) {
        destinationFrame = player1CardOne.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player1_2"]) {
        destinationFrame = player1CardTwo.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player2_1"]) {
        destinationFrame = player2CardOne.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player2_2"]) {
        destinationFrame = player2CardTwo.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player3_1"]) {
        destinationFrame = player3CardOne.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player3_2"]) {
        destinationFrame = player3CardTwo.frame;
    }    
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player4_1"]) {
        destinationFrame = player4CardOne.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player4_2"]) {
        destinationFrame = player4CardTwo.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player5_1"]) {
        destinationFrame = player5CardOne.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"player5_2"]) {
        destinationFrame = player5CardTwo.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"flop1"]) {
        destinationFrame = flopCardOneImage.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"flop2"]) {
        destinationFrame = flopCardTwoImage.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"flop3"]) {
        destinationFrame = flopCardThreeImage.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"turn"]) {
        destinationFrame = turnCardImage.frame;
    }
    else if ([pokerGame.cardDeck.popsFor isEqualToString:@"river"]) {
        destinationFrame = riverCardImage.frame;
    }
    [self movePlayingCardFromFrame:startFrame toDestinationFrame:destinationFrame duration:0.2 option:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[Player class]]) {
        if ([keyPath isEqualToString:@"alreadyBetChips"]) {
            Player* aPlayer = (Player* ) object;
            [self changePlayerOutlets_alreadyBetChips:aPlayer];
        }
        else if ([keyPath isEqualToString:@"chips"]) {
            Player* aPlayer = (Player* ) object;
            [self changePlayerOutlets_chips:aPlayer];
        }
        else if ([keyPath isEqualToString:@"playerState"]) {
            Player* aPlayer = (Player* ) object;
            [self changePlayerOutlets_cards:aPlayer];
            if (aPlayer.playerState == FOLDED) {
                [self showAnimationWhenPlayerFolds:aPlayer];
            }
            if (aPlayer.playerState == CHECKED || aPlayer.playerState == CALLED || aPlayer.playerState == FOLDED || aPlayer.playerState == RAISED || aPlayer.playerState == BET || aPlayer.playerState == ALL_IN) {
                [self showAnimationAtTheEndOfMoveOfPlayer:aPlayer];
            }
            if (aPlayer.isYou == YES) {
                [self changePlayerOutlets_activePlayer:aPlayer];
            }
        }
        else if ([keyPath isEqualToString:@"hasSidePot"]) {
            Player* aPlayer = (Player* ) object;
            if (aPlayer.hasSidePot == YES) {
                [aPlayer addObserver:self forKeyPath:@"sidePot.chipsInPot" options:0 context:nil];
            }
            else {
                [self changePlayerOutlets_sidePot:aPlayer];
            }
        }
        else if ([keyPath isEqualToString:@"sidePot.chipsInPot"]) {
            Player* aPlayer = (Player* ) object;
            [self changePlayerOutlets_sidePot:aPlayer];
        }
        else if ([keyPath isEqualToString:@"showsCards"]) {
            Player* aPlayer = (Player* ) object;
            if (aPlayer.showsCards) {
                [self showCardsOfPlayer:aPlayer withAnimation:YES];
            }
        }
        else if ([keyPath isEqualToString:@"mayShowCards"] && pokerGame.gameState == SHOW_DOWN) {
            Player* aPlayer = (Player* ) object;
            if (aPlayer.isYou) {
                [self changePlayerOutlets_mayShowCards:aPlayer];
            }
            else {
                int n = arc4random() % 3;
                if (n==1) {
                    [self playerThrowsCardsAway:aPlayer]; // schmeißt Karten weg
                }
                else {
                    [aPlayer showCards:NO];
                }
            }
        }
        else if ([keyPath isEqualToString:@"createdTimerDuringPause"]) {
            Player* aPlayer = (Player* ) object;
            if (aPlayer.createdTimerDuringPause) {
                NSTimer* timer = [aPlayer.currentlyRunningTimersWithCreationTimes objectAtIndex:([aPlayer.currentlyRunningTimersWithCreationTimes count]-2)];
                NSDate* creationTime = [aPlayer.currentlyRunningTimersWithCreationTimes lastObject];
                [self pauseRunningTimer:timer creationTime:creationTime];
            }
        }
        else if ([keyPath isEqualToString:@"counter"]) {
            Player* aPlayer = (Player* ) object;
            [self changeGameOutlets_playerCountDown:aPlayer];
        }
    }
    else if ([object isKindOfClass:[PokerGame class]]) {
        if ([keyPath isEqualToString:@"mainPot.chipsInPot"]) {
            [self changeGameOutlets_pot];
        }
        else if ([keyPath isEqualToString:@"gameState"]) {
            if (pokerGame.gameState == TWO_PLAYERS_ALL_IN_SHOW_DOWN) {
                Player* player1 = [pokerGame.remainingPlayersInRound objectAtIndex:0];
                Player* player2 = [pokerGame.remainingPlayersInRound objectAtIndex:1];
                [self showCardsOfPlayer:player1 withAnimation:NO];
                [self showCardsOfPlayer:player2 withAnimation:NO];
            }
            else if (pokerGame.gameState != SHOW_DOWN) {
                [self changeGameOutlets_cards];
            }
            if (pokerGame.gameState == SETUP) {
                [self resetTemporaryOutletsAndBadCards];
                player1CardOne.frame = CGRectMake(270, 205, 32, 44);
                player1CardTwo.frame = CGRectMake(310, 205, 32, 44);
                [self resetObservationForSidePots];
            }
        }
        else if ([keyPath isEqualToString:@"cardDeck.popsFor"]) {
            [self showAnimationWhenCardPopsFromDeck];
        }
        else if ([keyPath isEqualToString:@"createdTimerDuringPause"]) {
            if (pokerGame.createdTimerDuringPause) {
                NSTimer* timer = [pokerGame.currentlyRunningTimersWithCreationTimes objectAtIndex:([pokerGame.currentlyRunningTimersWithCreationTimes count]-2)];
                NSDate* creationTime = [pokerGame.currentlyRunningTimersWithCreationTimes lastObject];
                [self pauseRunningTimer:timer creationTime:creationTime];
            }
        }
        else if ([keyPath isEqualToString:@"blindsCountdown"]) {
            [self changeGameOutlets_blindsCountdown];
        }
        else if ([keyPath isEqualToString:@"roundsPlayed"]) {
            [self changeGameOutlets_roundsPlayed];
        }
        else if ([keyPath isEqualToString:@"smallBlind"]) {
            if (!(pokerGame.gameSettings.startBlinds == pokerGame.smallBlind)) {
                [self showAnimationWhenBlindsAreIncreased];
            }
        }
    }
}

- (void) resetObservationForSidePots
{
    for (Player* aPlayer in pokerGame.allPlayers) {
        if (aPlayer.hasSidePot) {
            [aPlayer removeObserver:self forKeyPath:@"sidePot.chipsInPot"];
        }
    }
}

- (void) setUpGame
{
    if ([pokerGame.gameSettings.blinds isEqualToString:@"nach Minuten"]) {
        [pokerGame addObserver:self forKeyPath:@"blindsCountdown" options:0 context:nil];
        blindsCountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 80, 22)];
        blindsCountdownLabel.textColor = [UIColor blueColor];
        blindsCountdownLabel.font = [UIFont fontWithName:@"System" size:14.0];
        blindsCountdownLabel.text = @"";
        blindsCountdownLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:blindsCountdownLabel];
    }
    
    [pokerGame addObserver:self forKeyPath:@"roundsPlayed" options:0 context:nil];
    roundsPlayedLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,2,50,22)];
    roundsPlayedLabel.textColor = [UIColor blueColor];
    roundsPlayedLabel.backgroundColor = [UIColor clearColor];
    roundsPlayedLabel.text = @"0";
    roundsPlayedLabel.font = [UIFont fontWithName:@"System" size:14.0];
    [self.view addSubview:roundsPlayedLabel];
    
    [pokerGame addObserver:self forKeyPath:@"smallBlind" options:0 context:nil];
    [pokerGame addObserver:self forKeyPath:@"cardDeck.popsFor" options:0 context:nil];
    [pokerGame addObserver:self forKeyPath:@"mainPot.chipsInPot" options:0 context:nil];
    [pokerGame addObserver:self forKeyPath:@"gameState" options:0 context:nil];
    //der aktuell laufende Timer soll immer beobachtet werden: fuer Pausierungen:
    [pokerGame addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];
    [pokerGame prepareGame];
}

- (IBAction)cardsTouchDown:(id)sender
{
    //Karten vergrößern
    CGRect destinationFrame1 = CGRectMake(player1CardOne.frame.origin.x - 50, player1CardOne.frame.origin.y - 68.75, 82, 112.75);
    CGRect destinationFrame2 = CGRectMake(player1CardTwo.frame.origin.x, player1CardTwo.frame.origin.y - 68.75, 82, 112.75);
    [UIView animateWithDuration:0.2 animations:^{
        player1CardOne.frame = destinationFrame1;
        player1CardTwo.frame = destinationFrame2;
    }
                     completion:nil];
    
    //jetzt noch die besten fünf Karten anzeigen:
    Player* aPlayer = [pokerGame.allPlayers objectAtIndex:0]; // das bist du:
    [aPlayer.hand defineValueOfCardsWithTableCards:pokerGame.cardsOnTable];
    UIImageView* card1 = player1CardOne;
    UIImageView* card2 = player1CardTwo;
    [self showAnimationForFiveBestCardsOfPlayer:aPlayer withCard:card1 andCard:card2];
}

- (IBAction)cardsTouchUp:(id)sender
{
    //Karten wieder verkleinern
    [UIView animateWithDuration:0.2 animations:^{
        player1CardOne.frame = CGRectMake(270, 205, 32, 44);
        player1CardTwo.frame = CGRectMake(310, 205, 32, 44);
    } completion:nil];
    
    //und five-best-cards-Anzeige ausblenden:
    [self resetTemporaryOutletsAndBadCards];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //view-Hintergrund:
    /*float red = 27/255.0;
    float green = 160/255.0;
    float blue = 184/255.0;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.7];*/

    //immer benötigte Outlets:
    blindsIncreasedLabel.alpha = 0.0;
    
    cardDeckImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,22,32,44)];
    cardDeckImage.image = [UIImage imageNamed:@"Nathan.PNG"];
    [self.view addSubview:cardDeckImage];
        
    pauseTableView = [[UITableView alloc] initWithFrame:CGRectMake(120, 75, 240, 150) style:UITableViewStyleGrouped];
    [self.view addSubview:pauseTableView];
    pauseTableView.delegate = self;
    pauseTableView.dataSource = self;
    [pauseTableView reloadData];
    pauseTableView.backgroundColor = [UIColor clearColor];
    pauseTableView.hidden = YES;
    pauseTableView.alpha = 0.0;
    
    
    potLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 50, 20)];
    //player1ChipsLabel.text = @"Text";
    [self.view addSubview:potLabel];
    potLabel.backgroundColor = [UIColor clearColor];
    potLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    
    betButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Check"]];
	betButton.segmentedControlStyle = UISegmentedControlStyleBar;
	betButton.momentary = YES;
	betButton.tintColor = [UIColor darkGrayColor];
    [betButton addTarget:self action:@selector(betButtonPressed:) 
        forControlEvents: UIControlEventValueChanged];
    betButton.frame = CGRectMake(390, 253, 80, 30);
    [self.view addSubview:betButton];
    
    foldButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Fold"]];
	foldButton.segmentedControlStyle = UISegmentedControlStyleBar;
	foldButton.momentary = YES;
	foldButton.tintColor = [UIColor darkGrayColor];
    [foldButton addTarget:self action:@selector(foldButtonPressed:) 
         forControlEvents: UIControlEventValueChanged];
    foldButton.frame = CGRectMake(10, 253, 80, 30);
    [self.view addSubview:foldButton];
    
    throwCardsAwayButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Fold"]];
    throwCardsAwayButton.segmentedControlStyle = UISegmentedControlStyleBar;
    throwCardsAwayButton.momentary = YES;
    throwCardsAwayButton.tintColor = [UIColor darkGrayColor];
    [throwCardsAwayButton addTarget:self action:@selector(throwCardsAwayButtonClicked:) forControlEvents:UIControlEventValueChanged];
    throwCardsAwayButton.frame = CGRectMake(100, 253, 80, 30);
    throwCardsAwayButton.hidden = YES;
    [self.view addSubview:throwCardsAwayButton];
    
    showCardsButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Show"]];
    showCardsButton.segmentedControlStyle = UISegmentedControlStyleBar;
    showCardsButton.momentary = YES;
    showCardsButton.tintColor = [UIColor darkGrayColor];
    [showCardsButton addTarget:self action:@selector(showCardsButtonClicked:) forControlEvents:UIControlEventValueChanged];
    showCardsButton.frame = CGRectMake(300, 253, 80, 30);
    showCardsButton.hidden = YES;
    [self.view addSubview:showCardsButton];
    
    pauseButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"II"]];
    pauseButton.segmentedControlStyle = UISegmentedControlStyleBar;
    pauseButton.momentary = YES;
    pauseButton.tintColor = [UIColor darkGrayColor];
    [pauseButton addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventValueChanged];
    pauseButton.frame = CGRectMake(450,8,25,25);
    [self.view addSubview:pauseButton];
    
    betLabel = [[UILabel alloc]initWithFrame:CGRectMake(222, 273, 70, 20)];
    betLabel.text = [[[NSNumber numberWithFloat:roundNumberOnTwoFigures(betSlider.value)] stringValue] stringByAppendingString:@"$"];
    [self.view addSubview:betLabel];
    betLabel.backgroundColor = [UIColor clearColor];
    betLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    
    // Outlets für Player1
    
    player1NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(222, 183, 40, 20)];
    player1NameLabel.text = @"Nathan";
    [self.view addSubview:player1NameLabel];
    player1NameLabel.backgroundColor = [UIColor clearColor];
    player1NameLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    effectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(222,183,120,20)];
    effectLabel1.alpha = 0.0;
    [self.view addSubview:effectLabel1];
    effectLabel1.backgroundColor = [UIColor blackColor];
    effectLabel1.font = [UIFont fontWithName:@"System" size:13.0];
    
    player1ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(222, 203, 40, 40)];
    [self.view addSubview:player1ProfilePictureImage];
    [player1ProfilePictureImage setImage:[UIImage imageNamed: @"Nathan.png"]];
    
    player1CardOne = [[UIImageView alloc]initWithFrame:CGRectMake(270, 205, 32, 44)];
    [self.view addSubview:player1CardOne];

    
    player1CardTwo = [[UIImageView alloc]initWithFrame:CGRectMake(310, 205, 32, 44)];
    [self.view addSubview:player1CardTwo];
    
    
    //unsichtbarer Button, der hinten den Karten liegt und auf User-Interaction reagiert:
    UIButton* cardsButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 205, 72, 44)];
    cardsButton.titleLabel.text = @"";
    cardsButton.titleLabel.backgroundColor = [UIColor clearColor];
    cardsButton.backgroundColor = [UIColor clearColor];
    [cardsButton addTarget:self action:@selector(cardsTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [cardsButton addTarget:self action:@selector(cardsTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cardsButton];
    [self.view bringSubviewToFront:cardsButton];
    
    
    player1ChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(222, 245, 50, 20)];
    player1ChipsLabel.text = @"Chips";
    [self.view addSubview:player1ChipsLabel];
    player1ChipsLabel.backgroundColor = [UIColor clearColor];
    player1ChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    
    player1AlreadyBetChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(265, 183, 40, 20)];
    player1AlreadyBetChipsLabel.text = @"Text";
    [self.view addSubview:player1AlreadyBetChipsLabel];
    player1AlreadyBetChipsLabel.backgroundColor = [UIColor clearColor];
    player1AlreadyBetChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    
    sidePotLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 183, 40, 20)];
    sidePotLabel1.text = @"SP";
    [self.view addSubview:sidePotLabel1];
    sidePotLabel1.backgroundColor = [UIColor clearColor];
    sidePotLabel1.font = [UIFont fontWithName:@"System" size: 13.0];
    
    // Outlets für Player2
    
    player2NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 87, 40, 20)];
    player2NameLabel.text = @"Eric C.";
    [self.view addSubview:player2NameLabel];
    player2NameLabel.backgroundColor = [UIColor clearColor];
    player2NameLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    effectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(17,87,120,20)];
    effectLabel2.alpha = 0.0;
    [self.view addSubview:effectLabel2];
    effectLabel2.backgroundColor = [UIColor blackColor];
    effectLabel2.font = [UIFont fontWithName:@"System" size:13.0];
    
    player2ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 107, 40, 40)];
    [self.view addSubview:player2ProfilePictureImage];
    [player2ProfilePictureImage setImage:[UIImage imageNamed: @"Cartman.png"]];
    
    player2CardOne = [[UIImageView alloc]initWithFrame:CGRectMake(12, 107, 32, 44)];
    [self.view addSubview:player2CardOne];
    
    player2CardTwo = [[UIImageView alloc]initWithFrame:CGRectMake(38, 107, 32, 44)];
    [self.view addSubview:player2CardTwo];


    player2AlreadyBetChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 107, 40, 20)];
    player2AlreadyBetChipsLabel.text = @"Text";
    [self.view addSubview:player2AlreadyBetChipsLabel];
    player2AlreadyBetChipsLabel.backgroundColor = [UIColor clearColor];
    player2AlreadyBetChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
    
    sidePotLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(65, 130, 40, 20)];
    sidePotLabel2.text = @"SP";
    [self.view addSubview:sidePotLabel2];
    sidePotLabel2.backgroundColor = [UIColor clearColor];
    sidePotLabel2.font = [UIFont fontWithName:@"System" size: 13.0];
    
    if (pokerGame.gameSettings.anzahlKI >=2) {
        
        //Player3 Outlets
        
        player3NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(121, 2, 40, 20)];
        player3NameLabel.text = @"Stan M.";
        [self.view addSubview:player3NameLabel];
        player3NameLabel.backgroundColor = [UIColor clearColor];
        player3NameLabel.font = [UIFont fontWithName:@"System" size: 13.0];
        effectLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(121,2,120,20)];
        effectLabel3.alpha = 0.0;
        [self.view addSubview:effectLabel3];
        effectLabel3.backgroundColor = [UIColor blackColor];
        effectLabel3.font = [UIFont fontWithName:@"System" size:13.0];
        
        player3ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(121, 22, 40, 40)];
        [self.view addSubview:player3ProfilePictureImage];
        [player3ProfilePictureImage setImage:[UIImage imageNamed: @"Stan.png"]];
        
        player3CardOne = [[UIImageView alloc]initWithFrame:CGRectMake(116, 28, 32, 44)];
        [self.view addSubview:player3CardOne];
        
        player3CardTwo = [[UIImageView alloc]initWithFrame:CGRectMake(142, 28, 32, 44)];
        [self.view addSubview:player3CardTwo];
        
        player3ChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(121, 65, 50, 20)];
        player3ChipsLabel.text = @"Chips";
        [self.view addSubview:player3ChipsLabel];
        player3ChipsLabel.backgroundColor = [UIColor clearColor];
        player3ChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
        
        player3AlreadyBetChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(173, 65, 40, 20)];
        player3AlreadyBetChipsLabel.text = @"Text";
        [self.view addSubview:player3AlreadyBetChipsLabel];
        player3AlreadyBetChipsLabel.backgroundColor = [UIColor clearColor];
        player3AlreadyBetChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
        
        sidePotLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(70, 65, 40, 20)];
        sidePotLabel3.text = @"SP";
        [self.view addSubview:sidePotLabel3];
        sidePotLabel3.backgroundColor = [UIColor clearColor];
        sidePotLabel3.font = [UIFont fontWithName:@"System" size: 13.0];
        
        if (pokerGame.gameSettings.anzahlKI >= 3) {
            
            //Player4 Outlets
            
            player4NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(313, 2, 40, 20)];
            player4NameLabel.text = @"Kyle B.";
            [self.view addSubview:player4NameLabel];
            player4NameLabel.backgroundColor = [UIColor clearColor];
            player4NameLabel.font = [UIFont fontWithName:@"System" size: 13.0];
            effectLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(313,2,120,20)];
            effectLabel4.alpha = 0.0;
            [self.view addSubview:effectLabel4];
            effectLabel4.backgroundColor = [UIColor blackColor];
            effectLabel4.font = [UIFont fontWithName:@"System" size:13.0];
            
            player4ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(313, 22, 40, 40)];
            [self.view addSubview:player4ProfilePictureImage];
            [player4ProfilePictureImage setImage:[UIImage imageNamed: @"Kyle.png"]];
            
            player4CardOne = [[UIImageView alloc]initWithFrame:CGRectMake(308, 28, 32, 44)];
            [self.view addSubview:player4CardOne];
            
            player4CardTwo = [[UIImageView alloc]initWithFrame:CGRectMake(334, 28, 32, 44)];
            [self.view addSubview:player4CardTwo];
            
            player4ChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(313, 65, 50, 20)];
            player4ChipsLabel.text = @"Chips";
            [self.view addSubview:player4ChipsLabel];
            player4ChipsLabel.backgroundColor = [UIColor clearColor];
            player4ChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
            
            player4AlreadyBetChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(261, 65, 40, 20)];
            player4AlreadyBetChipsLabel.text = @"Text";
            [self.view addSubview:player4AlreadyBetChipsLabel];
            player4AlreadyBetChipsLabel.backgroundColor = [UIColor clearColor];
            player4AlreadyBetChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
            
            sidePotLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(363, 65, 40, 20)];
            sidePotLabel4.text = @"SP";
            [self.view addSubview:sidePotLabel4];
            sidePotLabel4.backgroundColor = [UIColor clearColor];
            sidePotLabel4.font = [UIFont fontWithName:@"System" size: 13.0];
    
            if (pokerGame.gameSettings.anzahlKI == 4) {
                
                //Player5 Outlets
                
                player5NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(427, 87, 40, 20)];
                player5NameLabel.text = @"Kenny M.";
                [self.view addSubview:player5NameLabel];
                player5NameLabel.backgroundColor = [UIColor clearColor];
                player5NameLabel.font = [UIFont fontWithName:@"System" size: 13.0];
                effectLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(427,87,120,20)];
                effectLabel5.alpha = 0.0;
                [self.view addSubview:effectLabel5];
                effectLabel5.backgroundColor = [UIColor blackColor];
                effectLabel5.font = [UIFont fontWithName:@"System" size:13.0];
                
                player5ProfilePictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(427, 107, 40, 40)];
                [self.view addSubview:player5ProfilePictureImage];
                [player5ProfilePictureImage setImage:[UIImage imageNamed: @"Kenny.png"]];
                
                player5CardOne = [[UIImageView alloc]initWithFrame:CGRectMake(422, 107, 32, 44)];
                [self.view addSubview:player5CardOne];
                
                player5CardTwo = [[UIImageView alloc]initWithFrame:CGRectMake(448, 107, 32, 44)];
                [self.view addSubview:player5CardTwo];
                
                player5ChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(427, 149, 50, 20)];
                player5ChipsLabel.text = @"Chips";
                [self.view addSubview:player5ChipsLabel];
                player5ChipsLabel.backgroundColor = [UIColor clearColor];
                player5ChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
                
                player5AlreadyBetChipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(385, 107, 40, 20)];
                player5AlreadyBetChipsLabel.text = @"Text";
                [self.view addSubview:player5AlreadyBetChipsLabel];
                player5AlreadyBetChipsLabel.backgroundColor = [UIColor clearColor];
                player5AlreadyBetChipsLabel.font = [UIFont fontWithName:@"System" size: 13.0];
                
                sidePotLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(380, 149, 50, 20)];
                sidePotLabel5.text = @"SP";
                [self.view addSubview:sidePotLabel5];
                sidePotLabel5.backgroundColor = [UIColor clearColor];
                sidePotLabel5.font = [UIFont fontWithName:@"System" size: 13.0];
                
            }
        }
    }
    //betButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    //foldButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    // betButton.autoresizesSubviews = YES;
    // Spieler erstellen und KVO aktivieren.

    // Spieler erstellen und KVO aktivieren.

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString* ) tableView: (UITableView* ) tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Game Paused";
}

- (UITableViewCell* ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* MyIdentifier = @"MyIdentifier";
    UITableViewCell* cell = [pauseTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Resume";
    }
    else {
        cell.textLabel.text = @"Leave Game";
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        paused = NO;
        [self pauseOrUnpause];
        [self showAnimationWhenGameIsPaused];
    }
    else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"leaveGame" sender:self];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setUpPlayers];
    //Spiel vorbereiten (prepareGame ordnet Spieler und allokiert wichtige Objekte) und KVO aktivieren
    [self setUpGame];
    
    //Karten ausgeben usw.
    [pokerGame prepareNewRound];
    [pokerGame performSelector:@selector(startBetRound) withObject:nil afterDelay:3.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) fadeOutLabel: (UILabel* ) effectLabel duration: (float) secs option: (UIViewAnimationOptions) option
{
    [UIView animateWithDuration:secs animations:^{
        effectLabel.alpha = 0.0;
    }
                     completion:nil];
}

- (void) movePlayingCardFromFrame: (CGRect) startFrame toDestinationFrame:(CGRect)destinationFrame duration:(float)secs option:(UIViewAnimationOptions)option
{
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"cards3" ofType:@"wav"];
    cardSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:nil];
    cardSoundPlayer.delegate = self;
    cardSoundPlayer.volume = 0.1;
    [cardSoundPlayer prepareToPlay];
    BOOL ok = [cardSoundPlayer play];
    NSLog(@"ok: %@", ok ? @"Y" : @"N");
    
    
    
    UIImageView* temporaryImageView = [[UIImageView alloc] initWithFrame:startFrame];
    temporaryImageView.image = [UIImage imageNamed:@"Nathan.PNG"];
    [self.view addSubview:temporaryImageView];
    [UIView animateWithDuration:secs animations:^{
        temporaryImageView.frame = destinationFrame;
    }
    completion:^(BOOL finished) {
        [self removeTemporaryOutlet:temporaryImageView];
    }];
}

- (void) removeTemporaryOutlet:(UIImageView* )outlet
{
    [outlet removeFromSuperview];
}

- (void) changeGameOutlets_roundsPlayed
{
    roundsPlayedLabel.text = [NSString stringWithFormat:@"%i",pokerGame.roundsPlayed];
}

- (void) changeGameOutlets_blindsCountdown
{
    if (pokerGame.blindsCountdown >= 10.0) {
        if (blindsCountdownLabel.textColor = [UIColor redColor]) {
            blindsCountdownLabel.textColor = [UIColor blueColor];
        }
    }
    else {
        blindsCountdownLabel.textColor = [UIColor redColor];
    }
    blindsCountdownLabel.text = [NSString stringWithFormat:@"%i",pokerGame.blindsCountdown];
}

- (void) showAnimationWhenBlindsAreIncreased
{
    blindsIncreasedLabel.alpha = 1.0;
    [self fadeOutLabel:blindsIncreasedLabel duration:3.0 option:nil];
}

- (void) showAnimationWhenPlayerFolds:(Player *)aPlayer
{
    CGRect destinationFrame = cardDeckImage.frame;
    CGRect startFrame1;
    CGRect startFrame2;
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        startFrame1 = player1CardOne.frame;
        startFrame2 = player1CardTwo.frame;
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        startFrame1 = player2CardOne.frame;
        startFrame2 = player2CardTwo.frame;
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        startFrame1 = player3CardOne.frame;
        startFrame2 = player3CardTwo.frame;
    }    
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        startFrame1 = player4CardOne.frame;
        startFrame2 = player4CardTwo.frame;
    }    
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        startFrame1 = player5CardOne.frame;
        startFrame2 = player5CardTwo.frame;
    }
    [self movePlayingCardFromFrame:startFrame1 toDestinationFrame:destinationFrame duration:0.2 option:nil];
    [self movePlayingCardFromFrame:startFrame2 toDestinationFrame:destinationFrame duration:0.2 option:nil];
}

- (void) pauseButtonPressed:(id)sender
{
    paused = YES;
    [self showAnimationWhenGameIsPaused];
    [self pauseOrUnpause];
}

- (void) pauseRunningTimer: (NSTimer* ) timer creationTime: (NSDate* ) creationTime
{
    NSDate* fireDate = [NSDate dateWithTimeInterval:timer.timeInterval sinceDate:creationTime];
    NSTimeInterval timeToGo = [fireDate timeIntervalSinceNow];
    NSNumber* timeToGoNumber = [NSNumber numberWithFloat:timeToGo];
    [self.timesToGoForCurrentlyRunningTimers addObject:timeToGoNumber];
    timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:999999999999999];    
}

- (void) unpauseRunningTimer:(NSTimer *)timer timeToGo: (NSTimeInterval) timeToGo
{
    timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeToGo];
}

- (void) pauseOrUnpause
{
    if (paused) {
        pokerGame.paused = YES;
        for (Player* anyPlayer in pokerGame.allPlayers) {
            anyPlayer.paused = YES;
        }
        if (pokerGame.currentlyRunningTimersWithCreationTimes != nil) {
            for (int i=0; i<[pokerGame.currentlyRunningTimersWithCreationTimes count]; i+=2) {
                NSTimer* timer = [pokerGame.currentlyRunningTimersWithCreationTimes objectAtIndex:i];
                NSDate* creationTime = [pokerGame.currentlyRunningTimersWithCreationTimes objectAtIndex:i+1];
                [self pauseRunningTimer:timer creationTime:creationTime];
            }
        }
        for (Player* anyPlayer in pokerGame.allPlayers) {
            if (anyPlayer.currentlyRunningTimersWithCreationTimes != nil) {
                for (int i=0; i<[anyPlayer.currentlyRunningTimersWithCreationTimes count]; i+=2) {
                    NSTimer* timer = [anyPlayer.currentlyRunningTimersWithCreationTimes objectAtIndex:i];
                    NSDate* creationTime = [anyPlayer.currentlyRunningTimersWithCreationTimes objectAtIndex:i+1];
                    [self pauseRunningTimer:timer creationTime:creationTime];
                }
            }
        }
        
        //Outlets disablen:
        betSlider.userInteractionEnabled = NO;
        betButton.userInteractionEnabled = NO;
        foldButton.userInteractionEnabled = NO;
        showCardsButton.userInteractionEnabled = NO;
        throwCardsAwayButton.userInteractionEnabled = NO;
        pauseButton.userInteractionEnabled = NO;
    }
    else {
        pokerGame.paused = NO;
        pokerGame.createdTimerDuringPause = NO;
        for (Player* anyPlayer in pokerGame.allPlayers) {
            anyPlayer.paused = NO;
            anyPlayer.createdTimerDuringPause = NO;
        }
        if (pokerGame.currentlyRunningTimersWithCreationTimes != nil) {
            for (int i=0; i<[pokerGame.currentlyRunningTimersWithCreationTimes count]; i+=2) {
                NSTimer* timer = [pokerGame.currentlyRunningTimersWithCreationTimes objectAtIndex:i];
                NSTimeInterval timeToGo = [(NSNumber* ) [self.timesToGoForCurrentlyRunningTimers objectAtIndex:i/2] floatValue];
                [self unpauseRunningTimer:timer timeToGo:timeToGo];
            }
        }
        for (Player* anyPlayer in pokerGame.allPlayers) {
            if (anyPlayer.currentlyRunningTimersWithCreationTimes != nil) {
                for (int i=0; i<[anyPlayer.currentlyRunningTimersWithCreationTimes count]; i+=2) {
                    NSTimer* timer = [anyPlayer.currentlyRunningTimersWithCreationTimes objectAtIndex:i];
                    NSTimeInterval timeToGo = [(NSNumber* ) [self.timesToGoForCurrentlyRunningTimers objectAtIndex:i/2] floatValue];
                    [self unpauseRunningTimer:timer timeToGo:timeToGo];
                }
            }
        }
    }
}

- (void) changeGameOutlets_playerCountDown: (Player* ) aPlayer
{
    if (aPlayer.counter > 3) {
        if (self.playerCountdownLabel.textColor == [UIColor redColor]) {
            self.playerCountdownLabel.textColor = [UIColor blueColor];
        }
    }
    else {
        self.playerCountdownLabel.textColor = [UIColor redColor];
        NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"time" ofType:@"wav"];
        countdownSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:nil];
        countdownSoundPlayer.delegate = self;
        countdownSoundPlayer.volume = 0.2;
        [countdownSoundPlayer prepareToPlay];
        BOOL ok = [countdownSoundPlayer play];
        NSLog(@"ok: %@", ok ? @"Y" : @"N");
    }
    if (aPlayer.counter >= 0) {
        self.playerCountdownLabel.text = [NSString stringWithFormat:@"%i", aPlayer.counter];
    }
}






@end
