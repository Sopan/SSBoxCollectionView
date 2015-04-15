//
//  SSBoxCollectionViewController.m
//  SSBoxCollectionView
//
//  Created by Sopan Sharma on 4/14/15.
//  Copyright (c) 2015 Sopan Sharma. All rights reserved.
//

#import "SSBoxCollectionViewController.h"
#import "SSBoxCollectionViewCell.h"

#define ITEM_WIDTH 200
#define ITEM_HEIGHT 200

#define PERCENT_MAIN_ITEM 0

#define ITEM_SIZE CGSizeMake(ITEM_WIDTH,ITEM_HEIGHT)
#define ITEM_PADDING 0

@interface SSBoxCollectionViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageList;

@property (strong,nonatomic) SSBoxCollectionViewCell *previousCell;
@property (strong,nonatomic) SSBoxCollectionViewCell *nextCell;

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSUInteger centerItem;
@property (nonatomic, assign) CGPoint oldOffset;

@end

@implementation SSBoxCollectionViewController

- (instancetype)initWithFrame:(CGRect)iFrame data:(NSDictionary *)iDataDictionary {
    self = [super init];
    if (self) {
        self.imageList = [iDataDictionary[@"imageList"] mutableCopy];
        self.cellCount = self.imageList.count;
        self.view.frame = iFrame;
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(handlePanGesture:)];
        self.panGesture.cancelsTouchesInView = NO;
        self.panGesture.delaysTouchesBegan = NO;
        self.panGesture.delaysTouchesEnded = NO;
        self.panGesture.delegate = self;
        self.panGesture.minimumNumberOfTouches = 1;
        self.panGesture.maximumNumberOfTouches = 1;
        [self.view addGestureRecognizer:self.panGesture];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:ITEM_SIZE];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:ITEM_PADDING];
        
        // Config UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ITEM_WIDTH, ITEM_HEIGHT) collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[SSBoxCollectionViewCell class] forCellWithReuseIdentifier:@"ReuseCell"];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView removeGestureRecognizer:self.collectionView.panGestureRecognizer];
        [self.view addSubview:self.collectionView];
        [self setCenterForCollectionView];
        [self.view setClipsToBounds:YES];
        
        self.centerItem = 2;
        [self moveCelltoCenterAminated:NO];
    }
    return self;
}


- (void)setCenterForCollectionView {
    CGPoint theCenter = self.view.center;
    theCenter.y = CGRectGetHeight(self.view.frame) / 2.0;
    theCenter.x = CGRectGetWidth(self.view.frame) / 2.0;
    self.collectionView.center = theCenter;
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)iPanGesture {
    switch (iPanGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self handlePanGestureStateBegan:self.panGesture];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self handlePanGestureStateChanged:self.panGesture];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self handlePanGestureStateEnded:self.panGesture];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            [self handlePanGestureStateEnded:self.panGesture];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self handlePanGestureStateEnded:self.panGesture];
            break;
        }
        case UIGestureRecognizerStatePossible: {
            break;
        }
    }
}


- (void)handlePanGestureStateBegan:(UIPanGestureRecognizer *)iPanGesture {
    self.oldOffset = self.collectionView.contentOffset;
}


- (void)handlePanGestureStateChanged:(UIPanGestureRecognizer *)iPanGesture {
    CGFloat thePadding = (self.collectionView.frame.size.width - ITEM_WIDTH) / 2;
    CGFloat theMaximumContentXOffset = ((self.cellCount - 1) * ITEM_WIDTH) - thePadding;
    CGPoint theTransLation = [iPanGesture translationInView:self.collectionView];
    CGPoint theOffset = CGPointZero;
    theOffset.x = (self.oldOffset.x - theTransLation.x);
    if (theTransLation.x <= 0) {
        if (theOffset.x >= theMaximumContentXOffset) {
            theOffset.x = theMaximumContentXOffset;
            self.centerItem = self.cellCount - 1;
        }
    } else {
        if (theOffset.x <= 0) {
            theOffset.x = 0;
            self.centerItem = 0;
        }
    }
    [self.collectionView setContentOffset:theOffset];
}


- (void)handlePanGestureStateEnded:(UIPanGestureRecognizer *)iPanGesture {
    CGPoint theGestureTranslation = [iPanGesture translationInView:self.collectionView];
    CGPoint theGestureVelocity = [iPanGesture velocityInView:self.collectionView];
    self.previousCell = (SSBoxCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.centerItem inSection:0]];
    if (ABS(theGestureVelocity.x) > 600) {
        if (theGestureTranslation.x > 0) {
            if (self.centerItem > 0) {
                self.centerItem -= 1;
            }
        } else {
            if (self.centerItem < self.cellCount - 1) {
                self.centerItem += 1;
            }
        }
    } else {
        CGFloat thePageReference = self.collectionView.contentOffset.x / (ITEM_WIDTH + (2 * ITEM_PADDING));
        NSUInteger theReferenceValue = (NSInteger)(thePageReference * 100) % 100;
        if (theReferenceValue >= 50) {
            if (theGestureTranslation.x <= 0) {
                self.centerItem = ((thePageReference * 100) / 100 ) + 1;
            } else {
                self.centerItem = ((thePageReference * 100) / 100 );
            }
        } else {
            self.centerItem = ((thePageReference * 100) / 100 );
        }
    }
    if (self.collectionView.contentOffset.x <= 0 || self.centerItem  <= 0) {
        self.centerItem = 0;
    }
    if (self.centerItem >= self.cellCount - 1) {
        self.centerItem = self.cellCount - 1;
    }
    [self moveCelltoCenterAminated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)iCollectionView {
    return 1;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)iCollectionView layout:(UICollectionViewLayout*)iCollectionViewLayout insetForSectionAtIndex:(NSInteger)iSection {
    CGFloat thePadding = (self.collectionView.frame.size.width - ITEM_WIDTH) / 2;
    return UIEdgeInsetsMake(0, thePadding, 0, thePadding);
}


- (NSInteger)collectionView:(UICollectionView *)iCollectionView numberOfItemsInSection:(NSInteger)iSection {
    return self.cellCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)iIndexPath {
    SSBoxCollectionViewCell *cell = (SSBoxCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseCell" forIndexPath:iIndexPath];
    if (iIndexPath.row == self.centerItem) {
        self.previousCell = cell;
    }
    
    [cell setImage:self.imageList[iIndexPath.row]];
    return cell;
}


- (void)moveCelltoCenterAminated:(BOOL)iAnimated {
    CGPoint theNextOffset = CGPointZero;
    SSBoxCollectionViewCell *theCell = (SSBoxCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.centerItem inSection:0]];
    self.nextCell = theCell;
    theNextOffset.x = CGRectGetMinX(theCell.frame) - (CGRectGetWidth(self.collectionView.frame) / 2 - (ITEM_WIDTH / 2));
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.collectionView setContentOffset:theNextOffset animated:iAnimated];
    } completion:^(BOOL finished) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.centerItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:iAnimated];
    }];
}



@end
