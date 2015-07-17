//
//  ToDoItemDAO.h
//  HelloWorld
//
//  Created by Quang Phuong on 4/23/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"
#import "FMDatabase.h"


@interface ToDoItemDAO : NSObject
{}

-(NSMutableArray *)getAllData;

-(void)addItem: (ToDoItem *) item;

-(void)updateItemDetail: (ToDoItem *) item;

-(void)updateItemCompleted: (ToDoItem *) item;

-(void)removeItem: (ToDoItem *) item;

-(void)removeAllCompleted;

-(void)removeAllExpired;

@property NSMutableArray *toDoItems;
@end
