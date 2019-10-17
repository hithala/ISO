//
//  STImportantDateView.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STImportantDateView.h"
#import "STImportantDateDetailView.h"

#define LEADING_SPACE_CONSTANT                          20.0f
#define TOP_SPACE_CONSTANT                              20.0f
#define CALENDER_VIEW_WIDTH_CONSTANT                    80.0f
#define CALENDER_VIEW_HEIGHT_CONSTANT                   80.0f
#define IMPORTANT_DETAILS_VIEW_TAG_CONSTANT             1000.0f

@implementation STImportantDateView

@synthesize didDateAddedActionBlock;

- (void)loadViews {
    CGFloat spaceConstant = (self.frame.size.width - (3 * CALENDER_VIEW_WIDTH_CONSTANT)) / 4 ;
    CGFloat consant = spaceConstant;
    
    for (int index = 0; index < 3; index++) {
        
        STImportantDateDetailView *detailsView = [[STImportantDateDetailView alloc] initWithFrame:CGRectMake(consant, TOP_SPACE_CONSTANT, CALENDER_VIEW_WIDTH_CONSTANT, CALENDER_VIEW_HEIGHT_CONSTANT)];
        [self addSubview:detailsView];
        
        #warning Mahesh : Label frame and alignment issue in iPhone 5 series.
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailsView.frame.origin.x - 20.0, detailsView.frame.origin.y + detailsView.frame.size.height + 10.0, CGRectGetWidth(detailsView.frame) + spaceConstant + 10.0, 72.0)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = @"Early Decision Deadline Early Decision making early";
        contentLabel.numberOfLines = 0 ;
        contentLabel.adjustsFontSizeToFitWidth = YES;
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:contentLabel];

        consant  =  detailsView.frame.origin.x + detailsView.frame.size.width + spaceConstant;
    }
}

/*- (UIView *)initializeView:(CGFloat)spaceConstant withWidthConstant:(CGFloat)widthConstant withHeightConstant:(CGFloat)heightConstant{
    
    
    
    UIView *calenderView = [[UIView alloc] init];
    calenderView.frame = CGRectMake(spaceConstant, TOP_SPACE_CONSTANT, widthConstant, heightConstant);
    [self addSubview:calenderView];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(calenderView.frame), CGRectGetHeight(calenderView.frame) - 44.0)];
    dayLabel.backgroundColor = [UIColor whiteColor];
    dayLabel.text = @"1";
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [calenderView addSubview:dayLabel];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dayLabel.frame.origin.y + dayLabel.frame.size.height, CGRectGetWidth(calenderView.frame), CGRectGetHeight(calenderView.frame) - CGRectGetHeight(dayLabel.frame))];
    monthLabel.backgroundColor = [UIColor redColor];
    monthLabel.text = @"JUNE";
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [calenderView addSubview:monthLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:calenderView.bounds];
    [button addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [calenderView addSubview:button];

    return calenderView;
}

- (void)onButtonAction:(UIButton *)sender{
   // didDateAddedActionBlock();
}*/

//CGSize constrainedSize = CGSizeMake(CGRectGetWidth(view.frame) + spaceConstant + 10.0 , CGFLOAT_MAX);
//
//NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [UIFont systemFontOfSize:14.0], NSFontAttributeName,
//                                      nil];
//
//NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Early Decision Deadline Early Decision" attributes:attributesDictionary];
//
//CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//
//if (requiredHeight.size.width > contentLabel.bounds.size.width) {
//    requiredHeight = CGRectMake(0,0, contentLabel.frame.size.width, requiredHeight.size.height);
//}
//CGRect newFrame = contentLabel.bounds;
//newFrame.size.height = requiredHeight.size.height;
//contentLabel.bounds = newFrame;

//UIView *view = [self initializeView:consant withWidthConstant:CALENDER_VIEW_WIDTH_CONSTANT withHeightConstant:CALENDER_VIEW_HEIGHT_CONSTANT];


@end
