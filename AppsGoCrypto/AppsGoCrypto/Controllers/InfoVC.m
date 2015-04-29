//
//  InfoVC.m
//  AppsGoCrypto
//
//  Created by Chris on 8/11/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "InfoVC.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   InfoVC Class Implementation

@implementation InfoVC

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:_stretchView];
}

- (void)viewDidLayoutSubviews
{
    [_stretchableTableHeaderView resizeView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )updateViewWithAppInfo:( NSDictionary* )dictionary
{
    _appInfo = dictionary;
}

@end
