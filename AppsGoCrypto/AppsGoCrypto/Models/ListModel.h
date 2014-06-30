//
//  ListModel.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

@interface ListModel : NSObject < UITableViewDataSource >

@property ( readonly, nonatomic )   NSArray*    media;
@property ( strong, nonatomic )     NSArray*    mediaInfo;

- (void)getMediaInfoWithCompletion:( void ( ^ )( void ) )completion;

@end
