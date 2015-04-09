//
//  ViewController.m
//  FileManager
//
//  Created by Bin Chen on 14-7-4.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import "ViewController.h"
#import "FileListViewController.h"
#import "FileNameViewController.h"

#import "FileModel.h"
#import "LogoView.h"

#import "UIView+snapshot.h"

#import "KeyWindowGestureHandler.h"

@interface ViewController ()
<UINavigationControllerDelegate>

@property (nonatomic, strong) FileListViewController *rootFileListViewController;
@property (nonatomic, strong) FileListViewController *currentIndexController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
	// Do any additional setup after loading the view, typically from a nib.

  FileModel *rootDirectory = [[FileModel alloc] initWithFileName:@"Documents"
                                                     andFilePath:NSHomeDirectory()];
  [self configBasicInfoWithRootPath:rootDirectory];
  [self becomeFileObserver];
  [self layoutNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBasicInfoWithRootPath:(FileModel *)fileModel
{
  self.title = fileModel.fileName;
  self.automaticallyAdjustsScrollViewInsets = YES;
  _rootFileListViewController = [[FileListViewController alloc] init];
  _rootFileListViewController.files = fileModel.childs;
  _rootFileListViewController.directoryPath = [NSString stringWithFormat:@"%@/%@", fileModel.filePath, fileModel.fileName];
  _currentIndexController = _rootFileListViewController;
  [self addChildViewController:_rootFileListViewController];
  [self.view addSubview:_rootFileListViewController.view];
  
  [[KeyWindowGestureHandler getInstance] setFilesListViewController:_currentIndexController];
}

- (void)layoutNavigationBar
{
  UIBarButtonItem *addNewFolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addNewFolder)];
  self.navigationItem.rightBarButtonItem = addNewFolderItem;
  self.navigationController.delegate = self;
}

- (void)becomeFileObserver
{
  NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
  [notification addObserver:self
                   selector:@selector(openDirectory:)
                       name:@"didOpenDirectory"
                     object:nil];
  [notification addObserver:self
                   selector:@selector(confirmAddNewFolder:)
                       name:@"didConfirmAddNewFolder"
                     object:nil];
  [notification addObserver:self
                   selector:@selector(moveFileIntoFolder:)
                       name:@"didMoveFileIntoFolder"
                     object:nil];
  [notification addObserver:self
                   selector:@selector(backToUpFolder:)
                       name:@"didBackToUpFolder"
                     object:nil];
}

- (void)openDirectory:(NSNotification *)noti
{
  FileModel *fileProperties = [noti.userInfo objectForKey:@"selectFile"];
  FileListViewController *directoryController = [[FileListViewController alloc] init];
  directoryController.directoryPath = [NSString stringWithFormat:@"%@/%@",fileProperties.filePath, fileProperties.fileName];
  directoryController.files = fileProperties.childs;
  directoryController.title = fileProperties.fileName;
  [self.navigationController pushViewController:directoryController animated:YES];
}

- (void)addNewFolder
{
  FileNameViewController *nameViewController = [[FileNameViewController alloc] init];
  [self presentViewController:nameViewController animated:YES completion:^{
    
  }];
  
}

- (void)confirmAddNewFolder:(NSNotification *)noti
{
  NSString *folderName = [noti.userInfo objectForKey:@"fileName"];
  FileModel *fileModel = [[FileModel alloc] initWithFileName:folderName
                                                 andFilePath:_currentIndexController.directoryPath];
  [[BCFileManager getInstance] createFolder:fileModel andAttributes:nil];
  
  NSMutableArray *files = [NSMutableArray arrayWithArray:_currentIndexController.files];
  [files addObject:fileModel];
  _currentIndexController.files = files;
  [_currentIndexController.fileListView reloadData];
}

- (void)moveFileIntoFolder:(NSNotification *)noti
{
  FileModel *operateFile = [noti.userInfo objectForKey:@"operateFile"];
  NSString *folder = [noti.userInfo objectForKey:@"folder"];
  [[BCFileManager getInstance] moveFile:operateFile toPath:folder];
  [[KeyWindowGestureHandler getInstance] cleanDatasCaches];
}

- (void)backToUpFolder:(NSNotification *)noti
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmRename
{
  
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if (viewController != self) {
    _currentIndexController = (FileListViewController *)viewController;
  }
  else
  {
    _currentIndexController = _rootFileListViewController;
  }
  
  [[KeyWindowGestureHandler getInstance] setFilesListViewController:_currentIndexController];
  
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Properties

- (UITableView *)fileListView
{
  return self.currentIndexController.fileListView;
}

@end
