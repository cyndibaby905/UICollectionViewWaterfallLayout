//
//  ViewController.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewWaterfallLayout.h"

@interface ViewController : UIViewController <UICollecitonViewWaterfallLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
