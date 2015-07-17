//
//  ToDoListTableViewController.m
//  HelloWorld
//
//  Created by Quang Phuong on 4/20/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "AddToDoItemViewController.h"
#import "WorkDetail.h"
#import "FMDatabase.h"
#import "ToDoItemDAO.h"
#import "TableCell.h"
#import "SWRevealViewController.h"
#import "M13BadgeView.h"


@interface ToDoListTableViewController ()


@end

@implementation ToDoListTableViewController

- (void)getAllData {
    ToDoItemDAO *dao = [ToDoItemDAO alloc];
    self.toDoItems = [dao getAllData];
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

//Add trigger to alert button

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // Is this my Alert View?
    if (alertView.tag == 1) {
//        if (buttonIndex != alertView.cancelButtonIndex)
//        {
//            
//        }
        
        if (buttonIndex == 1) // Remove Button
        {
            [self removeItem];
        }
        else if (buttonIndex == 2) // Other Button
        {
            
        }
    }
    else { //Other Alert

    }
    
}

//////////////

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    
    if (pGesture.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
        UITableView* tableView = (UITableView*)self.view;
        CGPoint touchPoint = [pGesture locationInView:self.view];
        NSIndexPath* row = [tableView indexPathForRowAtPoint:touchPoint];
        _selectedRow = row.row;
        
        
        if (row != nil) {
            //ToDoItem *item = [self.toDoItems objectAtIndex:_selectedRow];

                //Handle the long press on row
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Choose an action:"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Remove", nil];
                alert.tag = 1;
                [alert show];
        }
    }
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.toDoItems = [[NSMutableArray alloc] init];
    [self getAllData];
    
    //Add sidebar effect
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //Add long press event
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.toDoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    if ((cell==nil) || (![cell isKindOfClass: TableCell.class]))
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forCellReuseIdentifier:@"tableCell"];
        
        cell =(TableCell *) [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
        
    }
    // Configure the cell...
    cell.btnInfo.tag = indexPath.row;
    [cell.btnInfo addTarget:self action:@selector(btnInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btnInfoClicked:(UIButton*)sender{
    _selectedRow = sender.tag;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(TableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = toDoItem.itemName;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

    [dateFormat setDateFormat:@"hh:mm:ss dd/MM/yyyy"];
    cell.dateLabel.text = [dateFormat stringFromDate:toDoItem.creationDate];
    M13BadgeView *badgeView;
    if (toDoItem.completed) {
        cell.btnInfo.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:toDoItem.itemName attributes:attributes];
        
        cell.nameLabel.attributedText = attributedString;
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.tintColor = [UIColor colorWithRed:83.0f/255.0f green:217.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
        badgeView.hidden = YES;
        
        NSArray *viewsToRemove = [cell.nameLabel subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
    } else {
        if (![badgeView isDescendantOfView: cell.nameLabel]){
        badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 24.0, 24.0)];
            [badgeView setMaximumWidth:50.0];
            [badgeView setFont:[UIFont systemFontOfSize:10]];
            badgeView.alpha = 0.5;
            badgeView.text = @"expired";
        }
        
        cell.btnInfo.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        
        NSDate *today = [NSDate date];
        NSArray *viewsToRemove = [cell.nameLabel subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        if([today compare:toDoItem.expiredDate]==NSOrderedDescending){
            cell.tintColor = [UIColor redColor];
            
            if (![badgeView isDescendantOfView: cell.nameLabel]){
                [cell.nameLabel addSubview:badgeView];
            }
            
        }else{
            cell.tintColor = [UIColor grayColor];
        }
        
    }
}



//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 78;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        _selectedRow = indexPath.row;
        [self removeItem];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate
//Toggle completed item

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    
    //Update completed to DB
    ToDoItemDAO *dao = [ToDoItemDAO alloc];
    [dao updateItemCompleted:tappedItem];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        WorkDetail *workDetail = segue.destinationViewController;
        
        ToDoItem *item = [self.toDoItems objectAtIndex:_selectedRow];
        workDetail.tilte = item.itemName;
                
        workDetail.date = item.creationDate;
        
        workDetail.detail = item.itemDetail;
        workDetail.deadline = item.expiredDate;
    }
    
}

-(void)removeItem{
    ToDoItem *item = [self.toDoItems objectAtIndex:_selectedRow];
    ToDoItemDAO *dao = [ToDoItemDAO alloc];
    [dao removeItem:item];
    [self.toDoItems removeObject:item];
    //[self.tableView reloadData];
}



@end



