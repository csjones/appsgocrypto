//
//  Root.h
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#define InitSelectedIndex @"0"

#import "STTableViewCell.h"

typedef enum
{
    UITableViewRowInsert,
    UITableViewRowDelete
}UITableViewRowAction;

@interface Root : NSObject < UITableViewDataSource >

@property ( strong, nonatomic )     NSMutableDictionary*    structure;
@property ( strong, nonatomic )     NSMutableArray*         categories;
@property ( strong, nonatomic )     NSMutableArray*         displayedChildren;
@property ( assign, atomic )        NSInteger               selectedCategorySection;

- ( NSInteger )getCategoryIndexFrom:( NSInteger )index;
- ( NSInteger )parsePlist:( NSDictionary* )jsonDict backIndex:( NSInteger )backIndex;
- ( STTableViewCell* )setCell:( STTableViewCell* )cell content:( STCategory* )category indexRow:( NSInteger )indexRow;

@end
