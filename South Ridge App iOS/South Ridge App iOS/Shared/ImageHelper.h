//
//  ImageHelper.h
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/24/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject
    +(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
