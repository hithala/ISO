//
//  STSportsDetailsCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define SPORTS_DIVISION_TITLEVIEW                    1000
#define SPORTS_LIST_VIEW_TAG                         1100
#define SPORTS_LIST_SUBVIEW_TAG                      1200
#define SPORTS_TOGGLE_STATE_TAG                      4576
#define SPORTS_SEPARATOR_TAG                         5000


#define SPORTS_DIVISION_TITLEVIEW_HEIGHT             60.0
#define SPORTS_LISTVIEW_ROW_HEIGHT                   50.0


#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_SELECTED_INDEX              @"kSelectedIndexKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

#import "STSportsDetailsCell.h"
#import "STSportsDivisionTitleView.h"
#import "STSportsListView.h"


@implementation STSportsDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedIndex = -1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateSportsSectionDetails];
}

- (void) updateSportsSectionWithDetails:(STCSports *) sportsDetails {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.sports = sportsDetails;
    [self updateSportsSectionDetails];
    [self setNeedsDisplay];
}

- (NSOrderedSet *) getOrderedSetForSportsObjectAtIndex:(NSInteger) index {
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    
    if(self.sports.menSports.sportsDivisions.count) {
        [orderedSet addObject:self.sports.menSports.sportsDivisions];
    }
    
    if(self.sports.womenSports.sportsDivisions.count) {
        [orderedSet addObject:self.sports.womenSports.sportsDivisions];
    }
    
    if(orderedSet.count > 0) {
        return [orderedSet objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void)updateSportsSectionDetails {//kLabelKey
    
    NSOrderedSet *sportsSet;

    if([self.sports.sportsSelectedIndex integerValue] != -1) {
        sportsSet = [self getOrderedSetForSportsObjectAtIndex:[self.sports.sportsSelectedIndex integerValue]];
        self.selectedIndex = [self.sports.sportsSelectedIndex integerValue];
    }

    CGFloat originYValue = 0.0f;
    
    STCollegeSegmentControl *segmentControl = (STCollegeSegmentControl *)[self viewWithTag:(SPORTS_TOGGLE_STATE_TAG)];
    
    if(!segmentControl) {
        segmentControl = [[STCollegeSegmentControl alloc] initWithFrame:CGRectZero];
        segmentControl.delegate = self;
        segmentControl.tag = SPORTS_TOGGLE_STATE_TAG;
        [self.contentView addSubview:segmentControl];
    }
    
    segmentControl.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 60.0);
    NSArray *items = [self getItemsFromSportsList];
    [segmentControl setSelectedIndex:self.selectedIndex];
    [segmentControl updateSegmentControlWithItems:items];
    
    for(NSInteger index = 0 ; index < [sportsSet count] ; index++) {
        
        STCSportsDivision *sportsDivision = [sportsSet objectAtIndex:index];
    
        CGRect listViewFrame = CGRectZero;

        STSportsDivisionTitleView *titleView = (STSportsDivisionTitleView *)[self viewWithTag:SPORTS_DIVISION_TITLEVIEW + index];

        if (!titleView) {
            titleView =  (STSportsDivisionTitleView *)[[NSBundle mainBundle] loadNibNamed:@"STSportsDivisionTitleView" owner:self options:nil][0];
            titleView.tag = SPORTS_DIVISION_TITLEVIEW + index;
            titleView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:titleView];
        }

        titleView.frame = CGRectMake(0, (60.0 + originYValue) , CGRectGetWidth(self.bounds),SPORTS_DIVISION_TITLEVIEW_HEIGHT);
        titleView.titleLabel.text = sportsDivision.title;

        NSOrderedSet *sportsList = sportsDivision.sportsItems;

        for (int subIndex = 0; subIndex < [sportsList count]; subIndex++) {
            STSportsListView *listView = (STSportsListView *)[self viewWithTag:(SPORTS_LIST_VIEW_TAG + ((subIndex + 1) * SPORTS_LIST_SUBVIEW_TAG) + index)];

            if (!listView) {
                listView =  (STSportsListView *)[[NSBundle mainBundle] loadNibNamed:@"STSportsListView" owner:self options:nil][0];
                listView.tag = (SPORTS_LIST_VIEW_TAG + ((subIndex + 1) * SPORTS_LIST_SUBVIEW_TAG) + index);
                listView.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:listView];
            }

            
            STCSportsItem *item = [sportsList objectAtIndex:subIndex];
            listView.ibLeftLabel.text = item.name;
            
            if((subIndex % 2) == 0) {
                listViewFrame.origin.x = 0.0;
                listViewFrame.origin.y = ((subIndex/2) * SPORTS_LISTVIEW_ROW_HEIGHT) + (titleView.frame.origin.y + titleView.frame.size.height) ;
                listViewFrame.size.width = ([self bounds].size.width/2.0);
                listViewFrame.size.height = SPORTS_LISTVIEW_ROW_HEIGHT;
                
                if((subIndex == (sportsList.count-1)) || (subIndex == (sportsList.count-2))) {
                    listView.ibLeftCellSeparatorView.hidden = YES;
                } else {
                    listView.ibLeftCellSeparatorView.hidden = NO;
                }
            }
            else {
                listViewFrame.origin.x = ([self bounds].size.width/2.0);
                listViewFrame.origin.y = ((subIndex/2) * SPORTS_LISTVIEW_ROW_HEIGHT) + (titleView.frame.origin.y + titleView.frame.size.height);
                listViewFrame.size.width = ([self bounds].size.width/2.0);
                listViewFrame.size.height = SPORTS_LISTVIEW_ROW_HEIGHT;
                
                if(subIndex == (sportsList.count-1)) {
                    listView.ibLeftCellSeparatorView.hidden = YES;
                } else {
                    listView.ibLeftCellSeparatorView.hidden = NO;
                }
            }

            listView.frame = listViewFrame;
            
        }

        CGFloat height = (ceilf((sportsList.count/2.0)) * SPORTS_LISTVIEW_ROW_HEIGHT);
        originYValue +=  (SPORTS_DIVISION_TITLEVIEW_HEIGHT * (index + 1)) + height;
        
        UIView *separatorView = [self viewWithTag:(SPORTS_SEPARATOR_TAG)];
        
        if(!separatorView) {
            
            CGFloat originY = 0.0;
            
            if(index == 0) {
                originY = (originYValue + 60.0);
            } else {
                originY = originYValue;
            }
        
            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.frame.size.width, 0.5)];
            separatorView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.12];
            [self.contentView addSubview:separatorView];
        }
        else {
            CGFloat originY = 0.0;
            
            if(index == 0) {
                originY = (originYValue + 60.0);
            } else {
                originY = originYValue;
            }
            
            separatorView.frame = CGRectMake(0, originY, self.frame.size.width, 0.5);
        }
    }
}

- (NSMutableArray *) getItemsFromSportsList {

    NSMutableArray *valueArray = [NSMutableArray array];

    if(self.sports.menSports.sportsDivisions.count > 0) {
        [valueArray addObject:@"MEN"];
    }
    
    if(self.sports.womenSports.sportsDivisions.count > 0) {
        [valueArray addObject:@"WOMEN"];
    }
    
    return valueArray;
}

- (void) didClickSegmentAtIndex:(NSUInteger) index {

    if(index != self.selectedIndex) {
        
        self.sports.sportsSelectedIndex = [NSNumber numberWithInteger:index];
        self.selectedIndex = index;

        if(self.toggleAction) {
            self.toggleAction();
        }
    }
}

- (void)dealloc {
    self.sports = nil;
}

@end
