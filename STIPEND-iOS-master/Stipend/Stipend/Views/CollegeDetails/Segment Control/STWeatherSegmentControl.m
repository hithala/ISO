//
//  STWeatherSegmentControl.m
//  Stipend
//
//  Created by Arun S on 26/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STWeatherSegmentControl.h"

#define BASE_TAG                 444
#define BASE_LABEL_TAG          1234
#define BASE_IMAGE_TAG          2234
#define BASE_UNDERLINE_TAG      4567
#define BASE_BUTTON_TAG         7890

@implementation STWeatherSegmentControl

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
        
        NSString *title = [[[itemArray objectAtIndex:i] objectForKey:@"kName"] uppercaseString];
        NSString *imageName = [[itemArray objectAtIndex:i] objectForKey:@"kImageName"];

        CGFloat size = self.bounds.size.width/count;
        
        UIView *itemView = (UIView *)[self viewWithTag:(BASE_TAG + i)];
        
        if(!itemView) {
            itemView = [[UIView alloc] initWithFrame:CGRectMake((i * size), 10.0, size, self.frame.size.height)];
            [itemView setTag:(BASE_TAG + i)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((itemView.bounds.size.width/2.0) - 5.0), 20.0, 20.0, 20.0)];
            [imageView setTag:(BASE_IMAGE_TAG + i)];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:[UIImage imageNamed:imageName]];
            [itemView addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, ((itemView.bounds.size.height/2.0) + 10.0), (itemView.bounds.size.width), 30.0)];
            [titleLabel setText:title];
            [titleLabel setTag:(BASE_LABEL_TAG + i)];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setFont:[UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0]];
            [titleLabel setTextColor:[UIColor cellLabelTextColor]];
            [itemView addSubview:titleLabel];
            
            UIView *underlineView = [[UIView alloc] initWithFrame:CGRectMake(10.0, (itemView.frame.size.height - 2.0), (itemView.bounds.size.width - 20.0), 2.0)];
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
                underlineView.hidden = YES;
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

            UIImageView *imageView = (UIImageView *)[self viewWithTag:(BASE_IMAGE_TAG + i)];

            if(imageView) {
                imageView.frame = CGRectMake(((itemView.bounds.size.width/2.0) - 5.0), 15.0, 20.0, 20.0);
            }
            
            UILabel *titleLabel = (UILabel *)[self viewWithTag:(BASE_LABEL_TAG + i)];
            
            if(titleLabel) {
                titleLabel.frame = CGRectMake(5.0, ((itemView.bounds.size.height/2.0) + 5.0), (itemView.bounds.size.width), 30.0);
            }
            
            UIView *underlineView = (UIView *)[self viewWithTag:(BASE_UNDERLINE_TAG + i)];
            
            if(underlineView) {
                underlineView.frame = CGRectMake(10.0, (itemView.frame.size.height - 2.0), (itemView.bounds.size.width - 10.0), 2.0);
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
                underlineView.hidden = YES;
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

- (void)dealloc {
    
    self.items = nil;
    self.delegate = nil;
}

@end
