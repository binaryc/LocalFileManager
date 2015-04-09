//
//  FileModel.h
//  FileManager
//
//  Created by Bin Chen on 14-7-4.
//  Copyright (c) 2014年 ideabinder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property (nonatomic, readwrite) NSString *fileName;
@property (nonatomic, readwrite) NSString *filePath;
@property (nonatomic, readonly ) NSInteger size;
@property (nonatomic, readonly ) NSString *fileType;
@property (nonatomic           ) BOOL      isFolder;
@property (nonatomic, readonly ) NSInteger depth;
@property (nonatomic, readonly ) NSArray  *childs;

- (instancetype)initWithFileName:(NSString *)aFileName andFilePath:(NSString *)aFilePath;

@end
