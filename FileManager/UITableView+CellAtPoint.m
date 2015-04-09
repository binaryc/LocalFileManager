//
//  UITableView+CellAtPoint.m
//  FileManager
//
//  Created by Bin Chen on 15/4/9.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import "UITableView+CellAtPoint.h"

@implementation UITableView (CellAtPoint)

- (UITableViewCell *)cellForRowAtPoint:(CGPoint)aPoint
{
  NSIndexPath *indexPath = [self indexPathForRowAtPoint:aPoint];
  UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
  return cell;
}

@end
