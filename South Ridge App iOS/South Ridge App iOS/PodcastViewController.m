//
//  SecondViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "PodcastViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface PodcastViewController ()

@end

@implementation PodcastViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Podcast";
        self.tabBarItem.image = [UIImage imageNamed:@"31-ipod.png"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    [self populatePodcasts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *item = [podcasts objectAtIndex:indexPath.row];
    
    NSString *subText = [item valueForKey:@"Speaker"];

    subText = [subText stringByAppendingString:@" - "];
    subText = [subText stringByAppendingString:[item valueForKey:@"Date"]];
    
    cell.textLabel.text = [item valueForKey:@"Title"];
    cell.detailTextLabel.text = subText;
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://www.southridgecc.org/resources/images/%@", [item valueForKey:@"Image"]];
    
    [cell.imageView setImageWithURL: [NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"podcast-700x525.png"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return podcasts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) populatePodcasts {
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:@"http://dragthor.github.com/southridge/SouthRidgePodcast.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        podcasts = JSON;
        
        [_podcastTable reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
    }];
    
    [operation start];
}

@end

