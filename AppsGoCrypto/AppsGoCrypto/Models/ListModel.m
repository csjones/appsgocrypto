//
//  ListModel.m
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListModel.h"
#import "JBParallaxCell.h"
#import "AppsGoCryptoManager.h"
#import "iTunesSearchManager.h"
#import "UIImageView+AFNetworking.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListModel Category Interface

@interface ListModel ( )

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Category Methods

- ( NSString* )filteredAppNameWithString:( NSString* )string;

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
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        
        NSString* plistPath = [paths[ 0 ] stringByAppendingPathComponent:@"AppList.plist"];
        
        if ( ![fileManager fileExistsAtPath:plistPath] )
        {
            NSError* error;
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"AppList" ofType:@"plist"];
            
            [fileManager copyItemAtPath:path toPath:plistPath error:&error];
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
        
        _media = [[NSArray alloc] initWithContentsOfFile:plistPath];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Category Methods

- ( NSString* )filteredAppNameWithString:( NSString* )appName
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Class Methods

- ( void )getMediaInfoWithCompletion:( void ( ^ )( void ) )completion
{
    __weak ListModel* weakSelf = self;
    
    __block void (^blockCompletion)(void) = completion;
    
    NSMutableArray* ids = [[NSMutableArray alloc] init];
    
    for ( NSUInteger i = 0; i < _media.count; i++ )
        [ids addObject:_media[ i ][ @"id" ]];
    
    [[iTunesSearchManager sharedInstance] lookupIds:[[NSArray alloc] initWithArray:ids]
                                            success:^( id file ) {
                                                weakSelf.mediaInfo = file[ @"results" ];
                                                
                                                blockCompletion();
                                            }
                                            failure:^( NSError* error ) {
                                                NSLog(@"error %@", error);
                                            }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UITableViewDataSource

- ( NSInteger )numberOfSectionsInTableView:( UITableView* )tableView
{
    return 1;
}

- ( NSInteger )tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section
{
    return _mediaInfo.count;
}

- ( UITableViewCell* )tableView:( UITableView* )tableView cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    static NSString* CellIdentifier = @"parallaxCell";
    
    JBParallaxCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:_mediaInfo[ indexPath.row ][ @"artworkUrl512" ]]];
    
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak UITableView* weakTableView = tableView;
    
    __weak JBParallaxCell* weakCell = cell;
    
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    cell.titleLabel.text = _mediaInfo[ indexPath.row ][ @"trackCensoredName" ];
    
    [cell.parallaxImage setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"placeholder"]
                                       success:^( NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                           [weakCell cellOnTableView:weakTableView didScrollOnView:weakTableView.superview];
                                           weakCell.parallaxImage.image = image;
                                       }
                                       failure:nil];

    return cell;
}

@end
