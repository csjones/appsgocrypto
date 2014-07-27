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

@interface ListVC : UITableViewController < UIScrollViewDelegate, UITableViewDelegate, SKStoreProductViewControllerDelegate >
{
    __weak ListVC*  _weakSelf;
}

@property ( strong, nonatomic )         ListModel*      tableModel;

@end
