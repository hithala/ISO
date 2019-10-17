//
//  STGetDirectionPopupView.m
//  Stipend
//
//  Created by Ganesh Kumar on 21/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STGetDirectionPopupView.h"
#import "STMapAppCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define checkbox_normal   @"checkbox_normal"
#define checkbox_active   @"checkbox_active"

@interface STGetDirectionPopupView ()

@end

@implementation STGetDirectionPopupView
@synthesize cancelActionBlock;
@synthesize mapAppsList;


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (IBAction)appSelectionTickBtn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if(button.selected == NO) {
        [button setSelected:YES];
        [button setImage:[UIImage imageNamed:checkbox_active] forState:UIControlStateNormal];
    } else {
        [button setSelected:NO];
        [button setImage:[UIImage imageNamed:checkbox_normal] forState:UIControlStateNormal];
    }
}


- (IBAction)closePopup:(id)sender {
   self.cancelActionBlock();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mapAppsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"mapAppCell";
    
    STMapAppCell *cell = (STMapAppCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = (STMapAppCell *)[[NSBundle mainBundle] loadNibNamed:@"STMapAppCell" owner:self options:nil][0];
    }
    
    NSDictionary *appDict= [mapAppsList objectAtIndex:indexPath.row];
    cell.appName.text = [appDict objectForKey:@"appName"];
    cell.appIcon.image = [UIImage imageNamed:[appDict objectForKey:@"appIcon"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *appDict= [mapAppsList objectAtIndex:indexPath.row];
    
    if(self.completeActionBlock) {
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        [details setObject:[appDict objectForKey:@"appType"] forKey:@"kMapType"];
        [details setObject:[NSNumber numberWithBool:[self.appSelectionTick state]] forKey:@"kShouldAlwaysOpen"];
        
        if(self.completeActionBlock) {
            self.completeActionBlock(details);
        }
    }
    
    self.cancelActionBlock();
}



@end
