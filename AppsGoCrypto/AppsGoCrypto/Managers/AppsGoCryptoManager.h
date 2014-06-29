//
//  AppsGoCryptoManager.h
//  AppsGoCrypto
//
//  Created by Chris on 6/26/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AppsGoCryptoManager : AFHTTPRequestOperationManager

- (void)getAppsGoCrypto:( NSString* )info success:( void ( ^ )( id file ) )success failure:( void ( ^ )( NSError* error ) )failure;

@end
