//
//  iTunesSearchManager.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "iTunesSearchManager.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   iTunesSearchManager Class Implementation

@implementation iTunesSearchManager

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   NSObject

- ( id )initWithBaseURL:( NSURL* )url
{
    if ( self = [super initWithBaseURL:url] )
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithArray:@[ @"text/javascript" ]];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Singleton

+ ( iTunesSearchManager* )sharedInstance
{
    static iTunesSearchManager* sharedInstance = nil;
    
    if(sharedInstance)
        return sharedInstance;
    
    static dispatch_once_t pred;	// Lock
    
    dispatch_once(&pred,
                  ^{	// This code is called at most once per app
                      sharedInstance = [[iTunesSearchManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://itunes.apple.com/"]];
                  });
    
    return sharedInstance;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Public

- ( void )lookupIds:( NSArray* )ids success:( void ( ^ )( id file ) )success failure:( void ( ^ )( NSError* error ) )failure
{
    [self GET:@"lookup"
   parameters:@{ @"id" : [ids componentsJoinedByString:@","], @"country" : [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] }
      success:^( AFHTTPRequestOperation* operation, id responseObject ) {
          success( responseObject );
      }
      failure:^( AFHTTPRequestOperation* operation, NSError* error ) {
          failure( error );
      }];
}

@end
