//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewWaterfallLayout;
@protocol UICollecitonViewWaterfallLayoutDelegate <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSUInteger)index;

- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout;

- (NSInteger)numberOfCellsInCollectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewWaterfallLayout *)collectionViewLayout;


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout cellAtIndex:(NSInteger)index;
@end

@interface UICollectionViewWaterfallLayout : UICollectionViewLayout<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id<UICollecitonViewWaterfallLayoutDelegate> delegate;
@property (nonatomic, assign) CGSize paddingSize;
@end


@interface UIWaterFallCollectionView : UICollectionView {
    CGFloat widthEdge_;
}

@end