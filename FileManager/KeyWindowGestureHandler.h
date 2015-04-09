//
//  KeyWindowGestureHandler.h
//  FileManager
//
//  Created by Bin Chen on 15/4/9.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LongPressGestureHandlerWindow.h"

@class FileListViewController;

@interface KeyWindowGestureHandler : NSObject
<WindowLongPressOperationDelegate>

@property (nonatomic, weak) FileListViewController *filesListViewController;

- (void)cleanDatasCaches;

+ (instancetype)getInstance;

@end
