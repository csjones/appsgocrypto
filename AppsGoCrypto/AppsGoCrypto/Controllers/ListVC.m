//
//  ListVC.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListVC.h"
#import "JBParallaxCell.h"
#import "UIViewController+PSStackedView.h"

@implementation ListVC

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIViewController

- ( id )initWithCoder:( NSCoder* )aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        _weakSelf = self;
        
        _tableModel = [[ListModel alloc] init];
    }
    
    return self;
}

- ( void )willMoveToParentViewController:( UIViewController* )parent
{
    [super willMoveToParentViewController:parent];
    
    // Do any additional setup after loading the view.
    _tableView.dataSource = self.tableModel;
    
    [self.tableModel getMediaInfoWithCompletion:^{
        NSLog(@"getMediaInfoWithCompletion");
        [_tableView reloadData];
    }];
}

- ( void )didMoveToParentViewController:( UIViewController* )parent
{
    [super didMoveToParentViewController:parent];
    
    [self scrollViewDidScroll:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIScrollViewDelegate

- ( void )scrollViewDidScroll:( UIScrollView* )scrollView
{
    //  Get visible cells on table view.
    for ( __weak JBParallaxCell *weakCell in [_weakSelf.tableView visibleCells])
    {
        [weakCell cellOnTableView:_weakSelf.tableView didScrollOnView:_weakSelf.view];
    }
}

@end
