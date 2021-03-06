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

#import "PodcastViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"
#import "AlertBox.h"

@interface PodcastViewController () {
    
}

@property (weak, nonatomic) SSPullToRefreshView *refreshPodcastView;
@property BOOL pullLoading;

@end

@implementation PodcastViewController

@synthesize refreshPodcastView;
@synthesize pullLoading;

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
    self.refreshPodcastView = [[SSPullToRefreshView alloc] initWithScrollView:self.podcastTable delegate:self];

    self.refreshPodcastView.contentView = [[SSPullToRefreshSimpleContentView alloc] init];

    [self populatePodcasts: YES];
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
    cell.imageView.image = [UIImage imageNamed:@"thumb-100x80.png"];
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://www.southridgecc.org/resources/images/%@", [item valueForKey:@"Image"]];

    NSURLRequest *podReq = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    [cell.imageView setImageWithURLRequest: podReq placeholderImage:[UIImage imageNamed:@"thumb-100x80.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        cell.imageView.image = [ImageHelper imageWithImage:image scaledToSize:CGSizeMake(100, 80)];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"podcast thumbnail %@ error - %@", imageUrl, error);
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return podcasts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) populatePodcasts:(BOOL) showHUDLoading {
    if (self.reach.isReachable == NO) {
        [SVProgressHUD dismiss];
        
        [self.refreshPodcastView finishLoading];
        
        [AlertBox showAlert:@"Network Status" :@"An internet connection is required."];
        return;
    }
    
    pullLoading = YES;
    
    if (showHUDLoading) [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:@"http://dragthor.github.com/southridge/SouthRidgePodcast.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        podcasts = JSON;
        
        [_podcastTable reloadData];
        
        [SVProgressHUD dismiss];
        
        [self.refreshPodcastView finishLoading];
        
        pullLoading = NO;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"populatePodcasts error - %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
        
        [SVProgressHUD dismiss];
        
        [self.refreshPodcastView finishLoading];
        
        pullLoading = NO;
    }];
    
    [operation start];
}

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return !pullLoading;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self populatePodcasts: NO];
}

@end

