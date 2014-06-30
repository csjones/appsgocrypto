//
//  ListModel.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListModel.h"
#import "AppsGoCryptoManager.h"

@implementation ListModel

- ( id )init
{
    if ( self = [super init] )
    {
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        
        NSString* plistPath = [paths[ 0 ] stringByAppendingPathComponent:@"AppList.plist"];
        
        if ( ![fileManager fileExistsAtPath:plistPath] )
        {
            NSError* error;
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"AppList" ofType:@"plist"];
            
            [fileManager copyItemAtPath:path toPath:plistPath error:&error];
            
            NSLog(@"error %@", error);
        }
        else
        {
            AppsGoCryptoManager* agcManager = [[AppsGoCryptoManager alloc] init];
            
            [agcManager getAppsGoCrypto:@"AppList.plist"
                                success:^( id file ) {
                                    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
                                    
                                    NSString* plistPath = [paths[ 0 ] stringByAppendingPathComponent:@"AppList.plist"];
                                    
                                    [file writeToFile:plistPath atomically:YES];
                                }
                                failure:^( NSError* error ) {
                                    NSLog(@"error %@", error);
                                }];
        }
        
        _apps = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        NSLog(@"apps %@", _apps);
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UITableViewDataSource

- ( NSInteger )tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section
{
//    return _displayedChildren.count;
    return 0;
}

- ( UITableViewCell* )tableView:( UITableView* )tableView cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    STTableViewCell *cell = ( STTableViewCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[STTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    NSInteger index = [self getCategoryIndexFrom:indexPath.row];
//    
//    STCategory *category = ((STCategory *)[self.categories objectAtIndex:index]);
//    
//    cell = [self setCell:cell content:category indexRow:indexPath.row];
//    
//    return cell;
    return nil;
}

@end
