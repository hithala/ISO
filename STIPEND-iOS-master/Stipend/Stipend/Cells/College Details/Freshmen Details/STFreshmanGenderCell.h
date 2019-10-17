//
//  STFreshmanGenderCell.h
//  Stipend
//
//  Created by Arun S on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STGenderView.h"
#import "STCFreshmanGenderDetails.h"

@interface STFreshmanGenderCell : UITableViewCell

@property (nonatomic,weak) IBOutlet STGenderView      *genderView;

- (void) updateGenderPercentageWithDetails:(STCFreshmanGenderDetails *) details;

@end
