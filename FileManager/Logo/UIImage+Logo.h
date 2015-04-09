//
//  UIImage+Logo.h
//  FileManager
//
//  Created by Bin Chen on 14-7-7.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface UIImage (Logo)

- (UIImage *)documentLogoWithFrame:(CGRect)aFrame
                      andLineColor:(UIColor *)aColor;

- (UIImage *)textLogoWithFrame:(CGRect)aFrame
                  andLineColor:(UIColor *)aColor;

@end
