//
//  AppsGoCryptoManager.m
//  AppsGoCrypto
//
//  Created by Chris on 6/26/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "AppsGoCryptoManager.h"

@implementation AppsGoCryptoManager

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   NSObject

- ( id )init
{
    if ( self = [super initWithBaseURL:[[NSURL alloc] initWithString:@"http://gigabitcoin.co/"]] )
    {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithArray:@[ @"text/xml" ]];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Public

- (void)getAppsGoCrypto:( NSString* )info success:( void ( ^ )( id file ) )success failure:( void ( ^ )( NSError* error ) )failure
{
    [self GET:info
   parameters:nil
      success:^( AFHTTPRequestOperation* operation, id responseObject ) {
          success( responseObject );
      }
      failure:^( AFHTTPRequestOperation* operation, NSError* error ) {
          failure( error );
      }];
}

@end
