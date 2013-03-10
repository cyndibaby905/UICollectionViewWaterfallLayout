//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewWaterfallCell.h"

#define CELL_WIDTH 129
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"

@implementation ViewController

#pragma mark - Accessors
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
        layout.columnPadding = 5.f;
        layout.cellPadding = 5.f;
        layout.delegate = self;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = layout;
        _collectionView.delegate = layout;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[UICollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Life Cycle
- (void)dealloc
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    [self.collectionView reloadData];
}



#pragma mark - UICollectionViewWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSUInteger)index {
    return arc4random()%100*2+100;
}

- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewWaterfallLayout *)collectionViewLayout {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 4;
    }
    else {
        return 2;
    }

}

- (NSInteger)numberOfCellsInCollectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewWaterfallLayout *)collectionViewLayout {
    return CELL_COUNT;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout cellAtIndex:(NSInteger)index {
    UICollectionViewWaterfallCell *cell =
    (UICollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                               forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    cell.displayString = [NSString stringWithFormat:@"%d", index];
    return cell;
}

@end
