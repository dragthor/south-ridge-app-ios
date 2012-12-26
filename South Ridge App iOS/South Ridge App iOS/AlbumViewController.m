//
//  AlbumViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/26/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done {
    /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Album" message: @"test" delegate: self cancelButtonTitle: @"Close" otherButtonTitles: nil];
    
    [alert show]; */
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Done.
    }];
}

@end
