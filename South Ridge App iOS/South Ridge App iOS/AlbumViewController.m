//
//  AlbumViewController.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/26/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "AlbumViewController.h"
#import "PhotoViewCell.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

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

    [_albumCollection registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"cell"];

    self.albumTitle.title = self.albumName;
    
    [self populatePhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done {
    [self dismissViewControllerAnimated:YES completion:^{
        // Done.
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoViewCell *cell = (PhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [photos objectAtIndex:indexPath.row];

    NSString *pictureUrl = [item valueForKey:@"picture"];

    [cell setImage:pictureUrl];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoViewCell *cell = (PhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [photos objectAtIndex:indexPath.row];
    
    NSString *pictureUrl = [item valueForKey:@"picture"];
}

-(void) populatePhotos {
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSString *photosUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/photos", self.albumNumber];
    
    NSURL *url = [NSURL URLWithString:photosUrl];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        photos = [JSON objectForKey:@"data"];
        
        [_albumCollection reloadData];
 
        [SVProgressHUD dismiss];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showErrorWithStatus:@"Error. Try again."];
    }];
    
    [operation start];
}
@end
