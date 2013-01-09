/*
 Copyright (c) 2012 Kristofer Krause, http://kriskrause.com
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "PhotoViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"
#import "AlbumViewController.h"
#import "AlertBox.h"

@interface PhotoViewController () {
    
}

@property (weak, nonatomic) SSPullToRefreshView *refreshPhotoView;
@property BOOL pullLoading;

@end

@implementation PhotoViewController

@synthesize refreshPhotoView;
@synthesize pullLoading;

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
    self.refreshPhotoView = [[SSPullToRefreshView alloc] initWithScrollView:self.albumTable delegate:self];
    
    self.refreshPhotoView.contentView = [[SSPullToRefreshSimpleContentView alloc] init];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    [self populateAlbums];
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
            NSLog(@"Cover photo image - %@ - %@", coverPhotoUrl, error);
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Cover photo json - %@", error);
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
    pullLoading = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://graph.facebook.com/southridgecommunitychurch/albums/"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        albums = [JSON objectForKey:@"data"];
        
        [_albumTable reloadData];
        
        [SVProgressHUD dismiss];
        
        [self.refreshPhotoView finishLoading];
        
        pullLoading = NO;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"populateAlbums error - %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
        
        [SVProgressHUD dismiss];
        
        [self.refreshPhotoView finishLoading];
        
        pullLoading = NO;
    }];
    
    [operation start];
}

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return !pullLoading;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self populateAlbums];
}
@end
