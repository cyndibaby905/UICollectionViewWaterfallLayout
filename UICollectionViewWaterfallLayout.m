//
//  UICollectionViewWaterfallLayout.m
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import "UICollectionViewWaterfallLayout.h"

@interface UICollectionViewWaterfallLayout()
@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@end

@implementation UICollectionViewWaterfallLayout

- (void)setColumnPadding:(CGFloat)columnPadding
{
    if (columnPadding != _columnPadding) {
        _columnPadding = columnPadding;
        [self invalidateLayout];
    }
}

- (void)setCellPadding:(CGFloat)cellPadding
{
    if (cellPadding != _cellPadding) {
        _cellPadding = cellPadding;
        [self invalidateLayout];
    }
}


#pragma mark - Init
- (void)commonInit
{
    self.columnPadding = 5.f;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Life cycle
- (void)dealloc
{
    [_columnHeights removeAllObjects];
    _columnHeights = nil;

    [_itemAttributes removeAllObjects];
    _itemAttributes = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];

    NSInteger numberOfCells = [self.delegate numberOfCellsInCollectionView:self.collectionView layout:self];
    NSInteger numberOfColumns = [self.delegate numberOfColumnsInCollectionView:self.collectionView layout:self];
    
    CGFloat columnWidth = (self.collectionView.bounds.size.width - (numberOfColumns + 1) * self.columnPadding) / numberOfColumns;
    
    
   

    _itemAttributes = [NSMutableArray arrayWithCapacity:numberOfCells];
    _columnHeights = [NSMutableArray arrayWithCapacity:numberOfColumns];
    
    
    
    for (NSInteger idx = 0; idx < numberOfColumns; idx++) {
        [_columnHeights addObject:@(self.cellPadding)];
    }

    // Item will be put into shortest column.
    for (NSInteger idx = 0; idx < numberOfCells; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                    layout:self
                                  heightForItemAtIndexPath:idx];
        
        
        
        NSUInteger columnIndex = [self shortestColumnIndex];
        CGFloat xOffset = self.columnPadding + (columnWidth + self.columnPadding) * columnIndex;
        CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];
        CGPoint itemCenter = CGPointMake(floorf(xOffset + columnWidth/2), floorf((yOffset + itemHeight/2)));

        UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.size = CGSizeMake(columnWidth, itemHeight);
        attributes.center = itemCenter;
        [_itemAttributes addObject:attributes];
        
        _columnHeights[columnIndex] = @(yOffset + itemHeight + self.cellPadding);
    }
}

- (CGSize)collectionViewContentSize
{
    if (![self.delegate numberOfCellsInCollectionView:self.collectionView layout:self]) {
        return CGSizeZero;
    }

    CGSize contentSize = self.collectionView.frame.size;
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat height = [self.columnHeights[columnIndex] floatValue];
    contentSize.height = height;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    return (self.itemAttributes)[path.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
//    // Currently, PSTCollectionView has issue with this.
//    // It can't display items correctly.
//    // But UICollectionView works perfectly.
//    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
//    }]];
    return self.itemAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark - Private Methods
// Find out shortest column.
- (NSUInteger)shortestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;

    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];

    return index;
}

// Find out longest column.
- (NSUInteger)longestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;

    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];

    return index;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfCellsInCollectionView:collectionView layout:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.delegate collectionView:collectionView layout:self cellAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end

@implementation UIWaterFallCollectionView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (ABS(self.bounds.size.width - widthEdge_) > 0.1f) {
        widthEdge_ = self.bounds.size.width;
        [self reloadData];
    }
}

@end
