//
//  SinglePlayerViewController.h
//  Poker iPhone App
//
//  Created by Lion User on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DifficultyViewController.h"
#import "AnzahlComputergegnerViewController.h"
#import "BlindsViewController.h"
#import "GameSettings.h"
#import "GameViewController.h"

@class AppDelegate;




@interface SinglePlayerViewController : UITableViewController
<DifficultyViewControllerDelegate,AnzahlComputergegnerViewControllerDelegate,BlindsViewControllerDelegate>{
    
    IBOutlet UILabel *anzahlblindslabel;
    IBOutlet UITextField *blindanzahl;
    IBOutlet UILabel *anzahlLabel;
    IBOutlet UILabel *detailLabel;
    IBOutlet UITextField *startkapital;
    IBOutlet UITextField *startsmallblind;
}
@property (nonatomic,retain) UILabel *detailLabel;
@property (nonatomic,retain) UILabel *anzahlLabel;
@property (nonatomic, retain)UILabel *blindsLabel;
@property (nonatomic, retain) GameSettings* gameSettings;
-(IBAction)textFieldDoneEditing:(id)sender;
@end
