//
//  ToDoItemDAO.m
//  HelloWorld
//
//  Created by Quang Phuong on 4/23/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import "ToDoItemDAO.h"

@interface ToDoItemDAO ()

-(void)makeConnection;

@property FMDatabase *database;

@end

@implementation ToDoItemDAO
-(void)makeConnection{
    
    NSString *dbName = @"ToDoList.sqlite";
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    //NSLog(@"%@",docsPath);
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:dbPath
                                            toPath:[NSString stringWithFormat:@"%@/%@",docsPath,dbName]
                                             error:&error];
    
    if (error != nil) {
        NSLog(@"%s", "The copy of database file has already existed.");
    }
    
    self.database = [FMDatabase databaseWithPath:[docsPath stringByAppendingPathComponent:dbName]];
}

- (NSMutableArray *)getAllData {
    [self makeConnection];

    [self.database open];
    NSString *sqlSelectQuery = @"SELECT * FROM [Items]";
    
    // Query result
    FMResultSet *results = [self.database executeQuery:sqlSelectQuery];
    self.toDoItems = [[NSMutableArray alloc]init];
    while([results next]) {
        NSString *itemName = [results stringForColumn:@"itemName"];
        NSString *itemDetail = [results stringForColumn:@"itemDetail"];
        BOOL completed = [results boolForColumn:@"completed"];
        NSDate *creationDate = [results dateForColumn:@"creationDate"];
        NSDate *expiredDate = [results dateForColumn:@"expiredDate"];
        if([itemDetail isEqualToString: @"(null)"]){
            itemDetail = @"";
        }
        
        ToDoItem *item = [[ToDoItem alloc] init];
        item.itemName = itemName;
        item.itemDetail = itemDetail;
        item.completed = completed;
        item.creationDate = creationDate;
        item.expiredDate = expiredDate;
        
        [self.toDoItems addObject:item];
        // loading your data into the array, dictionaries.
        

    }
    [self.database close];
    return self.toDoItems;
}

-(void)addItem: (ToDoItem *) item{
    [self makeConnection];

    [self.database open];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"hh:mm:ss dd/MM/yyyy"];

    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO [Items] VALUES ('%@','%@',%d,'%@','%@')",item.itemName , item.itemDetail,item.completed,[dateFormat stringFromDate:item.creationDate],[dateFormat stringFromDate:item.expiredDate]];
    [self.database executeUpdate:insertQuery];
    [self.database close];
}

-(void)updateItemDetail: (ToDoItem *) item{
    [self makeConnection];
    
    [self.database open];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"hh:mm:ss dd/MM/yyyy"];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE [Items] SET itemName = '%@',itemDetail = '%@',expiredDate = '%@' WHERE creationDate = '%@'",item.itemName,item.itemDetail , [dateFormat stringFromDate:item.expiredDate], [dateFormat stringFromDate:item.creationDate]];
    NSError *error;
    [self.database executeUpdate:query withErrorAndBindings:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }
    [self.database close];
}

-(void)updateItemCompleted: (ToDoItem *) item{
    [self makeConnection];
    
    [self.database open];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"hh:mm:ss dd/MM/yyyy"];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE [Items] SET completed = %d WHERE creationDate = '%@'",item.completed , [dateFormat stringFromDate:item.creationDate]];
    [self.database executeUpdate:query];
    [self.database close];
}

-(void)removeItem: (ToDoItem *) item{
    [self makeConnection];
    
    [self.database open];
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM [Items] WHERE itemName = '%@'",item.itemName];
    [self.database executeUpdate:query];
    [self.database close];
}

-(void)removeAllCompleted{
    [self makeConnection];
    
    [self.database open];
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM [Items] WHERE completed = %d",YES];
    [self.database executeUpdate:query];
    [self.database close];
}

-(void)removeAllExpired{
    
    self.toDoItems = [[NSMutableArray alloc]init];
    self.toDoItems = [self getAllData];
    
    [self makeConnection];
    
    [self.database open];
    
    for (int i=0; i<self.toDoItems.count; i++) {
        ToDoItem *item = [self.toDoItems objectAtIndex:i];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm:ss dd/MM/yyyy"];
        if([[NSDate date] compare:item.expiredDate]==NSOrderedDescending){
            NSString *query = [NSString stringWithFormat:@"DELETE FROM [Items] WHERE creationDate = '%@' AND completed = %d",[dateFormat stringFromDate:item.creationDate],NO];
            [self.database executeUpdate:query];
        }
    }
    [self.database close];
}
@end
