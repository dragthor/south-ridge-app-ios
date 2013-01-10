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

#import "PhotoDetailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.photoUrl];
    
    // TODO: Add spinner HUD.
    [self.imgPhoto setImageWithURL:url];

    /*
    [self.imgPhoto setImageWithURLRequest:request placeholderImage:imgPlaceHolder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //<#code#>
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //<#code#>
    }];
     
    */
}

-(IBAction)done {
    [SVProgressHUD dismiss];
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Done.
        self.imgPhoto = nil;
    }];
}

@end
