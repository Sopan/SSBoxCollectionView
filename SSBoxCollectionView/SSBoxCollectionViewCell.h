//
//  SSBoxCollectionViewCell.h
//  SSBoxCollectionView
//
//  Created by Sopan Sharma on 4/14/15.
//  Copyright (c) 2015 Sopan Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSBoxCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

- (void)setImage:(NSString *)iImageName;


@end
