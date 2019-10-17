//
//  STCollegePageReorderViewController.m
//  Stipend
//
//  Created by Mahesh A on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegePageReorderViewController.h"
#import "STReorderCell.h"

#define ICON            @"typeIcon"
#define NAME            @"typeName"

#define ROW_HEIGHT      60.0

@interface STCollegePageReorderViewController () {
}

@end


@implementation STCollegePageReorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Organize College Page";
    
//    self.editing = YES;
    [self.tableView setEditing:YES];
    
    if(self.localContext == nil) {
        self.localContext = [NSManagedObjectContext MR_context];
    }
    
    [self getAllCollegeSections];
    
    if(self.isPresenting) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction:)];
    }
}

- (void) getAllCollegeSections {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];

    self.collegeSections = [[localUser sections] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonAction:(id)sender {
    
    
    __block STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
    
    localUser.sections = self.collegeSections;


    [self.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        
        if(contextDidSave) {
            
            NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
            
            for(int i = 0; i < localUser.sections.count; i++) {
                
                STSections *sectionDetails = [localUser.sections objectAtIndex:i];
                
                NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
                NSNumber *sectionID = [NSNumber numberWithInt:i+1];
                
                [properties setObject:sectionTitle forKey:[NSString stringWithFormat:@"position %@", sectionID]];
            }
            

        }
        
        if(self.isPresenting) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];    
}


- (IBAction)cancelButtonAction:(id)sender {
    
    if(self.isPresenting) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.collegeSections.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STReorderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reorderCell" forIndexPath:indexPath];
    
    STSections *sectionDict = [self.collegeSections objectAtIndex:indexPath.row];
    cell.cellIcon.image = [UIImage imageNamed:sectionDict.sectionItem.imageName];
    
    NSString *sectionName = sectionDict.sectionItem.sectionTitle;
    
    if([sectionName isEqualToString:@"Freshman Profile"]) {
        sectionName = @"Freshmen Profile";
    }
    
    if([sectionName isEqualToString:@"Intended Study"]){
        sectionName = @"Popular Majors";
    }
    
    cell.cellName.text = sectionName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    STSections *dictToMove = self.collegeSections[fromIndexPath.row];
    [self.collegeSections removeObjectAtIndex:fromIndexPath.row];
    [self.collegeSections insertObject:dictToMove atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

#pragma mark - Dealloc Method
- (void)dealloc {
    
    STLog(@"Dealloc Called");
    self.cancelActionBlock = nil;
    self.doneActionBlock = nil;
    self.localContext = nil;
}

@end
