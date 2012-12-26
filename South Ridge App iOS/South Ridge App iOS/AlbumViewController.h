//
//  AlbumViewController.h
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/26/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollection;

-(IBAction) done;

@end
