//
//  LongPressGestureHandlerWindow.h
//  FileManager
//
//  Created by Bin Chen on 15/4/9.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LongPressGestureHandlerWindow;

@protocol WindowLongPressOperationDelegate <NSObject>

- (void)window:(LongPressGestureHandlerWindow *)window longPressDidStart:(UILongPressGestureRecognizer *)longPress;
- (void)window:(LongPressGestureHandlerWindow *)window longPressDidChange:(UILongPressGestureRecognizer *)longPress;
- (void)window:(LongPressGestureHandlerWindow *)window longPressDidEnd:(UILongPressGestureRecognizer *)longPress;

@end

@interface LongPressGestureHandlerWindow : UIWindow

@property (nonatomic, readonly) UIImageView *animationView;
@property (nonatomic, assign) id<WindowLongPressOperationDelegate>longPressDelegate;

@end
