//
//  SSViewController.m
//  SSBoxCollectionView
//
//  Created by Sopan Sharma on 4/14/15.
//  Copyright (c) 2015 Sopan Sharma. All rights reserved.
//

#import "SSViewController.h"
#import "SSBoxCollectionViewController.h"

@interface SSViewController ()
@property (nonatomic, strong) SSBoxCollectionViewController *boxViewController;

@end

@implementation SSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.boxViewController = [[SSBoxCollectionViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 300) data:@{@"imageList": @[@"0", @"1", @"2", @"3", @"4"]}];
    self.boxViewController.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.boxViewController .view];
    self.boxViewController.view.center = self.view.center;
}


@end
