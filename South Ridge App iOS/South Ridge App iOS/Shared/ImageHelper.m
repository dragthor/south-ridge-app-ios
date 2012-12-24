//
//  ImageHelper.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/24/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper 

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
