//
//  PhotoViewCell.h
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/28/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photo;
-(void)setImage:(NSString*) imageUrl;

@end
