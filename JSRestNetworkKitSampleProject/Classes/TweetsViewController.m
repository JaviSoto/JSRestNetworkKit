//
//  TweetsViewController.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TweetsViewController.h"

#import "TweetCell.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UINib *cellNib;
@end

@implementation TweetsViewController

@synthesize cellNib = _cellNib;

#pragma mark - Loading



#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TweetCell";
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[self.cellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    
    
    return cell;
}

#pragma mark - Memory management
                
- (UINib *)cellNib
{
    if (!_cellNib)
    {
        _cellNib = [[UINib nibWithNibName:NSStringFromClass([TweetCell class]) bundle:nil] retain];
    }
    
    return _cellNib;
}

- (void)dealloc
{
    [_cellNib release];
    
    [super dealloc];
}

@end
