//
//  Root.m
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "Root.h"
#import "NSArray+RootModel.h"

@implementation Root

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   NSObject

- ( id )init
{
    if ( self = [super init] )
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DataSource" ofType:@"plist"];
        
        _dataSource = [[NSArray alloc] initWithContentsOfFile:path];
        
        [self collapseAllHeaders];
    }

    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Public

- ( void )collapseAllHeaders
{
    NSMutableArray* newHeaders = [[NSMutableArray alloc] init];
    
    for( NSUInteger i = 0; i < _dataSource.count; i++ )
        [newHeaders addObject:@0];
    
    _sectionHeaders = [[NSArray alloc] initWithArray:newHeaders];
}

- ( void )toggleSectionHeader:( NSInteger )section
{    
    NSMutableArray* newHeaders = [_sectionHeaders mutableCopy];
    
    newHeaders[ section ] = [[NSNumber alloc] initWithBool:![newHeaders[ section ] boolValue]];
    
    _sectionHeaders = [[NSArray alloc] initWithArray:newHeaders];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UITableViewDataSource

- ( NSInteger )numberOfSectionsInTableView:( UITableView* )tableView
{
    return _dataSource.count;
}

- ( NSInteger )tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section
{
    if( ![_sectionHeaders[ section ] boolValue] )
        return 1;
    
    return [[_dataSource rowsWithSection:section] count] + 1;
}

- ( UITableViewCell* )tableView:( UITableView* )tableView cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    static UITableViewCell* cell = nil;
    
    if ( indexPath.row )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.textLabel.text = [_dataSource cellNameWithIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
        
        cell.textLabel.text = [_dataSource headerNameWithIndexPath:indexPath];
    }
    
    return cell;
}

@end
