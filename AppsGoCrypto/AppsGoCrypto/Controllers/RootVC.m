//
//  RootVC.m
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "RootVC.h"

@implementation RootVC

- ( id )initWithCoder:( NSCoder* )aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        _weakSelf = self;
        
        _tableModel = [[RootModel alloc] init];
    }
    
    return self;
}

- ( void )viewWillAppear:( BOOL )animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view.
    _tableView.dataSource = _tableModel;
    
    [_tableView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- ( void )tableView:( UITableView* )tableView didSelectRowAtIndexPath:( NSIndexPath* )indexPath
{
    [self setArraysWithSelected:indexPath.row];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  TODO:   MVVM
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Animation Methods

- (NSIndexPath *)getIndexPath:(NSInteger)row
{
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSMutableArray *)indexPathArray:(int)begin end:(int)end
{
    NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
    for (int i = begin; i <= end; i++) {
        [indexPathArray addObject:[self getIndexPath:i]];
    }
    return indexPathArray;
}

- (void)tableView:(UITableView *)tableView action:(UITableViewRowAction)action indexPathArray:(NSArray *)indexPathArray animation:(UITableViewRowAnimation)animation
{
    if ( UITableViewRowInsert == action )
    {
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:animation];
    }
    else if ( UITableViewRowDelete == action )
    {
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:animation];
    }
}

- (void)tableview:(UITableView *)tableView baseIndexPath:(NSIndexPath *)baseIndexPath fromIndexPath:(NSIndexPath *)fromIndexPath animation:(UITableViewRowAnimation)baseTofromAnimation toIndexPath:(NSIndexPath *)toIndexPath animation:(UITableViewRowAnimation)baseTotoAnimation tableViewAction:(UITableViewRowAction)action
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [self indexPathArray:fromIndexPath.row end:baseIndexPath.row - 1];
    [self tableView:tableView action:action indexPathArray:array animation:baseTofromAnimation];
    array = [self indexPathArray:baseIndexPath.row + 1 end:toIndexPath.row];
    [self tableView:tableView action:action indexPathArray:array animation:baseTotoAnimation];
}

- (void)tableViewBased:(NSInteger)base from:(UITableViewRowAnimation)from to:(UITableViewRowAnimation)to action:(UITableViewRowAction)action
{
    [self tableview:self.tableView baseIndexPath:[self getIndexPath:base] fromIndexPath:[self getIndexPath:0] animation:from toIndexPath:[self getIndexPath:_tableModel.displayedChildren.count - 1] animation:to tableViewAction:action];
}

- (void)setArraysWithSelected:(NSInteger)index
{
    NSMutableArray *indexPathInsert = [[NSMutableArray alloc] init];
    
    NSInteger categoryIndex = [_tableModel getCategoryIndexFrom:index];
    
    int currentIndex = -1, movedIndex = -1;
    
    [self.tableView beginUpdates];
    
    if (index == 0 && categoryIndex == 0)
    {
        currentIndex = _tableModel.selectedCategorySection;
        
        _tableModel.selectedCategorySection = -1;
        
        [self tableViewBased:currentIndex from:UITableViewRowAnimationTop to:UITableViewRowAnimationFade action:UITableViewRowDelete];
        
        
        NSInteger rootIndex = [_tableModel getCategoryIndexFrom:1];
        
        [_tableModel.displayedChildren removeAllObjects];
        [_tableModel.displayedChildren addObjectsFromArray:[((NSDictionary *)[_tableModel.structure objectForKey:@"0"]) objectForKey:@"forwardIndex"]];
        
        movedIndex = [_tableModel.displayedChildren indexOfObject:[NSString stringWithFormat:@"%d", rootIndex]];
        if (currentIndex != movedIndex) movedIndex = 0;
        
        [self tableViewBased:movedIndex from:UITableViewRowAnimationBottom to:UITableViewRowAnimationTop action:UITableViewRowInsert];
        
    }
    else
    {
        if (_tableModel.selectedCategorySection == index)
        {
            NSLog(@"%@", ((STCategory *)[_tableModel.categories objectAtIndex:[_tableModel getCategoryIndexFrom:_tableModel.selectedCategorySection]]).name);
            [self.tableView endUpdates];
            return;
        }
        else
        {
            NSDictionary *categoriesDict =  [_tableModel.structure objectForKey:[NSString stringWithFormat:@"%d",categoryIndex]];
            NSArray *forwardCategoryArray = [categoriesDict objectForKey:@"forwardIndex"];
            
            if (_tableModel.selectedCategorySection == -1)
            {
                _tableModel.selectedCategorySection = 1;
                
                currentIndex = index;
                [self tableViewBased:currentIndex from:UITableViewRowAnimationBottom to:UITableViewRowAnimationFade action:UITableViewRowDelete];
                
                [_tableModel.displayedChildren removeAllObjects];
                [_tableModel.displayedChildren addObject:@"0"];
                [_tableModel.displayedChildren addObject:[NSString stringWithFormat:@"%d", categoryIndex]];
                
                if (forwardCategoryArray && forwardCategoryArray.count > 0)  [_tableModel.displayedChildren addObjectsFromArray:forwardCategoryArray];
                
                movedIndex = _tableModel.selectedCategorySection;
                
                [self tableViewBased:movedIndex from:UITableViewRowAnimationFade to:UITableViewRowAnimationFade action:UITableViewRowInsert];
                
            }
            else
            {
                NSRange range;
                currentIndex = _tableModel.selectedCategorySection;
                if (index < _tableModel.selectedCategorySection)
                {
                    range = NSMakeRange(index, _tableModel.displayedChildren.count - index);
                    _tableModel.selectedCategorySection = index;
                }
                else
                {
                    range = NSMakeRange(_tableModel.selectedCategorySection + 1, _tableModel.displayedChildren.count - _tableModel.selectedCategorySection - 1);
                    [indexPathInsert addObject:[self getIndexPath:_tableModel.selectedCategorySection]];
                    _tableModel.selectedCategorySection += 1;
                }
                
                [self tableview:self.tableView baseIndexPath:[self getIndexPath:currentIndex] fromIndexPath:[self getIndexPath:range.location] animation:UITableViewRowAnimationNone toIndexPath:[self getIndexPath:range.location + range.length - 1] animation:UITableViewRowAnimationNone tableViewAction:UITableViewRowDelete];
                
                [_tableModel.displayedChildren removeObjectsInRange:range];
                
                [_tableModel.displayedChildren addObject:[NSString stringWithFormat:@"%d",categoryIndex]];
                
                if (forwardCategoryArray && forwardCategoryArray.count > 0)
                {
                    [indexPathInsert addObjectsFromArray:[self indexPathArray:_tableModel.displayedChildren.count end:_tableModel.displayedChildren.count + forwardCategoryArray.count -1]];
                    [_tableModel.displayedChildren addObjectsFromArray:forwardCategoryArray];
                }
                movedIndex = _tableModel.selectedCategorySection;
                [self.tableView insertRowsAtIndexPaths:indexPathInsert withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    if (movedIndex > -1)
    {
        [self.tableView moveRowAtIndexPath:[self getIndexPath:currentIndex] toIndexPath:[self getIndexPath:movedIndex]];
        STCategory *cate = ((STCategory *)[_tableModel.categories objectAtIndex:[_tableModel getCategoryIndexFrom:movedIndex]]);
        [_tableModel setCell:(STTableViewCell *)[self.tableView cellForRowAtIndexPath:[self getIndexPath:currentIndex]] content:cate indexRow:movedIndex];
    }
    
    [self.tableView endUpdates];
}

@end
