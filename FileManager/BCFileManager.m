//
//  BCFileManager.m
//  FileManager
//
//  Created by Bin Chen on 14-7-4.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import "BCFileManager.h"

@interface BCFileManager ()
<NSFileManagerDelegate>

@property (nonatomic, readonly) NSFileManager *managerObject;
@property (nonatomic, assign  ) NSInteger      counter;

@end

@implementation BCFileManager

#pragma mark-
#pragma mark Singleton

- (instancetype)init
{
  if (self = [super init]) {
    _managerObject = [[NSFileManager alloc] init];
    _managerObject.delegate = self;
  }
  
  return self;
}

static id instance = nil;

+ (instancetype)getInstance
{
  @synchronized(self)
  {
    if (!instance) {
      instance = [[self alloc] init];
    }
    
    return instance;
  }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
  @synchronized(self)
  {
    if (!instance) {
      instance = [super allocWithZone:zone];
    }

    return instance;
  }
}

- (instancetype)copyWithZone:(NSZone *)zone
{
  return self;
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldMoveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
  return YES;
}

@end

#pragma mark-
#pragma mark BCFileManager category

@implementation BCFileManager (create)

- (BOOL)createFolder:(FileModel *)aFolder
       andAttributes:(NSDictionary *)anAttributes
{
  NSString *folder = [NSString stringWithFormat:@"%@/%@", aFolder.filePath, aFolder.fileName];
  NSError *error;
  BOOL succeed = [_managerObject createDirectoryAtPath:folder
                           withIntermediateDirectories:YES
                                            attributes:anAttributes
                                                 error:&error];
  
  return succeed;
}

- (BOOL)createTextFileAtPath:(FileModel *)aFile
               andAttributes:(NSDictionary *)anAttributes
{
  NSData *data = [NSData data];
  NSString *file = [NSString stringWithFormat:@"%@/%@.txt", aFile.filePath, aFile.fileName];
  
  BOOL succeed = [_managerObject createFileAtPath:file
                                         contents:data
                                       attributes:anAttributes];
  
  return succeed;
}


@end

@implementation BCFileManager (readWrite)

- (NSData *)readTextContentFromFile:(FileModel *)aFile
{
  NSString *file = [NSString stringWithFormat:@"%@/%@",aFile.filePath,aFile.fileName];
  NSData *data = [[NSData alloc] initWithContentsOfFile:file];
  return data;
}

- (BOOL)coveredWriteContent:(NSData *)aContent
                   intoFile:(FileModel *)aFile
{
  NSString *file = [NSString stringWithFormat:@"%@/%@.txt", aFile.filePath, aFile.fileName];
  BOOL succeed = [aContent writeToFile:file
                            atomically:YES];
  return succeed;
}

//测试上述方法性能好还是下面NSFileHandle性能高
//writeToFile方式是覆盖写入，NSFileHandle是连续写入 NSFileHandle读取数据时可以加读写权限

- (NSData *)readTextContentFromHandleFile:(FileModel *)aFile
{
  NSString *file = [NSString stringWithFormat:@"%@/%@.txt", aFile.filePath, aFile.fileName];
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:file];
  NSData *data = [fileHandle readDataToEndOfFile];
  [fileHandle closeFile];
  return data;
}

- (void)seriesWriteContent:(NSData *)aContent
            intoHandleFile:(FileModel *)aFile
{
  NSString *file = [NSString stringWithFormat:@"%@/%@.txt", aFile.filePath, aFile.fileName];
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:file];
  [fileHandle seekToEndOfFile];
  [fileHandle writeData:aContent];
  [fileHandle closeFile];
}

@end

@implementation BCFileManager (search)

- (NSArray *)filesAccordWithCondition:(NSString *)aCondition
                      atCurrentFolder:(FileModel *)aFolder
{
  NSArray *results = [self subFilesInCurrentFolder:aFolder];
  NSMutableArray *finalResult = [NSMutableArray array];
  
  for (FileModel *file in results) {
    if ([file.fileName rangeOfString:aCondition].length != NSNotFound) {
      [finalResult addObject:file];
    }
  }
  
  return finalResult;
}

- (NSArray *)allFilesAccodWithCondition:(NSString *)aCondition
                               atFolder:(FileModel *)aFolder
{
  NSArray *results = [self allSubFilesInFolder:aFolder];
  NSMutableArray *finalResult = [NSMutableArray array];
  
  for (FileModel *file in results) {
    if ([file.fileName rangeOfString:aCondition].length != NSNotFound) {
      [finalResult addObject:file];
    }
  }
  
  return finalResult;
}

@end

@implementation BCFileManager (enumerated)

- (NSArray *)subFilesInCurrentFolder:(FileModel *)aFolder
{
  NSError *error;
  NSString *folder = [NSString stringWithFormat:@"%@/%@", aFolder.filePath, aFolder.fileName];
  NSArray *subfiles = [_managerObject contentsOfDirectoryAtPath:folder
                                                          error:&error];
  
  NSMutableArray *modelFiles = [NSMutableArray array];
  
  for (NSString *fileName in subfiles) {
    if ([fileName hasSuffix:@".DS_Store"]) {
      continue;
    }
    else
    {
      [modelFiles addObject:[[FileModel alloc] initWithFileName:fileName
                                                    andFilePath:folder]];
    }
  }
  
  return modelFiles;
}

