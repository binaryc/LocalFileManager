//
//  FileListViewController.m
//  FileManager
//
//  Created by Bin Chen on 15/4/7.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import "FileListViewController.h"

#import "FileModel.h"

#import "UIView+snapshot.h"

@interface FileListViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite) UITableView *fileListView;
@property (nonatomic, strong) NSMutableArray *filesSource;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self layoutFileListView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadFileList
{
  [self.fileListView reloadData];
}

- (void)layoutFileListView
{
  _fileListView = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
  
  //由于时间问题，代理没有独立出来
  _fileListView.delegate = self;
  _fileListView.dataSource = self;
  
  _fileListView.allowsMultipleSelectionDuringEditing = YES;  
  
  [self.view addSubview:_fileListView];
}

- (void)setFiles:(NSArray *)files
{
  _files = files;
  if (self.filesSource.count > 0) {
    [self.filesSource removeAllObjects];
  }
  if (!self.filesSource) {
    self.filesSource = [[NSArray array] mutableCopy];
  }
  [self.filesSource addObjectsFromArray:_files];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _filesSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"FileCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:identifier];
  }
  
  FileModel *fileProperties = _filesSource[indexPath.row];
  
  cell.textLabel.text = [NSString stringWithFormat:@"我是%@,我叫%@", fileProperties.fileType, fileProperties.fileName];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //利用策略模式取代开不同类型的文件，但没有时间暂时只是打开文件夹操作
  FileModel *fileProperties = _filesSource[indexPath.row];
  if ([fileProperties.fileType isEqualToString:@"文件夹"])
  {
    NSNotification *noti = [[NSNotification alloc] initWithName:@"didOpenDirectory"
                                                         object:nil
                                                       userInfo:@{@"selectFile":fileProperties}];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
  }
}

@end
