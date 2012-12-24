//
//  NewsViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/21/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "NewsViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

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
    [self populateNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateNews {
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:@"http://dragthor.github.com/southridge/eNews.json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *news = JSON;
        
        NSString *author = [[news objectAtIndex:0] valueForKey:@"Author"];
        NSString *date = [[news objectAtIndex:0] valueForKey:@"Date"];
        NSString *message = [[news objectAtIndex:0] valueForKey:@"Message"];
        
        message = [message stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"\n\n"];
        message = [message stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
       
        message = [self stringByStrippingHTML:message];
        
        self.newsLabel.text = message;
        self.authorLabel.text = author;
        self.dateLabel.text = date;
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
    }];
    
    [operation start];
}

-(NSString *) stringByStrippingHTML: (NSString *) s {
    NSRange r;

    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
@end
