//
//  UIView+snapshot.m
//  MoveCellDemo
//
//  Created by Bin Chen on 15/4/8.
//  Copyright (c) 2015年 touchDream. All rights reserved.
//

#import "UIView+snapshot.h"

@implementation UIView (snapshot)

- (UIImage *)snapshot
{
  CGFloat scale = [[UIScreen mainScreen] scale];
  UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return viewImage;
}

@end
