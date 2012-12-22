//
//  SecondViewController.h
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PodcastViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *podcasts;
}

@property (weak, nonatomic) IBOutlet UITableView *podcastTable;

@end
