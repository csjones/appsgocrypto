//
//  RootVC.h
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "RootModel.h"

@interface RootVC : UIViewController < UITableViewDelegate >
{
    __weak RootVC* _weakSelf;
}

@property ( weak, nonatomic )   IBOutlet    UITableView*    tableView;
@property ( readonly, nonatomic )           RootModel*      tableModel;

@end
