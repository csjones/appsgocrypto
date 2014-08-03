//
//  ListModel.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListModel.h"
#import "AppsGoCryptoManager.h"
#import "iTunesSearchManager.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "AFURLResponseSerialization.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListModel Category Interface

@interface ListModel ( )

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Category Methods

- ( NSArray* )tagsForId:( NSNumber* )appId;

- ( void )addAppInfoWith:( NSDictionary* )appInfo;

- ( BOOL )doesAppIconExistForId:( NSNumber* )appId;

- ( void )updateAppInfosWithResults:( NSArray* )results;

- ( void )replaceAppIconWith:( NSData* )iconData forAppId:( NSNumber* )appId;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListModel Class Implementation

@implementation ListModel

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   NSObject

- ( id )init
{
    if ( self = [super init] )
    {
        _itunesSearchManager = [iTunesSearchManager sharedInstance];
        
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        
        _basePath = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES )[ 0 ];
        
        NSString* plistPath = [_basePath stringByAppendingPathComponent:@"AppList.plist"];
        
        if ( ![fileManager fileExistsAtPath:plistPath] )
        {
            NSError* error;
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"AppList" ofType:@"plist"];
            
            [fileManager copyItemAtPath:path toPath:plistPath error:&error];
        }
        else
        {
            __weak ListModel* weakSelf = self;
            
            AppsGoCryptoManager* agcManager = [[AppsGoCryptoManager alloc] init];
            
            [agcManager getAppsGoCrypto:@"AppList.plist"
                                success:^( id file ) {
                                    [file writeToFile:[weakSelf.basePath stringByAppendingPathComponent:@"AppList.plist"] atomically:YES];
                                }
                                failure:^( NSError* error ) {
                                    NSLog(@"error %@", error);
                                }];
        }
        
        _filteredAppInfos = [[NSMutableDictionary alloc] init];
        
        _appList = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        _appInfos = [[NSArray alloc] initWithContentsOfFile:[_basePath stringByAppendingPathComponent:@"AppInfos.plist"]];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Category Methods

- ( NSArray* )tagsForId:( NSNumber* )appId
{
    for ( __weak NSDictionary* weakAppInfo in _appList)
        if ( [weakAppInfo[ @"id" ] isEqualToString:appId.stringValue] )
            return weakAppInfo[ @"tags" ];
    
    return nil;
}

- ( void )addAppInfoWith:( NSDictionary* )appInfo
{
    for ( __weak NSDictionary* weakAppInfo in _appInfos )
        if ( [weakAppInfo[ @"appId" ] isEqualToNumber:appInfo[ @"appId" ]] )
            return;
    
    NSMutableArray* newAppInfos = _appInfos.mutableCopy;
    
    [newAppInfos addObject:appInfo];
    
    _appInfos = [[NSArray alloc] initWithArray:newAppInfos];
    
    [_appInfos writeToFile:[_basePath stringByAppendingPathComponent:@"AppInfos.plist"] atomically:YES];
}

- ( BOOL )doesAppIconExistForId:( NSNumber* )appId
{
    for ( __weak NSDictionary* weakAppInfo in _appInfos )
        if ( [weakAppInfo[ @"appId" ] isEqualToNumber:appId] && ![weakAppInfo[ @"placeholderAppIcon" ] boolValue] )
            return TRUE;
    
    return FALSE;
}

- ( void )updateAppInfosWithResults:( NSArray* )results
{
    __weak ListModel* weakSelf = self;
    
    UIImage* placeholderAppIcon = [UIImage imageNamed:@"placeholder"];
    
    NSData* dataAppIcon = UIImageJPEGRepresentation( placeholderAppIcon, 1.0 );
    
    for ( __weak NSDictionary* weakAppInfo in results )
    {
        if ( [weakSelf doesAppIconExistForId:weakAppInfo[ @"trackId" ]] )
            continue;
        
        NSMutableDictionary* newAppInfo = [[NSMutableDictionary alloc] init];
        
        [newAppInfo setObject:@1 forKey:@"placeholderAppIcon"];
        [newAppInfo setObject:weakAppInfo[ @"trackId" ] forKey:@"appId"];
        [newAppInfo setObject:weakAppInfo[ @"trackCensoredName" ] forKey:@"appName"];
        [newAppInfo setObject:[self tagsForId:weakAppInfo[ @"trackId" ]] forKey:@"tags"];
        
        [weakSelf addAppInfoWith:[[NSDictionary alloc] initWithDictionary:newAppInfo]];
        
        [dataAppIcon writeToFile:[_basePath stringByAppendingPathComponent:[weakAppInfo[ @"trackId" ] stringValue]] atomically:YES];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:weakAppInfo[ @"artworkUrl512" ]]];
        
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf replaceAppIconWith:UIImageJPEGRepresentation( responseObject, 1.0 )
                                forAppId:weakAppInfo[ @"trackId" ]];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        
        [requestOperation start];
    }
}

