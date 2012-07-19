//
//  StartViewController.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"

@implementation StartViewController

@synthesize singlePlayerButton;
@synthesize profilButton;

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void) singlePlayerButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"SinglePlayerSegue" sender:self];



}

- (void) profilButtonPressed: (id)sender
{
    
    [self performSegueWithIdentifier:@"ProfilSegue" sender:self];

}

- (void) viewDidLoad
{   [super viewDidLoad];
    
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];

    singlePlayerButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Single-Player"]];
    [singlePlayerButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

	singlePlayerButton.segmentedControlStyle = UISegmentedControlStyleBar;
	singlePlayerButton.momentary = YES;
	singlePlayerButton.tintColor = [UIColor blueColor];
    [singlePlayerButton addTarget:self action:@selector(singlePlayerButtonPressed:) 
        forControlEvents: UIControlEventValueChanged];
    singlePlayerButton.frame = CGRectMake(63, 263, 195, 50);
    [self.view addSubview:singlePlayerButton];

    profilButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Profil"]];
    [profilButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
	profilButton.segmentedControlStyle = UISegmentedControlStyleBar;
	profilButton.momentary = YES;
	profilButton.tintColor = [UIColor darkGrayColor];
    [profilButton addTarget:self action:@selector(profilButtonPressed:) 
                 forControlEvents: UIControlEventValueChanged];
    profilButton.frame = CGRectMake(63, 330, 195, 50);
    [self.view addSubview:profilButton];
}

@end