//
//  STImportantDateView.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STImportantDateView.h"

#define LEADING_SPACE_CONSTANT                          20.0f
#define TOP_SPACE_CONSTANT                              20.0f
#define CALENDER_VIEW_WIDTH_CONSTANT                    80.0f
#define CALENDER_VIEW_HEIGHT_CONSTANT                   80.0f
#define IMPORTANT_DETAILS_VIEW_TAG_CONSTANT             2000
#define CONTENT_LABEL_TAG_CONSTANT                      3000

#define CONTENT_LABEL_HEIGHT                            52.0

#define KEY_EXPAND                      @"kExpandKey"
#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ISACTIVE                    @"kIsActiveKey"
#define KEY_COLORS_VALUES_ARRAY         @"kColorValuesArrayKey"
#define KEY_VALUES_LIST_ARRAY           @"kListValuesArrayKey"

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_VALUES_DICT                 @"kValuesDictKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

#define SCREEN_X_OFFSET                 10.0

@interface STImportantDateView ()
@end

@implementation STImportantDateView

- (IBAction)onCalenderButtonAction:(id)sender {
    
    if(self.addEventActionBlock) {
        self.addEventActionBlock(self.tag);
    }
}

- (void)dealloc {
    
    self.addEventActionBlock = nil;
}

@end
