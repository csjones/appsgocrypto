//
//  RootVC.m
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "RootVC.h"

@implementation RootVC

- ( id )initWithCoder:( NSCoder* )aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        _tableModel = [[Root alloc] init];
    }
    
    return self;
}

- ( void )viewWillAppear:( BOOL )animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view.
    _tableView.dataSource = _tableModel;
    
    [_tableView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- ( void )tableView:( UITableView* )tableView didSelectRowAtIndexPath:( NSIndexPath* )indexPath
{
    if ( indexPath.row )
    {
        
    }
    else
    {
        for ( NSInteger i = 0; i < _tableModel.sectionHeaders.count; i++ )
            if ( i != indexPath.section && [_tableModel.sectionHeaders[ i ] boolValue] )
            {
                [_tableModel toggleSectionHeader:i];
                
                [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
            }
        
        [_tableModel toggleSectionHeader:indexPath.section];
        
        [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
