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
    self.tableView.dataSource = self.tableModel;
    
    [self.tableModel getMediaInfoWithCompletion:^{
        [_weakSelf.tableView reloadData];
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
    __weak UIViewController* weakParent = self.parentViewController;
    
    //  Get visible cells on table view.
    for ( __weak JBParallaxCell *weakCell in [_weakSelf.tableView visibleCells])
    {
        [weakCell cellOnTableView:_weakSelf.tableView didScrollOnView:weakParent.view];
    }
}

@end
