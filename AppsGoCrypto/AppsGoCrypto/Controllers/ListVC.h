//
//  ListVC.h
//  AppsGoCrypto
//
//  Created by Chris on 6/29/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "ListModel.h"

@interface ListVC : UITableViewController < UITableViewDelegate >
{
    __weak  ListVC* _weakSelf;
}

@property ( readonly, nonatomic )   ListModel*  tableModel;

@end
