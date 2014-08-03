//
//  ListVC.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListVC.h"
#import "UIViewController+PSStackedView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListVC Category Interface

@interface ListVC ( )

- ( void )updateVisibleCells;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListVC Class Implementation

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

- ( void )didMoveToParentViewController:( UIViewController* )parent
{
    [super didMoveToParentViewController:parent];
}

- ( void )willMoveToParentViewController:( UIViewController* )parent
{
    [super willMoveToParentViewController:parent];
    
    self.tableView.dataSource = self.tableModel;
    
    // Do any additional setup after loading the view.
    [self.tableModel getAppInfoWithCompletion:^{
        [_weakSelf.tableView reloadData];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )updateListWithTag:( NSString* )tag
{
    [_tableModel appInfosWithTag:tag
                      completion:^{
                          [_weakSelf.tableView reloadData];
                      }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Category Methods

- ( void )updateVisibleCells
{
    for ( __weak UITableViewCell *weakCell in [_weakSelf.tableView visibleCells] )
        [_tableModel cell:weakCell onTableView:self.tableView didScrollOnView:self.tableView.superview];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIScrollViewDelegate

- ( void )scrollViewDidScroll:( UIScrollView* )scrollView
{
    //  Get visible cells on table view.3
    [self updateVisibleCells];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UITableViewDelegate

- ( void )tableView:( UITableView* )tableView willDisplayCell:( UITableViewCell* )cell forRowAtIndexPath:( NSIndexPath* )indexPath
{
    [_tableModel cell:cell onTableView:tableView didScrollOnView:tableView.superview];
}

- ( void )tableView:( UITableView* )tableView didSelectRowAtIndexPath:( NSIndexPath* )indexPath
{
    SKStoreProductViewController* vc = [[SKStoreProductViewController alloc] init];
    
    vc.delegate = self;
    
    __weak NSDictionary* weakAppInfo = _tableModel.tag ? _tableModel.filteredAppInfos[ _tableModel.tag ][ indexPath.row ] : _tableModel.appInfos[ indexPath.row ];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:weakAppInfo[ @"appId" ],SKStoreProductParameterITunesItemIdentifier,nil];
    
    [vc loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) { }];
    
    [self presentViewController:vc animated:YES completion:^{ }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   SKStoreProductViewControllerDelegate

- ( void )productViewControllerDidFinish:( SKStoreProductViewController* )viewController
{
    [viewController dismissViewControllerAnimated:YES
                                       completion:^{ [_weakSelf updateVisibleCells]; }];
}

@end
