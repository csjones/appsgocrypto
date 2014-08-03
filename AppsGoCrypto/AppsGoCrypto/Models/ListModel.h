//
//  ListModel.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

@class iTunesSearchManager;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListModel Class Interface

@interface ListModel : NSObject < UITableViewDataSource >

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Properties

@property ( strong, nonatomic )     NSArray*                appList;
@property ( strong, nonatomic )     NSArray*                appInfos;
@property ( strong, nonatomic )     NSMutableDictionary*    filteredAppInfos;

@property ( readonly, nonatomic )   NSString*               tag;
@property ( readonly, nonatomic )   NSString*               basePath;

@property ( weak, nonatomic )       iTunesSearchManager*    itunesSearchManager;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )getAppInfoWithCompletion:( void ( ^ )( void ) )completion;

- ( void )appInfosWithTag:( NSString* )tag completion:( void ( ^ )( void ) )completion;

- ( void )cell:( UITableViewCell* )cell onTableView:( UITableView* )tableView didScrollOnView:( UIView* )view;

@end
