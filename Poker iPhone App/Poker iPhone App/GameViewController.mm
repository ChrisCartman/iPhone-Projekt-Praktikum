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

@synthesize showCardsButton;
@synthesize throwCardsAwayButton;

@synthesize pauseButton;
@synthesize pauseTableView;

@synthesize currentlyRunningTimersWithCreationsTimes;
@synthesize timesToGoForCurrentlyRunningTimers;

@synthesize table;


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
    [aPlayer showCards];
    aPlayer.mayShowCards = NO;
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
    [pokerGame.showDownTimer invalidate];
    Player* aPlayer = pokerGame.activePlayer;
    aPlayer.mayShowCards = NO;
    [self playerThrowsCardsAway:aPlayer];
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
    if ([aPlayer.identification isEqualToString:@"player1"]) {
        player1CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
        player1CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
    }
    else if ([aPlayer.identification isEqualToString:@"player2"]) {
        player2CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
        player2CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
    }
    else if ([aPlayer.identification isEqualToString:@"player3"]) {
        player3CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
        player3CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
    }
    else if ([aPlayer.identification isEqualToString:@"player4"]) {
        player4CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
        player4CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
    }
    else if ([aPlayer.identification isEqualToString:@"player5"]) {
        player5CardOne.image = [[aPlayer.hand.cardsOnHand objectAtIndex:0] playingCardImage];
        player5CardTwo.image = [[aPlayer.hand.cardsOnHand objectAtIndex:1] playingCardImage];
    }
    if (animated) {
        [self showAnimationWhenPlayerShowsCards:aPlayer];
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
    }
    else if (aPlayer.playerState == CALLED) {
        effectLabel.text = @"Call!";
        effectLabel.textColor = [UIColor greenColor];
    }
    else if (aPlayer.playerState == RAISED) {
        effectLabel.text = @"Raise!";
        effectLabel.textColor = [UIColor orangeColor];
    }
    else if (aPlayer.playerState == BET) {
        effectLabel.text = @"Bet!";
        effectLabel.textColor = [UIColor orangeColor];
    }
    else if (aPlayer.playerState == ALL_IN) {
        effectLabel.text = @"ALL IN!";
        effectLabel.textColor = [UIColor orangeColor];
    }
    else if (aPlayer.playerState == FOLDED) {
        effectLabel.text = @"Fold!";
        effectLabel.textColor = [UIColor redColor];
    }
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

- (void) showAnimationWhenGameIsPaused
{
    NSMutableArray* allOutlets = [NSMutableArray arrayWithArray:[self.view subviews]];
    [allOutlets removeObject:pauseTableView];
    if (paused) {
        pauseTableView.alpha = 0.0;
        pauseTableView.hidden = NO;
        [self.view bringSubviewToFront:pauseTableView];
        [UIView animateWithDuration:1.0 animations:^{
            for (id outlet in allOutlets) {
                if ([outlet alpha] > 0) {
                    [outlet setAlpha:0.2];
                }
            }
            pauseTableView.alpha = 1.0;
            //self.view.backgroundColor = [UIColor lightGrayColor];
        }
        completion:nil];
    }
    else {
        [UIView animateWithDuration:1.0 animations:^{
            for (id outlet in allOutlets) {
                if ([outlet alpha] >= 0.2) {
                    [outlet setAlpha:1.0];
                }
            }
            pauseTableView.alpha = 0.0;
        }
    completion:^(BOOL finished) {
        if (finished) {
            self.pauseTableView.hidden = YES;
            
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
                    [aPlayer showCards];
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
    [pokerGame addObserver:self forKeyPath:@"cardDeck.popsFor" options:0 context:nil];
    [pokerGame addObserver:self forKeyPath:@"mainPot.chipsInPot" options:0 context:nil];
    [pokerGame addObserver:self forKeyPath:@"gameState" options:0 context:nil];
    //der aktuell laufende Timer soll immer beobachtet werden: fuer Pausierungen:
    [pokerGame addObserver:self forKeyPath:@"createdTimerDuringPause" options:0 context:nil];
    [pokerGame prepareGame];
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
    player1NameLabel.text = @"Text";
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
    player2NameLabel.text = @"Text";
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
    [player2ProfilePictureImage setImage:[UIImage imageNamed: @"Nathan.png"]];
    
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
        player3NameLabel.text = @"Text";
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
        [player3ProfilePictureImage setImage:[UIImage imageNamed: @"Nathan.png"]];
        
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
            player4NameLabel.text = @"Text";
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
            [player4ProfilePictureImage setImage:[UIImage imageNamed: @"Nathan.png"]];
            
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
                player5NameLabel.text = @"Text";
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
                [player5ProfilePictureImage setImage:[UIImage imageNamed: @"Nathan.png"]];
                
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
   /* AVAudioPlayer* cardSoundPlayer;
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"cards1" ofType:@"wav"];
    cardSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:nil];
    cardSoundPlayer.delegate = self;
    cardSoundPlayer.volume = 0.5;
    [cardSoundPlayer play];
    */
    
    
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






@end
