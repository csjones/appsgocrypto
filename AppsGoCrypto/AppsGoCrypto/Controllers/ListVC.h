//
//  ListVC.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//
// http://www.reddit.com/r/Bitcoin/comments/29ehe9/list_of_ios_wallets/

#import "ListModel.h"

@interface ListVC : UIViewController < UITableViewDelegate, UIScrollViewDelegate >
{
    __weak ListVC*  _weakSelf;
}

@property ( weak, nonatomic )   IBOutlet    UITableView*    tableView;
@property ( strong, nonatomic )             ListModel*      tableModel;

@end
