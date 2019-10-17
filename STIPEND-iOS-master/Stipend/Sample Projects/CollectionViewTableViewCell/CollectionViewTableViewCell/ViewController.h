//
//  ViewController.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 26/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *ibCollectionView;

@end

