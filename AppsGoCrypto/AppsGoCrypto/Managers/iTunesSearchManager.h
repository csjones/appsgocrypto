//
//  iTunesSearchManager.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   iTunesSearchManager Class Interface

@interface iTunesSearchManager : AFHTTPRequestOperationManager

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Properties

@property ( strong, nonatomic ) NSArray* lastResults;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Class Methods

+ ( id )sharedInstance;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )lookupIds:( NSArray* )ids success:( void ( ^ )( NSArray* results ) )success failure:( void ( ^ )( NSError* error ) )failure;

@end
