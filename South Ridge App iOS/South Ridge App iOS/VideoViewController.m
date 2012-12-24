//
//  VideoViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "VideoViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Video";
        self.tabBarItem.image = [UIImage imageNamed:@"70-tv.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self populateVideos];
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
    
    NSDictionary *item = [videos objectAtIndex:indexPath.row];
    
    // NSString *videoUrl = [item valueForKey:@"mobile_url"];
    
    cell.textLabel.text = [item valueForKey:@"title"];
    cell.detailTextLabel.text = [item valueForKey:@"description"];;
    cell.imageView.image = [UIImage imageNamed:@"thumb-100x80.png"];
    
    NSString *imageUrl = [item valueForKey:@"thumbnail_medium"];
    
    NSURLRequest *podReq = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    [cell.imageView setImageWithURLRequest: podReq placeholderImage:[UIImage imageNamed:@"thumb-100x80.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        cell.imageView.image = [ImageHelper imageWithImage:image scaledToSize:CGSizeMake(100, 80)];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return videos.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) populateVideos {
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:@"http://vimeo.com/api/v2/benstapley/videos.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *rawVideos = JSON;

        videos = [[NSMutableArray alloc] init];
        
        for (NSObject* video in rawVideos)
        {
            NSString *rawTags = [video valueForKey:@"tags"];
            NSArray *tags = [rawTags componentsSeparatedByString:@","];
            
            for (NSString* tag in tags) {
                if ([[[tag lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ] isEqualToString:@"south ridge community church"]) {
                    [videos addObject:video];
                    break;
                }
            }
        }
        
        [_videoTable reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
    }];
    
    [operation start];
}
@end
