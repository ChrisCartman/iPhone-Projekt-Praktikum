//
//  SinglePlayerViewController.m
//  Poker iPhone App
//
//  Created by Lion User on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "GameSettings.h"
#import "AppDelegate.h"



@interface SinglePlayerViewController ()


@end

@implementation SinglePlayerViewController
{   
    NSString *anzahlvar;

    //Variablen, in denen Einstellungen gespeichert werden.
    NSString *difficulty;
    NSString *blinds;
    int anzahlKI;
    int startChips;
    int startBlinds;
    int increaseBlindsAfter;
    
}
@synthesize detailLabel;
@synthesize anzahlLabel;
@synthesize blindsLabel;
@synthesize gameSettings;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{  
    [super viewDidLoad];
    
    if (gameSettings == nil) {
        gameSettings = [[GameSettings alloc] init];
    }
    
    if (gameSettings.difficulty ==nil) {gameSettings.difficulty = @"schwer";};
    if (gameSettings.blinds ==nil) {gameSettings.blinds = @"nach Runden";};  
    if (gameSettings.anzahlKI == 0) {gameSettings.anzahlKI = 3;};
    if (gameSettings.startChips == 0) {gameSettings.startChips =1000;};
    if (gameSettings.startBlinds == 0) {gameSettings.startBlinds = 5;};
    if (gameSettings.increaseBlindsAfter == 0) {gameSettings.increaseBlindsAfter = 5;};

       
        
        
           
        
    

 
    self.detailLabel.text = gameSettings.difficulty;
    self.anzahlLabel.text = [NSString stringWithFormat:@"%i",gameSettings.anzahlKI];
    startkapital.text = [NSString stringWithFormat:@"%i",gameSettings.startChips];
    startsmallblind.text=[NSString stringWithFormat:@"%i",gameSettings.startBlinds];
    blindanzahl.text=[NSString stringWithFormat:@"%i",gameSettings.increaseBlindsAfter];
    self.blindsLabel.text = gameSettings.blinds;
   

    /*appDelegate.gameSettings.difficulty = difficulty;
    appDelegate.gameSettings.blinds = blinds;
    appDelegate.gameSettings.anzahlKI = anzahlKI;
    appDelegate.gameSettings.startChips =startChips;
    appDelegate.gameSettings.startBlinds = startBlinds;
    appDelegate.gameSettings.increaseBlindsAfter = increaseBlindsAfter;*/
    
    

        
    


    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    /*detailLabel = nil;
    anzahlLabel = nil;
    startkapital = nil;
    startsmallblind = nil;

    blindsLabel = nil;
    
    blindanzahl = nil;
    anzahlblindslabel = nil;*/
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

    //Methode, die noch vor ViewDidLoad aufgerufen wird
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"PickDifficulty"])
    {DifficultyViewController *difficultyViewController = segue.destinationViewController;
        difficultyViewController.delegate = self;
        difficultyViewController.difficulty = difficulty;}
    
    if([segue.identifier isEqualToString:@"PickAnzahl"])
    {AnzahlComputergegnerViewController *anzahlComputergegnerViewController = segue.destinationViewController;
        anzahlComputergegnerViewController.delegate = self;
        anzahlComputergegnerViewController.anzahlvar = anzahlvar;}
    
    if([segue.identifier isEqualToString:@"PickBlinds"])
    {BlindsViewController *blindsViewController = segue.destinationViewController;
        blindsViewController.delegate = self;
        blindsViewController.blinds = blinds;}
    
    if ([segue.identifier isEqualToString:@"GameStart"]) {
        GameViewController* gameViewController = segue.destinationViewController;
        gameViewController.pokerGame = [[PokerGame alloc] init];
        gameViewController.pokerGame.gameSettings = [[GameSettings alloc] initWithSettings:gameSettings];
    }

}


    //Auswahl wird ins Label und in die Variable gespeichert und Fenster wird geschlossen
- (void)difficultyPickerViewController:(DifficultyViewController *)controller didSelectDifficulty:(NSString *)theDifficulty{
   
    difficulty = theDifficulty;
    gameSettings.difficulty = difficulty;
    self.detailLabel.text = gameSettings.difficulty;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)anzahlComputergegnerPickerViewController:(AnzahlComputergegnerViewController *)controller didSelectAnzahl:(NSString *)theAnzahl{

    anzahlvar = theAnzahl;
    anzahlKI = [anzahlvar intValue];
    gameSettings.anzahlKI = anzahlKI;
    self.anzahlLabel.text = [NSString stringWithFormat:@"%i",gameSettings.anzahlKI];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)blindsPickerViewController:(BlindsViewController *)controller didSelectBlinds:(NSString *)theBlinds{
   blinds = theBlinds;
    gameSettings.blinds = theBlinds;
    
    if (blinds == @"nach Minuten"){anzahlblindslabel.text = @"Anzahl Minuten";}
    if (blinds == @"nach Runden"){anzahlblindslabel.text = @"Anzahl Runden";}
    if (blinds == @"Nie"){
        anzahlblindslabel.text = @"-";
        blindanzahl.text = @"";
    }; 
    self.blindsLabel.text = blinds;
    [self.navigationController popViewControllerAnimated:YES];}
    





#pragma mark - Textfeld Methoden

//lässt die Tastatur verschwinden
- (IBAction)textFieldDoneEditing:(id)sender
{ [sender resignFirstResponder];
    
  
    gameSettings.startBlinds = [[startsmallblind text] intValue];
    gameSettings.startChips = [[startkapital text] intValue];
    gameSettings.increaseBlindsAfter = [[blindanzahl text]intValue];



    }

@end
