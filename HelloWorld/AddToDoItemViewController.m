//
//  AddToDoItemViewController.m
//  HelloWorld
//
//  Created by Quang Phuong on 4/20/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import "AddToDoItemViewController.h"
#import "ToDoListTableViewController.h"
#import "ToDoItemDAO.h"

@interface AddToDoItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddToDoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender != self.saveButton) return;
    if (self.textField.text.length > 0) {
        self.toDoItem = [[ToDoItem alloc] init];
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.creationDate = [NSDate date];
        self.toDoItem.completed = NO;
        self.toDoItem.expiredDate = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    }
    
    ToDoListTableViewController *source = segue.destinationViewController;
    
    [source.toDoItems addObject:self.toDoItem];
    ToDoItemDAO *dao = [ToDoItemDAO alloc];
    [dao addItem:self.toDoItem];
    
    [self showNotification:self.toDoItem.itemName expiredDate:self.toDoItem.expiredDate];
    
    [source.tableView reloadData];
    
}

-(void) showNotification:(NSString *)name expiredDate:(NSDate *)expiredDate{
    // Get the current date
    NSDate *pickerDate = expiredDate;
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = pickerDate;
    localNotification.alertBody = name;
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:name forKey:name];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}


@end
