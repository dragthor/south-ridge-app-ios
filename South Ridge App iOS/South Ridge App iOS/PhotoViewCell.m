//
//  PhotoViewCell.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/28/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "PhotoViewCell.h"
#import "AFNetworking.h"
#import "ImageHelper.h"

@implementation PhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photo = [[UIImageView alloc] initWithFrame:self.bounds];
        self.autoresizesSubviews = YES;
        self.photo.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        [self addSubview:self.photo];
        
    }
    return self;
}

-(void)setImage:(NSString*) imageUrl {
    NSURLRequest *podReq = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];

    [self.photo setImageWithURLRequest: podReq placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

        // Note: the view collection handles "resize".
        self.photo.image = image;
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         //
     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
