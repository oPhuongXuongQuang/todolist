//
//  ToDoItem.h
//  HelloWorld
//
//  Created by Quang Phuong on 4/21/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#ifndef HelloWorld_ToDoItem_h
#define HelloWorld_ToDoItem_h


@interface ToDoItem : NSObject

@property NSString *itemName;
@property NSString *itemDetail;
@property BOOL completed;
@property NSDate *creationDate;
@property NSDate *expiredDate;
- (void)markAsCompleted:(BOOL)isComplete; //- (void)markAsCompleted:(BOOL)isComplete onDate:(NSDate*)date;


@end

#endif
