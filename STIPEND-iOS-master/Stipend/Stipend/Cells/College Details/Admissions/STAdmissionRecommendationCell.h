//
//  STAdmissionRecommendationCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCAdmissionItem.h"
#import "STCItem.h"

@interface STAdmissionRecommendationCell : UITableViewCell

@property (nonatomic, retain) STCAdmissionItem *admissionItem;

- (void)updateCellWithDetails:(STCAdmissionItem *)details;

@end
