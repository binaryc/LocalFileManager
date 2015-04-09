//
//  LogView.m
//  FileManager
//
//  Created by Bin Chen on 14-7-7.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import "LogoView.h"

@implementation LogoView
{
  UILabel *_titleLabel;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)aTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      _titleLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(0, CGRectGetHeight(frame)/2-10, CGRectGetWidth(frame), 20)];
      
      [_titleLabel setText:aTitle];
      [_titleLabel setTextColor:[UIColor blueColor]];
      [_titleLabel setTextAlignment:NSTextAlignmentCenter];
      
      self.layer.borderColor = [UIColor blueColor].CGColor;
      self.layer.borderWidth = 2;
      
      [self addSubview:_titleLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
