//
//  ListVC.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//
// http://www.reddit.com/r/Bitcoin/comments/29ehe9/list_of_ios_wallets/

#import "ListModel.h"

#import <Storekit/StoreKit.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   ListVC Class Interface

@interface ListVC : UITableViewController < UIScrollViewDelegate, UITableViewDelegate, SKStoreProductViewControllerDelegate >
{
    __weak ListVC*  _weakSelf;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Properties

@property ( strong, nonatomic )         ListModel*      tableModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )updateListWithTag:( NSString* )tag;

@end
