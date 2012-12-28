//
//  FirstViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "PhotoViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"
#import "AlbumViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Photos";
        self.tabBarItem.image = [UIImage imageNamed:@"86-camera.png"];
        
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self populateAlbums];
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
    
    NSDictionary *item = [albums objectAtIndex:indexPath.row];
    
    NSString *subText = @"";
   
    NSString *coverPhoto = [item valueForKey:@"cover_photo"];

    NSString *desc = [item valueForKey:@"description"];
    
    if (desc != NULL) subText = [subText stringByAppendingString:desc];
    
    cell.textLabel.text = [item valueForKey:@"name"];
    cell.detailTextLabel.text = subText;
    cell.imageView.image = [UIImage imageNamed:@"thumb-100x80.png"];
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@", coverPhoto];

    // Begin getting album cover photo.
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *coverPhotos = JSON;
        
        NSString *coverPhotoUrl = [coverPhotos valueForKey:@"picture"];
         
        NSURLRequest *coverReq = [NSURLRequest requestWithURL:[NSURL URLWithString:coverPhotoUrl]];
        
        [cell.imageView setImageWithURLRequest: coverReq placeholderImage:[UIImage imageNamed:@"thumb-100x80.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            cell.imageView.image = [ImageHelper imageWithImage:image scaledToSize:CGSizeMake(100, 80)];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    
    [operation start];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return albums.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = [albums objectAtIndex:indexPath.row];
    
    NSString *albumId = [item valueForKey:@"id"];
    NSString *albumName = [item valueForKey:@"name"];
    
    AlbumViewController *album;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        album = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController_iPhone" bundle:nil];
    } else {
        album = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController_iPad" bundle:nil];
    }
    
    album.albumNumber = albumId;
    album.albumName = albumName;
    
    [self presentViewController:album animated:YES completion:^{
        // Done showing callback.
    }];
}

-(void) populateAlbums {
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:@"http://graph.facebook.com/southridgecommunitychurch/albums/"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        albums = [JSON objectForKey:@"data"];
        
        [_albumTable reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
    }];
    
    [operation start];
}
@end
