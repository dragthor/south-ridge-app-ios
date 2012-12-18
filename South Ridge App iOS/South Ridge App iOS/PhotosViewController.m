//
//  ViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/16/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) testButtonClick {
    NSURL *url = [NSURL URLWithString:@"http://dragthor.github.com/southridge/SouthRidgePodcast.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        podcasts = JSON;
        
        NSLog(@"podcasts found %d", podcasts.count);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"podcast failure. statuscode is %d", response.statusCode);
        NSLog(@"error - %@", error);
    }];
    
    [operation start];
}
@end
