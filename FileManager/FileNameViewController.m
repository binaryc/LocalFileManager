//
//  FileNameViewController.m
//  FileManager
//
//  Created by Bin Chen on 15/4/7.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import "FileNameViewController.h"

@interface FileNameViewController ()

@property (nonatomic, strong) UITextField *nameField;

@end

@implementation FileNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor grayColor];
  self.view.alpha = 0.3;
  
  _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 320, 60)];
  _nameField.text = @"Untitled";
  _nameField.textAlignment = NSTextAlignmentCenter;
  _nameField.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_nameField];
  
  UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [completeButton setFrame:CGRectMake(110, 170, 100, 30)];
  completeButton.backgroundColor = [UIColor whiteColor];
  [completeButton addTarget: self action:@selector(confirmAddNewFolder) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:completeButton];
}

- (void)confirmAddNewFolder
{
  NSNotification *noti = [[NSNotification alloc] initWithName:@"didConfirmAddNewFolder"
                                                       object:nil
                                                     userInfo:@{@"fileName":_nameField.text}];
  [[NSNotificationCenter defaultCenter] postNotification:noti];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
