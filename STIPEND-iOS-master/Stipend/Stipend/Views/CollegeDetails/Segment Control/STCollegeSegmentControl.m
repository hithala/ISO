//
//  STCollegeSegmentControl.m
//  Stipend
//
//  Created by Arun S on 29/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeSegmentControl.h"
#import "STFinancialDetailsCell.h"

#define BASE_TAG                 444
#define BASE_LABEL_TAG          1234
#define BASE_UNDERLINE_TAG      4567
#define BASE_BUTTON_TAG         7890

@implementation STCollegeSegmentControl

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.selectedIndex = -1;
        
    }
    return self;
}

- (void) updateSegmentControlWithItems:(NSArray *) itemArray {
    
    self.items = itemArray;
    NSInteger count = [itemArray count];
    
    for (NSInteger i = 0; i < count; i++) {
     
        CGFloat size = self.bounds.size.width/count;
        
        UIView *itemView = (UIView *)[self viewWithTag:(BASE_TAG + i)];
        
        if(!itemView) {
            itemView = [[UIView alloc] initWithFrame:CGRectMake((i * size), 0.0, size, self.frame.size.height)];
            [itemView setTag:(BASE_TAG + i)];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, (itemView.bounds.size.width), 30.0)];
            [titleLabel setText:[[itemArray objectAtIndex:i] uppercaseString]];
            [titleLabel setTag:(BASE_LABEL_TAG + i)];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setFont:[UIFont fontType:eFontTypeAvenirHeavy FontForSize:14.0]];
            [titleLabel setTextColor:[UIColor cellLabelTextColor]];
            [itemView addSubview:titleLabel];

            UIView *underlineView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 40.0, (itemView.bounds.size.width), 2.0)];
            [underlineView setBackgroundColor:[UIColor cellLabelTextColor]];
            [underlineView setTag:(BASE_UNDERLINE_TAG + i)];
            [itemView addSubview:underlineView];
            
            if(count > 1) {
                if(self.selectedIndex == i) {
                    underlineView.hidden = NO;
                    [titleLabel setTextColor:[UIColor cellTextFieldTextColor]];
                }
                else {
                    underlineView.hidden = YES;
                    [titleLabel setTextColor:[UIColor cellLabelTextColor]];
                }
            }
            else {
                [titleLabel setTextColor:[UIColor cellTextFieldTextColor]];
                underlineView.hidden = NO;
                
                underlineView.frame = CGRectMake(5.0, 40.0, itemView.bounds.size.width/2, 2.0);
                underlineView.center = CGPointMake(itemView.center.x, 40.0);
            }
            
            UIButton *overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, itemView.frame.size.width, itemView.frame.size.height)];
            [overlayButton setTitle:@"" forState:UIControlStateNormal];
            [overlayButton setTag:(BASE_BUTTON_TAG + i)];
            [overlayButton addTarget:self action:@selector(onToggleAction:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:overlayButton];
            
            [self addSubview:itemView];
        }
        else {
            
            itemView.frame = CGRectMake((i * size), 0.0, size, self.frame.size.height);
            
            UILabel *titleLabel = (UILabel *)[self viewWithTag:(BASE_LABEL_TAG + i)];
            
            if(titleLabel) {
                titleLabel.frame = CGRectMake(5.0, 5.0, (itemView.bounds.size.width - 10.0), 30.0);
            }
            
            UIView *underlineView = (UIView *)[self viewWithTag:(BASE_UNDERLINE_TAG + i)];
            
            if(underlineView) {
                underlineView.frame = CGRectMake(5.0, 40.0, (itemView.bounds.size.width - 10.0), 2.0);

                if(count == 1) {
                    underlineView.frame = CGRectMake(5.0, 40.0, itemView.bounds.size.width/2, 2.0);
                    underlineView.center = CGPointMake(itemView.center.x, 40.0);
                }
            }
            
            if(count > 1) {
                
                if(self.selectedIndex == i) {
                    underlineView.hidden = NO;
                    [titleLabel setTextColor:[UIColor cellTextFieldTextColor]];
                }
                else {
                    underlineView.hidden = YES;
                    [titleLabel setTextColor:[UIColor cellLabelTextColor]];
                }
            }
            else {
                [titleLabel setTextColor:[UIColor cellTextFieldTextColor]];
                underlineView.hidden = NO;
            }
            
            UIButton *overlayButton = (UIButton *)[self viewWithTag:(BASE_BUTTON_TAG + i)];
            
            if(overlayButton) {
                overlayButton.frame = CGRectMake(0.0, 0.0, itemView.frame.size.width, itemView.frame.size.height);
            }
        }
    }
}

- (void) onToggleAction:(id) sender {
    
    NSInteger index = [sender tag] - BASE_BUTTON_TAG;

    if([self.delegate respondsToSelector:@selector(didClickSegmentAtIndex:)]) {
        [self.delegate didClickSegmentAtIndex:index];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)dealloc
{
    self.items = nil;
    self.delegate = nil;
}

@end