- (NSArray *)allSubFilesInFolder:(FileModel *)aFolder
{
  NSError *error;
  NSString *folder = [NSString stringWithFormat:@"%@/%@", aFolder.filePath, aFolder.fileName];
  NSMutableArray *subfiles = [NSMutableArray array];
  NSArray *allSubfiles = [_managerObject subpathsOfDirectoryAtPath:folder
                                                             error:&error];
  
  for (NSString *fileName in allSubfiles) {
    if ([fileName hasSuffix:@".DS_Store"]) {
      continue;
    }
    else
    {
      [subfiles addObject:[[FileModel alloc] initWithFileName:fileName
                                                    andFilePath:folder]];
    }
  }
  
  return subfiles;
}

@end

@implementation BCFileManager (remove)

- (BOOL)removeFile:(FileModel *)aFile
{
  NSError *error;
  NSString *file = [NSString stringWithFormat:@"%@/%@",aFile.filePath,aFile.fileName];
  
  BOOL succeed = [_managerObject removeItemAtPath:file error:&error];
  
  return succeed;
}

@end

@implementation BCFileManager (fileAttributes)

- (NSDictionary *)attributesOFFile:(FileModel *)aFile
{
  NSString *path = [NSString stringWithFormat:@"%@/%@",aFile.filePath,aFile.fileName];
  NSError *error;
  
  return [_managerObject attributesOfItemAtPath:path
                                          error:&error];
}

- (void)setAttributes:(NSDictionary *)anAttributes
              forFile:(FileModel *)aFile
{
  NSString *path = [NSString stringWithFormat:@"%@/%@",aFile.filePath,aFile.fileName];
  NSError *error;
  
  [_managerObject setAttributes:anAttributes
                   ofItemAtPath:path
                          error:&error];
}

@end

@implementation BCFileManager (moveCopy)

- (BOOL)moveFile:(FileModel *)aFile toPath:(NSString *)aPath
{
  NSError *error;
  NSString *filePath = [NSString stringWithFormat:@"%@/%@",aFile.filePath, aFile.fileName];
  NSString *dstPath = [NSString stringWithFormat:@"%@/%@", aPath, aFile.fileName];
  BOOL succeed = [_managerObject moveItemAtPath:filePath toPath:dstPath error:&error];
  return succeed;
}

- (BOOL)copyFile:(FileModel *)aFile toPath:(NSString *)aPath
{
  NSError *error;
  NSString *filePath = [NSString stringWithFormat:@"%@/%@",aFile.filePath, aFile.fileName];
  BOOL succeed = [_managerObject copyItemAtPath:filePath toPath:aPath error:&error];
  return succeed;
}

@end

@implementation BCFileManager (safeHandle)



@end

#pragma mark-
#pragma mark Class SystemFileDomainDirectory

@implementation SystemFileDomainDirectory

FOUNDATION_EXPORT NSString * BCDocumentsDirectory(void)
{
  NSFileManager *fileManager = [[NSFileManager alloc] init];
  NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory
                                      inDomains:NSUserDomainMask];
  if(urls.count > 0)
  {
    NSURL *url = urls[0];
    return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),url.lastPathComponent];
  }
  else
  {
    return nil;
  }
}

FOUNDATION_EXPORT NSString * BCLibraryDirectory(void)
{
  NSFileManager *fileManager = [[NSFileManager alloc] init];
  NSArray *urls = [fileManager URLsForDirectory:NSLibraryDirectory
                                      inDomains:NSUserDomainMask];
  if(urls.count > 0)
  {
    NSURL *url = urls[0];
    return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),url.lastPathComponent];
  }
  else
  {
    return nil;
  }
}

FOUNDATION_EXPORT NSString * BCTemporaryDirectory(void)
{
  return NSTemporaryDirectory();
}

FOUNDATION_EXPORT NSString * BCCachesDirectory(void)
{
  NSFileManager *fileManager = [[NSFileManager alloc] init];
  NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory
                                      inDomains:NSUserDomainMask];
  if(urls.count > 0)
  {
    NSURL *url = urls[0];
    return [NSString stringWithFormat:@"%@/%@",BCLibraryDirectory(),url.lastPathComponent];
  }
  else
  {
    return nil;
  }
}

//FOUNDATION_EXPORT NSString * BCPreferencesDirectory(void)
//{
//  NSFileManager *fileManager = [[NSFileManager alloc] init];
//  NSArray *urls = [fileManager URLsForDirectory:NSPreferencePanesDirectory
//                                      inDomains:NSUserDomainMask];
//  if(urls.count > 0)
//  {
//    NSURL *url = urls[0];
//    return [NSString stringWithFormat:@"%@/%@",BCLibraryDirectory(),url.lastPathComponent];
//  }
//  else
//  {
//    return nil;
//  }
//}

@end