//
//  STTestScoresDetailCell.h
//  Stipend
//
//  Created by Arun S on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCTestScoresAndGrades+CoreDataClass.h"
#import "STCTestScoresAndGrades+CoreDataProperties.h"
#import "STCollege.h"

@interface STTestScoresDetailCell : UITableViewCell

@property (nonatomic,retain) NSOrderedSet       *testScoreDetailSet;
@property (nonatomic,retain) STCollege                     *college;
@property (nonatomic,assign) BOOL                 shouldShowAstriek;

- (void) updateTestScoresWithDetails:(NSOrderedSet *) detailSet withTestScoresAndGrades:(STCTestScoresAndGrades *) testScoresAndGrades forCollege:(STCollege *)college;

@end
