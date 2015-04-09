//
//  FileModel.m
//  FileManager
//
//  Created by Bin Chen on 14-7-4.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import "FileModel.h"
#import "FileType.h"

@interface FileModel ()

@property (nonatomic, readonly) NSDictionary *attributes;

@end

@implementation FileModel

- (instancetype)initWithFileName:(NSString *)aFileName andFilePath:(NSString *)aFilePath
{
  self = [super init];
  if (self) {
    
    if (aFileName && aFileName.length > 0) {
      _fileName = aFileName;
    }
    else
    {
      _fileName = aFilePath.lastPathComponent;
    }
    
    _filePath = aFilePath;
    
    if (_fileName.pathExtension && _fileName.pathExtension.length > 0) {
      _isFolder = NO;
    }
    else
    {
      _isFolder = YES;
    }
  }
  return self;
}

- (NSInteger)typeOfFile
{
  if ([@"txt" isEqualToString:_fileName.pathExtension]) {
    return kTextFileType;
  }
  else
  {
    return kUnKnownFileType;
  }
}

#pragma mark-
#pragma mark ReadOnly Properties

- (NSInteger)size
{
  return [[self.attributes objectForKey:NSFileSize] integerValue];
}

- (NSString *)fileType
{
  if (_isFolder) {
    return @"文件夹";
  }
  else{
    switch ([self typeOfFile]) {
      case 1:
        return @"文本文档";
        break;
      default:
        return @"不明确类型";
        break;
    }
  }
  
//  return [self.attributes objectForKey:NSFileType];
}

/**
 *  获取文件在文件树的第几层（横向广度）
 *
 *  @return NSInteger
 */
- (NSInteger)depth
{
  NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@",_filePath,_fileName];
  NSString *objcPath = [path substringFromIndex:BCDocumentsDirectory().length];
  
  NSArray *fileNames = [objcPath componentsSeparatedByString:@"/"];
  return fileNames.count - 1;
}

- (NSArray *)childs
{
  BCFileManager *fileManager = [BCFileManager getInstance];
  return [fileManager subFilesInCurrentFolder:self];
}

- (NSDictionary *)attributes
{
  BCFileManager *fileManager = [BCFileManager getInstance];
  return [fileManager attributesOFFile:self];
}

@end
