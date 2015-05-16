//
//  SearchTableViewController.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/15/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SearchViewController.h"
#import "SuggestionsViewController.h"


@interface SearchViewController ()



@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


#pragma mark - Actions


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

-(IBAction)presentSuggestions:(id)sender{
 
    SuggestionsViewController *suggestionsVC = [SuggestionsViewController new];
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:suggestionsVC];
    [searchController setSearchResultsUpdater:suggestionsVC];
    [searchController setHidesNavigationBarDuringPresentation:NO];
    [self presentViewController:searchController animated:YES completion:nil];
    
}


@end