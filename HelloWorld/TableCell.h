//
//  TableViewCell.h
//  HelloWorld
//
//  Created by Quang Phuong on 4/24/15.
//  Copyright (c) 2015 Quang Phuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnInfo;

@end
