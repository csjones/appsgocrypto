//
//  ListVC.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListVC.h"
#import "JBParallaxCell.h"

@implementation ListVC

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIViewController

- ( id )initWithCoder:( NSCoder* )aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        _weakSelf = self;
        
        _tableModel = [[ListModel alloc] init];
        
        [_tableModel getMediaInfoWithCompletion:^{
            [_weakSelf.tableView reloadData];
            
            NSLog(@"_weakSelf.tableModel.mediaInfo %@", _weakSelf.tableModel.mediaInfo);
        }];
    }
    
    return self;
}

- ( void )viewWillAppear:( BOOL )animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = _tableModel;
    
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //  Get visible cells on table view.
    for ( __weak JBParallaxCell *weakCell in [_weakSelf.tableView visibleCells] )
    {
        [weakCell cellOnTableView:_weakSelf.tableView didScrollOnView:_weakSelf.view];
    }
}

@end
