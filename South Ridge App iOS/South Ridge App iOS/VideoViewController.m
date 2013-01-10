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

#import "VideoViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"
#import "AlertBox.h"

@interface VideoViewController () {
    
}

@property (weak, nonatomic) SSPullToRefreshView *refreshVideoView;
@property BOOL pullLoading;

@end

@implementation VideoViewController

@synthesize refreshVideoView;
@synthesize pullLoading;

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
    self.refreshVideoView = [[SSPullToRefreshView alloc] initWithScrollView:self.videoTable delegate:self];
    
    self.refreshVideoView.contentView = [[SSPullToRefreshSimpleContentView alloc] init];
    
    [self populateVideos: YES];
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
        NSLog(@"Video thumbnail %@ - error - %@", imageUrl, error);
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return videos.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) populateVideos:(BOOL) showHUDLoading  {
    if (self.reach.isReachable == NO) {
        [SVProgressHUD dismiss];
        
        [self.refreshVideoView finishLoading];
        
        [AlertBox showAlert:@"Network Status" :@"An internet connection is required."];
        return;
    }
    
    pullLoading = YES;
    
    if (showHUDLoading) [SVProgressHUD showWithStatus:@"Loading..."];
    
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
        
        [self.refreshVideoView finishLoading];
        
        pullLoading = NO;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"populateVideos error - %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
        
        [SVProgressHUD dismiss];
        
        [self.refreshVideoView finishLoading];
        
        pullLoading = NO;
    }];
    
    [operation start];
}

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return !pullLoading;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self populateVideos: NO];
}
@end
