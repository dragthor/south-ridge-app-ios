//
//  FirstViewController.h
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *albums;
}

@property (weak, nonatomic) IBOutlet UITableView *albumTable;

@end
