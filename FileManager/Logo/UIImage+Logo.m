//
//  UIImage+Logo.m
//  FileManager
//
//  Created by Bin Chen on 14-7-7.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import "UIImage+Logo.h"

@implementation UIImage (Logo)

- (UIImage *)documentLogoWithFrame:(CGRect)aFrame
                      andLineColor:(UIColor *)aColor
{
  
  return nil;
}

- (UIImage *)textLogoWithFrame:(CGRect)aFrame
                  andLineColor:(UIColor *)aColor
{
  UIGraphicsBeginImageContext(aFrame.size);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(ctx, aColor.CGColor);
  CGContextStrokeRect(ctx, aFrame);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  return image;
}

//- (void)drawText:(NSString *)aText atPoint:(CGPoint)aPoint
//       onContext:(CGContextRef)aCtx withFont:(UIFont *)aFont
//{
//  CGContextSaveGState(aCtx);
//  CGContextSetFillColorWithColor(aCtx, [UIColor blueColor].CGColor);
//  char *message = (char *)[aText UTF8String];
//  CGSize textSize = [aText sizeWithAttributes:@{
//                                                  NSFontAttributeName:aFont
//                                                }];
//  CGContextShowText(<#CGContextRef c#>, <#const char *string#>, <#size_t length#>)
//  
//}

@end
