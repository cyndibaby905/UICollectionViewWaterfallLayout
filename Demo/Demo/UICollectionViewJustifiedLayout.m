//
//  UICollectionViewJustifiedLayout.m
//  Demo
//
//  Created by Hang Chen on 3/11/13.
//  Copyright (c) 2013 Hang Chen. All rights reserved.
//

#import "UICollectionViewJustifiedLayout.h"

#define CELL_MAX_HEIGHT 150.f

@interface UICollectionViewJustifiedLayout()
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@end

@implementation UICollectionViewJustifiedLayout

- (void)setPaddingSize:(CGSize)paddingSize {
    if (!CGSizeEqualToSize(paddingSize, _paddingSize)) {
        _paddingSize = paddingSize;
        [self invalidateLayout];
    }
}


#pragma mark - Init
- (void)commonInit
{
    self.paddingSize = CGSizeMake(5.f, 5.f);
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
    [_itemAttributes removeAllObjects];
    _itemAttributes = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger numberOfCells = [self.delegate numberOfCellsInCollectionView:self.collectionView layout:self];
     _itemAttributes = [NSMutableArray arrayWithCapacity:numberOfCells];
   
    
    
    CGFloat lastCellRightX = self.paddingSize.width;
    CGFloat rowBottomY = 0;
    CGFloat rowTopY = self.paddingSize.height;
    
    CGFloat rowFirstIndex = 0;
    CGFloat rowLastIndex = 0;
    for (int i = 0; i < numberOfCells; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize size = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:i];
        
        
     
        
        float ratio = size.width/size.height;
        
        
        CGSize actualSize = CGSizeMake(CELL_MAX_HEIGHT*ratio, CELL_MAX_HEIGHT);
        
        if (actualSize.width >= self.collectionView.bounds.size.width - lastCellRightX - self.paddingSize.width) {
            actualSize.width = self.collectionView.bounds.size.width - lastCellRightX - self.paddingSize.width;
            actualSize.height = actualSize.width/ratio;
            rowLastIndex = i;
        }
        
        if (ABS(lastCellRightX - self.paddingSize.width) < 0.1f) {
            rowBottomY = actualSize.height;
            rowFirstIndex = i;
        }
        
        UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(lastCellRightX, rowTopY, actualSize.width, actualSize.height);
        
        [_itemAttributes addObject:attributes];
        
        
        lastCellRightX+= (actualSize.width + self.paddingSize.width);
        if (lastCellRightX >= self.collectionView.bounds.size.width) {
            
            //We need to adjust the height of the whole row, otherwise the last cell may be shorter.
            if (rowLastIndex > rowFirstIndex) {
                CGFloat ratios = 0.f;
                for (NSInteger jj = rowFirstIndex; jj <= rowLastIndex; jj++) {
                    UICollectionViewLayoutAttributes *info = [_itemAttributes objectAtIndex:jj];
                    ratios += (info.frame.size.width / info.frame.size.height);
                    
                }
                //Calculate the row height depends on each cell's ratio
                rowBottomY = (self.collectionView.bounds.size.width - ((rowLastIndex - rowFirstIndex + 2) * self.paddingSize.width))/ratios;
                
                lastCellRightX = self.paddingSize.width;
                for (NSInteger jj = rowFirstIndex; jj <= rowLastIndex; jj++) {
                    UICollectionViewLayoutAttributes *info = [_itemAttributes objectAtIndex:jj];
                    CGRect cellFrame = info.frame;
                    cellFrame.origin.x = lastCellRightX;
                    cellFrame.size.height = rowBottomY;
                    cellFrame.size.width = rowBottomY * (info.frame.size.width / info.frame.size.height);
                    info.frame = cellFrame;
                    lastCellRightX += self.paddingSize.width + cellFrame.size.width;
                }
            }
            lastCellRightX = self.paddingSize.width;
            if (i != numberOfCells - 1) {//We need to start a new line.
                rowTopY += rowBottomY + self.paddingSize.height;
            }
            else {//We reached the last item, do not need to start a new line.
                
            }
        }
        
    }

}

- (CGSize)collectionViewContentSize
{
    if (![self.delegate numberOfCellsInCollectionView:self.collectionView layout:self]) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.frame.size;
    UICollectionViewLayoutAttributes *lastCellAttributes = [_itemAttributes lastObject];
    CGFloat height = lastCellAttributes.frame.size.height + lastCellAttributes.frame.origin.y + self.paddingSize.height;
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

@implementation UIJustifiedCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        if ([layout isKindOfClass:[UICollectionViewJustifiedLayout class]]) {
            UICollectionViewJustifiedLayout * tempLayout = (UICollectionViewJustifiedLayout*)layout;
            tempLayout.paddingSize = CGSizeMake(5.f, 5.f);
            self.delegate = tempLayout;
            self.dataSource = tempLayout;
        }
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (ABS(self.bounds.size.width - widthEdge_) > 0.1f) {
        widthEdge_ = self.bounds.size.width;
        [self reloadData];
    }
}

@end