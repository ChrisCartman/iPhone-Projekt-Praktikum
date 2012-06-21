//
//  DifficultyViewController.h
//  Poker iPhone App
//
//  Created by Lion User on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DifficultyViewController;

@protocol DifficultyViewControllerDelegate <NSObject>

- (void)difficultyPickerViewController: 
    (DifficultyViewController *)controller
    didSelectDifficulty:(NSString *)difficulty;

@end

@interface DifficultyViewController : UITableViewController



@property(nonatomic,weak) id <DifficultyViewControllerDelegate> delegate;
@property(nonatomic,retain) NSString *difficulty;


@end
