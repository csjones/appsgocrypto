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
#pragma mark    -   Public

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
    return _mediaInfo.count;
}

- ( NSInteger )tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section
{
    return 2;
}

- ( UITableViewCell* )tableView:( UITableView* )tableView cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    if ( indexPath.row )
    {
        static NSString* CellIdentifier = @"lowerCell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.textLabel.text = _mediaInfo[ indexPath.section ][ @"trackCensoredName" ];
        
        return  cell;
    }
    
    static NSString* CellIdentifier = @"parallaxCell";
    
    JBParallaxCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:_mediaInfo[ indexPath.section ][ @"artworkUrl512" ]]];
    
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak UITableView* weakTableView = tableView;
    
    __weak JBParallaxCell* weakCell = cell;
    
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
