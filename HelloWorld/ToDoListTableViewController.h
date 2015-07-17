//
//  ToDoListTableViewController.h
//  HelloWorld
//
//  Created by Quang Phuong on 4/20/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@interface ToDoListTableViewController : UITableViewController <UIAlertViewDelegate>

@property NSInteger selectedRow;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@property ToDoItem *toDoItem;
@property NSMutableArray *toDoItems;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end


