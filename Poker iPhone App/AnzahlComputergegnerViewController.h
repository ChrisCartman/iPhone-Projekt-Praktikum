//
//  AnzahlComputergegnerViewController.h
//  Poker iPhone App
//
//  Created by Lion User on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnzahlComputergegnerViewController;

@protocol AnzahlComputergegnerViewControllerDelegate <NSObject>

- (void)anzahlComputergegnerPickerViewController: 
(AnzahlComputergegnerViewController *)controller
                   didSelectAnzahl:(NSString *)anzahlvar;

@end

@interface AnzahlComputergegnerViewController : UITableViewController{

 
}

@property(nonatomic,weak) id <AnzahlComputergegnerViewControllerDelegate> delegate;
@property(nonatomic,retain)NSString *anzahlvar;

@end
