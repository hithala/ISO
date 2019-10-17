//
//  STClippingsCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 27/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STClippingsCell.h"
#import "STCollegeSectionHeaderView.h"

#define ROW_HEIGHT                      60.0

#define ROW_TAG                         101
#define TILE_CLOSE                      @"tile_close"
#define TILE_OPEN                       @"tile_open"

@implementation STClippingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithDetails:(STClippingsItem *)clippingsItem forIndexPath:(NSIndexPath *)indexPath {
    
    self.clippingItem = [clippingsItem.clippingSections objectAtIndex:indexPath.row];
    self.currentIndexPath = indexPath;
    [self updateCellDetails];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateCellDetails];
}

- (void)updateCellDetails {
    
    STCollegeSectionHeaderView *headerView = (STCollegeSectionHeaderView *)[self viewWithTag:ROW_TAG];
    
    if(!headerView) {
        headerView = [[NSBundle mainBundle] loadNibNamed:@"STCollegeSectionHeaderView" owner:self options:nil][0];
        headerView.frame = self.frame;
        headerView.tag = ROW_TAG;
        headerView.backgroundColor = [UIColor clearColor];
    }
    
    //NSNumber *sectionID = sectionItem.sectionID;
    
    BOOL isExpanded = [self.clippingItem.isExpanded boolValue];
    
    headerView.ibSectionHeaderName.text = self.clippingItem.sectionTitle;
    headerView.ibSectionHeaderIcon.image = [UIImage imageNamed:self.clippingItem.imageName];
    
    if(isExpanded) {
        headerView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_CLOSE];
    } else {
        headerView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_OPEN];
    }
    
    headerView.overlayView.hidden = YES;
    
    headerView.clickActionBlock = ^(NSInteger tag){
        if(self.clippingTapActionBlock) {
            self.clippingTapActionBlock(self.currentIndexPath);
        }
    };

    [self.contentView addSubview:headerView];
    
}


@end
