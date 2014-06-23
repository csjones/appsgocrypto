//
//  Root.h
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

@interface Root : NSObject < UITableViewDataSource >

@property ( readonly, nonatomic )   NSArray*    dataSource;
@property ( readonly, nonatomic )   NSArray*    sectionHeaders;

- ( void )collapseAllHeaders;

- ( void )toggleSectionHeader:( NSInteger )section;

@end
