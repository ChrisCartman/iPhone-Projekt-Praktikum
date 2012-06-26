//
//  ProfilViewController.h
//  Poker iPhone App
//
//  Created by Lion User on 16/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilViewController : UITableViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//Da UIPickerControllerDelegate Subklasse von UINavigationControllerDelegate ist, brauchen wir hier zwei Protokolle
{
    
    IBOutlet UIImageView *imageView;
    UIButton *selectPicture;
    UIButton *takePicture;
    
}


@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UIButton *selectPictureButton;
@property(nonatomic,retain) UIButton *takePictureButton;


- (IBAction)selectPicture;
- (IBAction)takePicture:(id)sender;


@end