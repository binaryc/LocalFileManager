//
//  FileListViewController.h
//  FileManager
//
//  Created by Bin Chen on 15/4/7.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileListViewController : UIViewController

@property (nonatomic, copy) NSString *directoryPath;
@property (nonatomic, copy) NSArray  *files;

@property (nonatomic, readonly) UITableView *fileListView;

@end
