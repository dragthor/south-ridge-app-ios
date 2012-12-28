//
//  AlbumViewController.h
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/26/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    NSArray *photos;
}

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollection;
@property (weak, nonatomic) NSString *albumNumber;
@property (weak, nonatomic) NSString *albumName;
@property (weak, nonatomic) IBOutlet UINavigationItem *albumTitle;

-(IBAction) done;

@end
