//
//  BCFileManager.h
//  FileManager
//
//  Created by Bin Chen on 14-7-4.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileModel.h"

@interface BCFileManager : NSObject

+ (instancetype)getInstance;

@end

#pragma mark-
#pragma mark BCFileManager category

/**
 *  文件管理类创建文件，目前只创建文件夹和文本文档
 */

@interface BCFileManager (create)

- (BOOL)createFolder:(FileModel *)aFolder
       andAttributes:(NSDictionary *)anAttributes;

- (BOOL)createTextFileAtPath:(FileModel *)aFile
               andAttributes:(NSDictionary *)anAttributes;

@end

@interface BCFileManager (readWrite)

- (NSData *)readTextContentFromFile:(FileModel *)aFile;

- (NSData *)readTextContentFromHandleFile:(FileModel *)aFile;

- (BOOL)coveredWriteContent:(NSData *)aContent
                   intoFile:(FileModel *)aFile;

- (void)seriesWriteContent:(NSData *)aContent
            intoHandleFile:(FileModel *)aFile;

@end

/**
 *  查询文件
 */

@interface BCFileManager (search)

- (NSArray *)filesAccordWithCondition:(NSString *)aCondition
                      atCurrentFolder:(FileModel *)aFolder;

- (NSArray *)allFilesAccodWithCondition:(NSString *)aCondition
                               atFolder:(FileModel *)aFolder;

@end

/**
 *  列举文件夹下的文件
 */

@interface BCFileManager (enumerated)

- (NSArray *)subFilesInCurrentFolder:(FileModel *)aFolder;

- (NSArray *)allSubFilesInFolder:(FileModel *)aFolder;

@end

@interface BCFileManager (remove)

- (BOOL)removeFile:(FileModel *)aFile;

@end

@interface BCFileManager (moveCopy)

- (BOOL)moveFile:(FileModel *)aFile toPath:(NSString *)aPath;
- (BOOL)copyFile:(FileModel *)aFile toPath:(NSString *)aPath;

@end

/**
 *  文件属性
 */

@interface BCFileManager (fileAttributes)

- (NSDictionary *)attributesOFFile:(FileModel *)aFile;
- (void)setAttributes:(NSDictionary *)anAttributes
              forFile:(FileModel *)aFile;

@end

/**
 *  NSFileHandle,实现文件安全操作，暂未实现
 */

@interface BCFileManager (safeHandle)

@end

#pragma mark-
#pragma mark Class SystemFileDomainDirectory
/**
 *  获取本应用下的目录
 */
@interface SystemFileDomainDirectory : NSObject

//FOUNDATION_EXPORT 代替了 extern
FOUNDATION_EXPORT NSString * BCDocumentsDirectory(void);
FOUNDATION_EXPORT NSString * BCLibraryDirectory(void);
FOUNDATION_EXPORT NSString * BCTemporaryDirectory(void);
FOUNDATION_EXPORT NSString * BCCachesDirectory(void);

//FOUNDATION_EXPORT NSString * BCPreferencesDirectory(void);

@end