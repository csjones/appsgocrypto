//
//  InfoVC.h
//  AppsGoCrypto
//
//  Created by Chris on 8/11/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import <Storekit/StoreKit.h>

#import "HFStretchableTableHeaderView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   InfoVC Class Interface

@interface InfoVC : UITableViewController < UIScrollViewDelegate, UITableViewDelegate, SKStoreProductViewControllerDelegate >
{
    NSDictionary* _appInfo;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Properties

@property ( nonatomic, strong ) IBOutlet UIView* stretchView;
@property ( nonatomic, strong ) HFStretchableTableHeaderView* stretchableTableHeaderView;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   Instance Methods

- ( void )updateViewWithAppInfo:( NSDictionary* )dictionary;

@end
