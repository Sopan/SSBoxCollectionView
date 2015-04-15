//
//  SSBoxCollectionViewCell.m
//  SSBoxCollectionView
//
//  Created by Sopan Sharma on 4/14/15.
//  Copyright (c) 2015 Sopan Sharma. All rights reserved.
//

#import "SSBoxCollectionViewCell.h"

@implementation SSBoxCollectionViewCell

- (instancetype)initWithFrame:(CGRect)iFrame {
    self =[super initWithFrame:iFrame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iFrame.size.width, iFrame.size.height)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.imageView.alpha = 0;
}


- (void)setImage:(NSString *)iImageName {
    self.imageView.image = [UIImage imageNamed:iImageName];
    self.imageView.alpha = 1.0;
}


@end
