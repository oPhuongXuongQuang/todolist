//
//  DBManager.h
//  HelloWorld
//
//  Created by Quang Phuong on 4/23/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

@end
