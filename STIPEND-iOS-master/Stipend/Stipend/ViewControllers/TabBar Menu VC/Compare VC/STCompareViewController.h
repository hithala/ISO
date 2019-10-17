//
//  STCompareViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CompareViewControllerDelegate <NSObject>

@optional
- (void)showMenu;
- (void)capturedImage:(UIImage *)image;

@end

@interface STCompareViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *compareCollectionView;
@property (nonatomic, weak) IBOutlet UIView                       *emptyView;

@property (nonatomic,retain) NSMutableOrderedSet               *compareItems;
@property (nonatomic,retain) NSMutableArray             *sectionDetailsArray;

@property (nonatomic,retain) NSManagedObjectContext            *localContext;

@property (nonatomic,assign) NSInteger                  selectedSectionIndex;

@property (nonatomic, assign) id<CompareViewControllerDelegate>     delegate;

@property (nonatomic,assign) UIInterfaceOrientation       currentOrientation;

@end