//
//  WorkDetail.h
//  HelloWorld
//
//  Created by Quang Phuong on 4/21/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@interface WorkDetail : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@property (nonatomic, strong) NSString *tilte;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic, strong) NSString *detail;
@property (weak, nonatomic) IBOutlet UITextView *commentTxtView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;

@property ToDoItem *toDoItem;

-(void) showNotification;

@end
