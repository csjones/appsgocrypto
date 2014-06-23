//
//  NSArray+RootModel.m
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "NSArray+RootModel.h"

@implementation NSArray ( RootModel )

- ( NSArray* )rowsWithSection:(NSInteger)section
{
    return self[ section ][ @"rows" ];
}

- ( NSString* )cellNameWithIndexPath:( NSIndexPath* )indexPath
{
    return self[ indexPath.section ][ @"rows" ][ indexPath.row - 1 ][ @"name" ];
}

- ( NSString* )headerNameWithIndexPath:( NSIndexPath* )indexPath
{
    return self[ indexPath.section ][ @"name" ];
}

@end
