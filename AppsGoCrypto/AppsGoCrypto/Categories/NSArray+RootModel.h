//
//  NSArray+RootModel.h
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

@interface NSArray ( RootModel )

- ( NSArray* )rowsWithSection:( NSInteger )section;

- ( NSString* )cellNameWithIndexPath:( NSIndexPath* )indexPath;

- ( NSString* )headerNameWithIndexPath:( NSIndexPath* )indexPath;

@end
