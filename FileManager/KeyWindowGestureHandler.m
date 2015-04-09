//
//  KeyWindowGestureHandler.m
//  FileManager
//
//  Created by Bin Chen on 15/4/9.
//  Copyright (c) 2015年 ideabinder. All rights reserved.
//

#import "KeyWindowGestureHandler.h"

#import "UIView+snapshot.h"
#import "UITableView+CellAtPoint.h"

#import "FileListViewController.h"

#import "FileModel.h"

#define kWindowFileListViewOffset 64
#define kRowHeight 44

@interface KeyWindowGestureHandler ()

@property (nonatomic, readonly) UITableView                   *filesListView;

@property (nonatomic, strong) NSIndexPath *currentHighlyIndex;
@property (nonatomic, assign) CGFloat      touchLocationOffset;
@property (nonatomic, assign) CGPoint      touchStartPoint;
@property (nonatomic, assign) CGPoint      touchChangedPoint;

@property (nonatomic, strong) FileModel   *operateFile;
@property (nonatomic, strong) NSTimer     *moveFileMonitor;

@property (nonatomic, assign) BOOL         isNeedMoveFileInfoFolder;
@property (nonatomic, assign) BOOL         isEmptyFolder;

@end

@implementation KeyWindowGestureHandler

#pragma mark -
#pragma mark Public

- (void)cleanDatasCaches
{
  _isNeedMoveFileInfoFolder = NO;
  
  _isEmptyFolder = NO;
  
  if (_operateFile) {
    _operateFile = nil;
  }
  
  if (_currentHighlyIndex) {
    _currentHighlyIndex = nil;
  }
  
  if (_moveFileMonitor) {
    [_moveFileMonitor invalidate];
    _moveFileMonitor = nil;
  }
  
}

#pragma mark -
#pragma Window Delegate

- (void)window:(LongPressGestureHandlerWindow *)window longPressDidStart:(UILongPressGestureRecognizer *)longPress
{
  _touchChangedPoint = [longPress locationInView:window];
  _touchStartPoint = [self.filesListView convertPoint:[longPress locationInView:window] fromView:window];
  
  NSIndexPath *indexPath = [self.filesListView indexPathForRowAtPoint:_touchStartPoint];
  UITableViewCell *cell = [self.filesListView cellForRowAtIndexPath:indexPath];
  _touchLocationOffset = _touchStartPoint.y - cell.frame.origin.y;
  UIImage *cellSnapshot = [cell snapshot];
  
  CGRect cellFrame = cell.frame;
  cellFrame.origin.y += kWindowFileListViewOffset;
  [window.animationView setImage:cellSnapshot];
  [window.animationView setFrame:cellFrame];
  [window.animationView setHidden:NO];
  
  [window bringSubviewToFront:window.animationView];
  
  [self deleteCellAtIndexPath:indexPath];
}

- (void)window:(LongPressGestureHandlerWindow *)window longPressDidChange:(UILongPressGestureRecognizer *)longPress
{
  if (_moveFileMonitor) {
    [_moveFileMonitor invalidate];
  }
  
  CGPoint pointAtWindow = [longPress locationInView:window];
  CGPoint pointAtListView = [self.filesListView convertPoint:pointAtWindow fromView:window];
  if (window.animationView && window.animationView.hidden == NO) {
    window.animationView.transform = CGAffineTransformTranslate(window.animationView.transform,
                                                                        pointAtWindow.x - _touchChangedPoint.x,
                                                                        pointAtWindow.y - window.animationView.frame.origin.y - _touchLocationOffset);
    
    NSIndexPath *indexPath = [self.filesListView indexPathForRowAtPoint:pointAtListView];
    
    if (indexPath && _currentHighlyIndex.row != indexPath.row) {
      [self.filesListView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      [self.filesListView deselectRowAtIndexPath:_currentHighlyIndex animated:NO];
      _currentHighlyIndex = indexPath;
    }
    else if (!indexPath)
    {
      [self.filesListView deselectRowAtIndexPath:_currentHighlyIndex animated:NO];
      _currentHighlyIndex = nil;
    }
  }
  
  if (CGRectContainsPoint(CGRectMake(0, 20, 100, 44), pointAtWindow)) {
    _moveFileMonitor = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backToUpFolder) userInfo:nil repeats:NO];
  }
  else if(CGRectContainsPoint(CGRectMake(0, 64, 320, 480 - 64), pointAtWindow))
  {
    _moveFileMonitor = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(enterFolder) userInfo:nil repeats:YES];
  }
  _touchChangedPoint = pointAtWindow;
  
}

