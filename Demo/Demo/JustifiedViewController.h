//
//  JustifiedViewController.h
//  Demo
//
//  Created by Hang on 13/03/11.
//  Copyright (c) 2013 Hang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewJustifiedLayout.h"

@interface JustifiedViewController : UIViewController <UICollectionViewJustifiedLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
