//
//  UICollectionViewJustifiedLayout.h
//  Demo
//
//  Created by Hang Chen on 3/11/13.
//  Copyright (c) 2013 Hang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewJustifiedLayout;
@protocol UICollectionViewJustifiedLayoutDelegate <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewJustifiedLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSUInteger)index;

- (NSInteger)numberOfCellsInCollectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewJustifiedLayout *)collectionViewLayout;


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewJustifiedLayout *)collectionViewLayout cellAtIndex:(NSInteger)index;
@end

@interface UICollectionViewJustifiedLayout : UICollectionViewLayout<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id<UICollectionViewJustifiedLayoutDelegate> delegate;

@property (nonatomic, assign) CGSize paddingSize;
@end


@interface UIJustifiedCollectionView : UICollectionView {
    CGFloat widthEdge_;
}

@end