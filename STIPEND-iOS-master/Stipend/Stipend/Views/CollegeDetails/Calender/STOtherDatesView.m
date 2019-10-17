//
//  STOtherDatesView.m
//  SwitchDemo
//
//  Created by mahesh on 18/06/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import "STOtherDatesView.h"

#define KEY_EXPAND                                     @"kExpandKey"
#define KEY_VALUES_ARRAY                               @"kValuesArrayKey"
#define KEY_VALID                                      @"kValidKey"
#define KEY_ISACTIVE                                   @"kIsActiveKey"
#define KEY_COLORS_VALUES_ARRAY                        @"kColorValuesArrayKey"
#define KEY_VALUES_LIST_ARRAY                          @"kListValuesArrayKey"

#define KEY_LABEL                                      @"kLabelKey"
#define KEY_VALUE                                      @"kValueKey"
#define KEY_EXPAND                                     @"kExpandKey"

#define KEY_VALUES_DICT                                @"kValuesDictKey"
#define KEY_VALID                                      @"kValidKey"
#define KEY_ICON                                       @"kIconKey"
#define KEY_ICON_TYPE                                  @"kIconTypeKey"

#define CALENDER_VIEW_ADDEVENT_BUTTON_TAG_CONSTANT     3100

@interface STOtherDatesView ()

@end

@implementation STOtherDatesView

- (IBAction)onCalenderButtonAction:(id)sender{
    
    if(self.addEventActionBlock) {
        self.addEventActionBlock(self.tag);
    }
}

- (void)dealloc {
    
    self.addEventActionBlock = nil;
}

@end
