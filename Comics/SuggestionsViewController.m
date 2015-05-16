//
//  SuggestionsViewController.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/15/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SuggestionsViewController.h"
#import "SuggestionsViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SuggestionsViewController ()

@property (nonatomic, strong) SuggestionsViewModel *viewModel;

@end

static NSString* reuseIdentifier = @"cell";

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [SuggestionsViewModel new];
    @weakify(self);
    [self.viewModel.didUpdateSuggestionsSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.viewModel.numberOfSuggestions;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Esta es la forma moderna de hacer el dequeue
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [cell.textLabel setText:[self.viewModel suggestionAtIndex:indexPath.row]];
    
    return cell;
}



#pragma mark UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
 
    self.viewModel.query = searchController.searchBar.text;
    
}

@end
