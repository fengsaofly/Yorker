//
//  FlyActivityListCell.h
//  Yorker
//
//  Created by 肖逸飞 on 14-3-7.
//  Copyright (c) 2014年 SCU. All rights reserved.
//

#import "Cell.h"

@interface FlyActivityListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activity_name;
@property (weak, nonatomic) IBOutlet UILabel *activity_address;
@property (weak, nonatomic) IBOutlet UILabel *activity_peopleNum;

@end
