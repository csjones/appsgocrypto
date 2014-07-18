//
//  StackedContainer.m
//  AppsGoCrypto
//
//  Created by Chris on 6/22/14.
//  Copyright (c) 2014 GigaBitcoin, LLC. All rights reserved.
//

#import "StackedContainer.h"

@implementation StackedContainer

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    -   UIViewController

- ( id )initWithCoder:( NSCoder* )aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        UIStoryboard* storyboard;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        self.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Root"];
    }

    return self;
}

- ( void )viewDidAppear:( BOOL )animated
{
    [super viewDidAppear:animated];
}

- ( BOOL )prefersStatusBarHidden
{
    return YES;
}

@end
