//
//  WorkDetail.m
//  HelloWorld
//
//  Created by Quang Phuong on 4/21/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import "WorkDetail.h"
#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "ToDoItemDAO.h"

@implementation WorkDetail

@synthesize itemLabel;
@synthesize dateLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the Label text with the selected recipe
    itemLabel.text = _tilte;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"hh:mm:ss dd/MM/yyyy"];
    dateLabel.text = [dateFormat stringFromDate:_date];
    
    [self.datepicker setDate:_deadline];
    
    [self.datepicker setMinimumDate:_date];
    _commentTxtView.text = _detail;
    
    _commentTxtView.layer.cornerRadius=8.0f;
    _commentTxtView.layer.masksToBounds=YES;
    _commentTxtView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _commentTxtView.layer.borderWidth= 1.0f;
    
    if(_commentTxtView.text.length == 0){
        _commentTxtView.text = @"Add description";
        _commentTxtView.textColor = [UIColor lightGrayColor];
        _commentTxtView.delegate = self;
    }
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _commentTxtView.text = @"";
    _commentTxtView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_commentTxtView.text.length == 0){
        _commentTxtView.textColor = [UIColor lightGrayColor];
        _commentTxtView.text = @"Add description";
        [_commentTxtView resignFirstResponder];
    }
}

-(void) showNotification:(NSDate *)expiredDate{
    UILocalNotification *updateThisNotification = nil;
    BOOL hasNotification = NO;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:_tilte] isEqualToString:_tilte]) {
            updateThisNotification = someNotification;
            hasNotification = YES;
            break;
        }
    }
    updateThisNotification.fireDate = expiredDate;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:updateThisNotification];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (_commentTxtView.text.length > 0 ||![self.datepicker.date isEqualToDate:_deadline]||![self.itemLabel.text isEqualToString:_tilte]) {
        
        [self showNotification:self.datepicker.date];
        
        
        
        self.toDoItem = [[ToDoItem alloc] init];
        self.toDoItem.itemName = _tilte;
        if([_commentTxtView.text isEqualToString:@"Add description"]){
            self.toDoItem.itemDetail = @"";
        }else{
            self.toDoItem.itemDetail = _commentTxtView.text;
        }
        
        if(self.itemLabel.text.length > 0){
            self.toDoItem.itemName = self.itemLabel.text;
        }
        self.toDoItem.creationDate = _date;
        self.toDoItem.expiredDate = self.datepicker.date;
        self.toDoItem.completed = NO;
        
        
        ToDoItemDAO *dao = [ToDoItemDAO alloc];
        ToDoListTableViewController *source = segue.destinationViewController;
        ToDoItem *item = self.toDoItem;
        if (item != nil) {
            for (int i = 0; i < source.toDoItems.count; i++) {
                ToDoItem *obj = [source.toDoItems objectAtIndex:i];
                if([_tilte isEqualToString: obj.itemName]){
                    [source.toDoItems replaceObjectAtIndex:i withObject:item];
                    [source.tableView reloadData];
                    [dao updateItemDetail:item];
                    break;
                }
            }
        }
        
        
    }
}

@end
