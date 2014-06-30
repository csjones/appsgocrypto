//
//  iTunesSearchManager.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface iTunesSearchManager : AFHTTPRequestOperationManager

+ ( id )sharedInstance;

- ( void )lookupIds:( NSArray* )ids success:( void ( ^ )( id file ) )success failure:( void ( ^ )( NSError* error ) )failure;

@end
