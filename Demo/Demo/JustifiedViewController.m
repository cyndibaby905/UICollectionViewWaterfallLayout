//
//  JustifiedViewController.m
//  Demo
//
//  Created by Hang on 13/03/11.
//  Copyright (c) 2013 Hang Chen. All rights reserved.
//

#import "JustifiedViewController.h"
#import "UICollectionViewWaterfallCell.h"

#define CELL_WIDTH 129
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"JustifiedCell"

@implementation JustifiedViewController

#pragma mark - Accessors
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UIJustifiedCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewJustifiedLayout alloc] init]];
        [(UICollectionViewJustifiedLayout*)_collectionView.collectionViewLayout setDelegate:self];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - UICollectionViewJustifiedLayoutDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewJustifiedLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSUInteger)index {
    return CGSizeMake(arc4random()%100*2+100, arc4random()%100*2+100);
}

- (NSInteger)numberOfCellsInCollectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewJustifiedLayout *)collectionViewLayout {
    return CELL_COUNT;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewJustifiedLayout *)collectionViewLayout cellAtIndex:(NSInteger)index {
    UICollectionViewWaterfallCell *cell =
    (UICollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                               forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    cell.displayString = [NSString stringWithFormat:@"%d", index];
    return cell;
}

@end
