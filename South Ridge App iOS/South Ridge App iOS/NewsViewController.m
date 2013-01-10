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

#import "NewsViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AlertBox.h"

@interface NewsViewController () {
    
}

@property (weak, nonatomic) SSPullToRefreshView *refreshNewsView;
@property BOOL pullLoading;

@end

@implementation NewsViewController

@synthesize refreshNewsView;
@synthesize pullLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"eNews";
        self.tabBarItem.image = [UIImage imageNamed:@"08-chat.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.refreshNewsView = [[SSPullToRefreshView alloc] initWithScrollView:self.newsLabel delegate:self];
    
    self.refreshNewsView.contentView = [[SSPullToRefreshSimpleContentView alloc] init];
    
    [self populateNews: YES];
}

-(void) populateNews:(BOOL) showHUDLoading  {
    if (self.reach.isReachable == NO) {
        [SVProgressHUD dismiss];
        
        [self.refreshNewsView finishLoading];
        
        [AlertBox showAlert:@"Network Status" :@"An internet connection is required."];
        return;
    }
    
    pullLoading = YES;
    
    if (showHUDLoading) [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:@"http://dragthor.github.com/southridge/eNews.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *news = JSON;
        
        NSString *author = [[news objectAtIndex:0] valueForKey:@"Author"];
        NSString *date = [[news objectAtIndex:0] valueForKey:@"Date"];
        NSString *message = [[news objectAtIndex:0] valueForKey:@"Message"];
        
        NSString *enews = [author stringByAppendingString:@" "];
        
        enews = [enews stringByAppendingString:date];
        
        enews = [enews stringByAppendingString:@"\n\n"];
        
        enews = [enews stringByAppendingString:message];
    
        enews = [enews stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"\n\n"];
        enews = [enews stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        enews = [enews stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
       
        enews = [self stringByStrippingHTML:enews];
        
        self.newsLabel.text = enews;
        
        [SVProgressHUD dismiss];
        
        [self.refreshNewsView finishLoading];
        
        pullLoading = NO;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"populateNews error - %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
        
        [SVProgressHUD dismiss];
        
        [self.refreshNewsView finishLoading];
        
        pullLoading = NO;
    }];
    
    [operation start];
}

-(NSString *) stringByStrippingHTML: (NSString *) s {
    NSRange r;

    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return !pullLoading;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self populateNews: NO];
}

@end