- ( void )replaceAppIconWith:( NSData* )iconData forAppId:( NSNumber* )appId
{
    NSMutableArray* newAppInfos = _appInfos.mutableCopy;
    
    for ( NSInteger i = 0; i < newAppInfos.count; i++ )
    {
        if ( ![newAppInfos[ i ][ @"appId" ] isEqualToNumber:appId] )
            continue;
        
        NSMutableDictionary* updatedAppInfo = [newAppInfos[ i ] mutableCopy];
        
        [updatedAppInfo setObject:@0 forKey:@"placeholderAppIcon"];
        
        [newAppInfos replaceObjectAtIndex:i withObject:[[NSDictionary alloc] initWithDictionary:updatedAppInfo]];
        
        _appInfos = [[NSArray alloc] initWithArray:newAppInfos];
                
        [_appInfos writeToFile:[_basePath stringByAppendingPathComponent:@"AppInfos.plist"] atomically:YES];
        
        [iconData writeToFile:[_basePath stringByAppendingPathComponent:appId.stringValue] atomically:YES];
        
        return;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )getAppInfoWithCompletion:( void ( ^ )( void ) )completion
{
    __weak ListModel* weakSelf = self;
    
    __block void (^blockCompletion)(void) = completion;
    
    NSMutableArray* ids = [[NSMutableArray alloc] init];
    
    for ( NSUInteger i = 0; i < _appList.count; i++ )
        [ids addObject:_appList[ i ][ @"id" ]];
    
    [_itunesSearchManager lookupIds:[[NSArray alloc] initWithArray:ids]
                            success:^( NSArray* results ) {
                                [weakSelf updateAppInfosWithResults:results];
                                                
                                blockCompletion();
                            }
                            failure:^( NSError* error ) {
                                NSLog(@"error %@", error);
                            }];
}

- ( void )appInfosWithTag:( NSString* )tag completion:( void ( ^ )( void ) )completion
{
    _tag = tag;
    
    if ( [tag isEqualToString:@"All Coins"] )
    {
        [_filteredAppInfos removeAllObjects];
        
        _tag = nil;
        
        completion();
        
        return;
    }
    
    if ( _filteredAppInfos[ tag ] )
    {
        NSArray* updatedAppInfos = [_filteredAppInfos[ tag ] copy];
        
        [_filteredAppInfos removeAllObjects];
        
        [_filteredAppInfos setObject:updatedAppInfos forKey:tag];
        
        completion();
        
        return;
    }
    
    NSArray* appInfosToFilter = _filteredAppInfos.count ? [_filteredAppInfos.allValues[ 0 ] copy] : [_appInfos copy];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY tags CONTAINS[c] %@", tag];
    
    NSArray* filteredAppInfos = [appInfosToFilter filteredArrayUsingPredicate:predicate];
    
    [_filteredAppInfos setObject:filteredAppInfos forKey:tag];
    
    completion();
}

- ( void )cell:( UITableViewCell* )cell onTableView:( UITableView* )tableView didScrollOnView:( UIView* )view
{
    __weak UIImageView* weakParallaxImageView = ( UIImageView* )[cell viewWithTag:2];
    
    CGRect rectInSuperview = [tableView convertRect:cell.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(weakParallaxImageView.frame) - CGRectGetHeight(cell.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = weakParallaxImageView.frame;
    
    imageRect.origin.x = -96;
    imageRect.origin.y = -(difference/2)+move;
    
    weakParallaxImageView.frame = imageRect;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UITableViewDataSource

- ( NSInteger )numberOfSectionsInTableView:( UITableView* )tableView
{
    return 1;
}

- ( NSInteger )tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section
{
    if ( _tag )
        return [_filteredAppInfos[ _tag ] count];
    
    return _appInfos.count;
}

- ( UITableViewCell* )tableView:( UITableView* )tableView cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    static NSString* CellIdentifier = @"merell";
    
    __weak NSDictionary* weakAppInfo = _tag ? _filteredAppInfos[ _tag ][ indexPath.row ] : _appInfos[ indexPath.row ];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImage* appIcon = [[UIImage alloc] initWithContentsOfFile:[_basePath stringByAppendingPathComponent:[weakAppInfo[ @"appId" ] stringValue]]];
    
    if ( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* parallaxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 512, 512)];
        
        parallaxImageView.tag = 2;
        parallaxImageView.image = appIcon;
        
        [cell addSubview:parallaxImageView];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 182, 300, 64)];
        
        titleLabel.tag = 3;
        titleLabel.numberOfLines = 0;
        titleLabel.minimumScaleFactor = .25;
        titleLabel.text = weakAppInfo[ @"appName" ];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1.f];
        
        [cell addSubview:titleLabel];
    }
    else
    {
        __weak UIImageView* weakParallaxImageView = ( UIImageView* )[cell viewWithTag:2];
        
        weakParallaxImageView.image = appIcon;
        
        __weak UILabel* weakTitleLabel = ( UILabel* )[cell viewWithTag:3];
        
        weakTitleLabel.text = weakAppInfo[ @"appName" ];
    }
    
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    return cell;
}

@end
