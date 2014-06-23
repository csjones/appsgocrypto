//
//  RootVC.h
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "Root.h"

@interface RootVC : UIViewController < UITableViewDelegate >

@property ( weak, nonatomic )   IBOutlet    UITableView*    tableView;
@property ( readonly, nonatomic )           Root*           tableModel;

@end
