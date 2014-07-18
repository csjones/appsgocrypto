//
//  ListModel.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListModel Class Interface

@interface ListModel : NSObject < UITableViewDataSource >

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Properties

@property ( readonly, nonatomic )   NSArray*    media;
@property ( strong, nonatomic )     NSArray*    mediaInfo;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Class Methods

- ( void )getMediaInfoWithCompletion:( void ( ^ )( void ) )completion;

@end
