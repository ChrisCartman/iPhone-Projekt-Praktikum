//
//  BlindsViewController.h
//  Poker iPhone App
//
//  Created by Lion User on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@class BlindsViewController;

@protocol BlindsViewControllerDelegate <NSObject>

- (void)blindsPickerViewController: 
(BlindsViewController *)controller didSelectBlinds:(NSString *)blinds;

@end

@interface BlindsViewController : UITableViewController{
    
    
}

@property(nonatomic,weak) id <BlindsViewControllerDelegate> delegate;
@property(nonatomic,retain)NSString *blinds;

@end
