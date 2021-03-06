//
//  RootModel.m
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "RootModel.h"
#import "STCategory.h"
#import "NSArray+RootModel.h"
#import "UIColor+HexString.h"
#import "AppsGoCryptoManager.h"

@implementation RootModel

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   NSObject

- ( id )init
{
    if ( self = [super init] )
    {
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        
        NSString* plistPath = [paths[ 0 ] stringByAppendingPathComponent:@"AppCategories.plist"];
        
        _displayedChildren = [[NSMutableArray alloc] init];
        _structure = [[NSMutableDictionary alloc] init];
        _categories = [[NSMutableArray alloc] init];
        
        if ( ![fileManager fileExistsAtPath:plistPath] )
        {
            NSError* error;
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"AppCategories" ofType:@"plist"];
            
            [fileManager copyItemAtPath:path toPath:plistPath error:&error];
        }
        else
        {
            AppsGoCryptoManager* agcManager = [[AppsGoCryptoManager alloc] init];
            
            [agcManager getAppsGoCrypto:@"AppCategories.plist"
                                success:^( id file ) {
                                    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
                
                                    NSString* plistPath = [paths[ 0 ] stringByAppendingPathComponent:@"AppCategories.plist"];
                
                                    [file writeToFile:plistPath atomically:YES];
                                }
                                failure:^( NSError* error ) {
                                    NSLog(@"error %@", error);
                                }];
        }
        
        [self parsePlist:[[NSDictionary alloc] initWithContentsOfFile:plistPath] backIndex:-1];
        
        _selectedCategorySection = -1;
        
        [_displayedChildren addObjectsFromArray:(( NSDictionary* )_structure[ @"0" ])[ @"forwardIndex" ]];
    }

    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Public

- ( NSInteger )getCategoryIndexFrom:( NSInteger )index
{
    if (_displayedChildren && _displayedChildren.count > 0 && index >=0 && index < _displayedChildren.count)
    {
        return [_displayedChildren[index] integerValue];
    }
    return 0;
}

- ( STTableViewCell* )setCell:( STTableViewCell* )cell content:( STCategory* )category indexRow:( NSInteger )indexRow
{
    [cell setContent:category];
    
    if (_selectedCategorySection < 0 )
    {
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.contentView setBackgroundColor:[UIColor colorWithHexString:category.colorHex]];
    }
    else
    {
        if (indexRow < _selectedCategorySection)
        {
            cell.textLabel.textColor = [UIColor grayColor];
        }
        else if (indexRow == _selectedCategorySection)
        {
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell.contentView setBackgroundColor:[UIColor colorWithHexString:category.colorHex]];
        }
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}

- ( NSInteger )parsePlist:( NSDictionary* )jsonDict backIndex:( NSInteger )backIndex
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    STCategory *category = [[STCategory alloc]initWithJSON:jsonDict];

    [self.categories addObject:category];

    NSInteger currentIndex = [self.categories indexOfObject:category];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *jsonArray = jsonDict[ @"children" ];

    if (jsonArray && jsonArray.count > 0)
    {
        for ( __weak NSDictionary *jsonCategoryDict in jsonArray)
        {
          [array addObject: [[NSString alloc] initWithFormat:@"%ld",[self parsePlist:jsonCategoryDict backIndex:currentIndex]]];
        }
    }

    [dict setObject:[[NSString alloc] initWithFormat:@"%ld", backIndex] forKey:@"backIndex"];
    
    if (array && array.count > 0)
    {
        [dict setObject:array forKey:@"forwardIndex"];
    }

    [_structure setObject:dict forKey:[[NSString alloc] initWithFormat:@"%ld",currentIndex]];

    return currentIndex;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UITableViewDataSource

- ( NSInteger )tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section
{
    
    return _displayedChildren.count;
}

- ( UITableViewCell* )tableView:( UITableView* )tableView cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    static NSString *CellIdentifier = @"Cell";
    STTableViewCell *cell = ( STTableViewCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[STTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger index = [self getCategoryIndexFrom:indexPath.row];
    
    STCategory *category = ((STCategory *)[self.categories objectAtIndex:index]);
    
    cell = [self setCell:cell content:category indexRow:indexPath.row];
        
    return cell;
}

@end
