//
//  SecondViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "PodcastViewController.h"
#import "AFNetworking.h"

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
    
    NSString *imageUrl = @"http://www.southridgecc.org/resources/images/";
    imageUrl = [imageUrl stringByAppendingString:[item valueForKey:@"Image"]];
    
    [cell.imageView setImageWithURL: [NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"podcast.png"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return podcasts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) populatePodcasts {
    NSURL *url = [NSURL URLWithString:@"http://dragthor.github.com/southridge/SouthRidgePodcast.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        podcasts = JSON;
        
        NSLog(@"podcasts found %d", podcasts.count);
        
        [_podcastTable reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"podcast failure. statuscode is %d", response.statusCode);
        NSLog(@"error - %@", error);
    }];
    
    [operation start];
}

@end