- (void)window:(LongPressGestureHandlerWindow *)window longPressDidEnd:(UILongPressGestureRecognizer *)longPress
{
  if (_moveFileMonitor) {
    [_moveFileMonitor invalidate];
  }
  
  CGPoint endPointAtList = [self.filesListView convertPoint:[longPress locationInView:window] fromView:window];
  NSIndexPath *indexPath = [self.filesListView indexPathForRowAtPoint:endPointAtList];
  
  if (!indexPath) {
    [UIView animateWithDuration:.4 animations:^{
      CGFloat startPointY = _isNeedMoveFileInfoFolder?self.filesListViewController.files.count*kRowHeight:_touchStartPoint.y;
      CGFloat startPointX = _isNeedMoveFileInfoFolder?0:_touchStartPoint.x;
      window.animationView.transform = CGAffineTransformTranslate(window.animationView.transform,
                                                                          startPointX - endPointAtList.x,
                                                                          startPointY - endPointAtList.y);
    } completion:^(BOOL finished) {
      NSIndexPath *oldIndex = [self.filesListView indexPathForRowAtPoint:_touchStartPoint];
      if (!oldIndex) {
        _isEmptyFolder = YES;
        oldIndex = [NSIndexPath indexPathForRow:self.filesListViewController.files.count inSection:0];
      }
      
      [self insertCellAtIndexPath:oldIndex];
      window.animationView.hidden = YES;
      if (_isNeedMoveFileInfoFolder) {
        [self didMoveFileIntoFolderAtIndexPath:nil];
      }
    }];
  }
  else
  {
    [UIView animateWithDuration:.3 animations:^{
      window.animationView.hidden = YES;
    } completion:^(BOOL finished) {
      [self didMoveFileIntoFolderAtIndexPath:indexPath];
    }];
  }
}

#pragma mark -
#pragma mark Private

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath
{
  [self.filesListView beginUpdates];
  NSMutableArray *sourseFiles = [NSMutableArray arrayWithArray:self.filesListViewController.files];
  
  self.operateFile = [sourseFiles objectAtIndex:indexPath.row];
  [sourseFiles removeObjectAtIndex:indexPath.row];
  self.filesListViewController.files = sourseFiles;
  [self.filesListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  [self.filesListView endUpdates];
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath
{
  [self.filesListView beginUpdates];
  
  [self.filesListView insertRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];
  NSMutableArray *sourceFiles = [NSMutableArray arrayWithArray:self.filesListViewController.files];
  [sourceFiles insertObject:self.operateFile atIndex:indexPath.row];
  self.filesListViewController.files = sourceFiles;
  [self.filesListView endUpdates];
  [self.filesListView reloadData];
}

- (void)backToUpFolder
{
  NSNotification *noti = [[NSNotification alloc] initWithName:@"didBackToUpFolder"
                                                       object:nil
                                                     userInfo:nil];
  [[NSNotificationCenter defaultCenter] postNotification:noti];
  _isNeedMoveFileInfoFolder = !_isNeedMoveFileInfoFolder;
}

- (void)enterFolder
{
  if (self.filesListViewController.files && self.filesListViewController.files.count > 0) {
    FileModel *fileProperties = self.filesListViewController.files[_currentHighlyIndex.row];
    NSNotification *noti = [[NSNotification alloc] initWithName:@"didOpenDirectory"
                                                         object:nil
                                                       userInfo:@{@"selectFile":fileProperties}];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    _isNeedMoveFileInfoFolder = YES;
  }
}

- (void)didMoveFileIntoFolderAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *folderPath;
  
  if (indexPath) {
    FileModel *fileProperties = self.filesListViewController.files[indexPath.row];
    folderPath = [NSString stringWithFormat:@"%@/%@", fileProperties.filePath, fileProperties.fileName];
  }
  else
  {
    folderPath = self.filesListViewController.directoryPath;
  }
  
  NSNotification *noti = [[NSNotification alloc] initWithName:@"didMoveFileIntoFolder"
                                                       object:nil
                                                     userInfo:@{@"operateFile":self.operateFile,
                                                                @"folder":folderPath}];
  [[NSNotificationCenter defaultCenter] postNotification:noti];
}

#pragma mark -
#pragma mark - Properties

- (UITableView *)filesListView
{
  return self.filesListViewController.fileListView;
}

#pragma mark -
#pragma mark Singleton

static id instance = nil;

+ (instancetype)getInstance
{
  if (!instance) {
    @synchronized(self)
    {
      if (!instance) {
        instance = [[self alloc] init];
      }
    }
  }
  
  return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
  if (!instance) {
    @synchronized(self)
    {
      if (!instance) {
        instance = [super allocWithZone:zone];
      }
    }
  }
  
  return instance;
}

- (instancetype)copy
{
  return instance;
}

@end
