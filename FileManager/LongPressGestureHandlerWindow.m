//
//  LongPressGestureHandlerWindow.m
//  FileManager
//
//  Created by Bin Chen on 15/4/9.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import "LongPressGestureHandlerWindow.h"

@interface LongPressGestureHandlerWindow ()

@property (nonatomic, readwrite) UIImageView *animationView;

@end

@implementation LongPressGestureHandlerWindow

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self manageLongPressGesture];
    [self layoutAnimationView];
    self.windowLevel = UIWindowLevelNormal;
  }
  
  return self;
}

- (void)layoutAnimationView
{
  _animationView = [[UIImageView alloc] init];
  _animationView.hidden = YES;
  _animationView.layer.shadowColor = [UIColor blackColor].CGColor;
  _animationView.layer.shadowOffset = CGSizeMake(1, 1);
  _animationView.layer.shadowOpacity = 1;
  _animationView.layer.shadowRadius = 3;
  
  [self addSubview:_animationView];
}

- (void)manageLongPressGesture
{
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(pressHandle:)];
  [self addGestureRecognizer:longPress];
}

#pragma mark -
#pragma mark Long Press Gesture Handler

- (void)pressHandle:(UILongPressGestureRecognizer *)longPress
{
  switch (longPress.state) {
    case UIGestureRecognizerStateBegan:
    {
      if ([self.longPressDelegate respondsToSelector:@selector(window:longPressDidStart:)]) {
        [_longPressDelegate window:self longPressDidStart:longPress];
      }
    }
      break;
    case UIGestureRecognizerStateChanged:
    {
      if ([self.longPressDelegate respondsToSelector:@selector(window:longPressDidChange:)]) {
        [_longPressDelegate window:self longPressDidChange:longPress];
      }
    }
      break;
    case UIGestureRecognizerStateEnded:
    {
      if ([self.longPressDelegate respondsToSelector:@selector(window:longPressDidEnd:)]) {
        [_longPressDelegate window:self longPressDidEnd:longPress];
      }
    }
      break;
    default:
      break;
  }
}

@end
