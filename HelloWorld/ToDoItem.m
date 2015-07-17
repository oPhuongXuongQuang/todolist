//
//  ToDoItem.m
//  HelloWorld
//
//  Created by Quang Phuong on 4/21/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@interface ToDoItem ()
@property NSDate *completionDate;
@end

@implementation ToDoItem

- (void)markAsCompleted:(BOOL)isComplete {
    self.completed = isComplete;
    [self setCompletionDate];
}

- (void)setCompletionDate {
    if (self.completed) {
        self.completionDate = [NSDate date];
    } else {
        self.completionDate = nil;
    }
}

@end