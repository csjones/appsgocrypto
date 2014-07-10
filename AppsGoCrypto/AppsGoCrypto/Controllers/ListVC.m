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

@interface ListVC ( )

- ( void )updateVisibleCells;

@end

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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Private

- ( void )updateVisibleCells
{
    for ( __weak UITableViewCell *weakCell in [_weakSelf.tableView visibleCells] )
        if ( [weakCell isKindOfClass:[JBParallaxCell class]] )
        {
            __weak JBParallaxCell* parallaxCell = ( JBParallaxCell* )weakCell;
            
            [parallaxCell cellOnTableView:_weakSelf.tableView didScrollOnView:_weakSelf.tableView.superview];
        }
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

- ( CGFloat )tableView:( UITableView* )tableView heightForRowAtIndexPath:( NSIndexPath* )indexPath
{
    return indexPath.row ? 58.f : 116.f;
}

- ( void )tableView:( UITableView* )tableView didSelectRowAtIndexPath:( NSIndexPath* )indexPath
{
    SKStoreProductViewController* vc = [[SKStoreProductViewController alloc] init];
    
    vc.delegate = self;
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:_tableModel.mediaInfo[ indexPath.row ][ @"trackId" ],SKStoreProductParameterITunesItemIdentifier,nil];
    
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
