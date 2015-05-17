//
//  SearchTableViewController.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/15/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SearchViewController.h"
#import "SuggestionsViewController.h"
#import "SearchViewModel.h"
#import "SearchResultsCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SearchViewController () <SuggestionsViewControllerDelegate,UISearchBarDelegate>



@property (nonatomic, strong) SearchViewModel *viewModel;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [SearchViewModel new];
    
    
    @weakify(self);
    [self.viewModel.didUpdateResults subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.viewModel numberOfResults];
}


#pragma mark - Actions



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsCell"];
    [cell configureWithSearchResults:[self.viewModel resultAtIndex:indexPath.row]];
    return cell;
}


-(IBAction)presentSuggestions:(id)sender{
 
    SuggestionsViewController *suggestionsVC = [SuggestionsViewController new];
    [suggestionsVC setDelegate:self];
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:suggestionsVC];
    [searchController setSearchResultsUpdater:suggestionsVC];
    [searchController setHidesNavigationBarDuringPresentation:NO];
    [searchController.searchBar setDelegate:self];
    [self presentViewController:searchController animated:YES completion:nil];
    
}



#pragma mark SuggestionsViewControllerDelegate
-(void)suggestionsViewController:(SuggestionsViewController *)viewController didSelectSuggestion:(NSString *)suggestion{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Pasarle al viewModel de la tabla la suggestions
    self.viewModel.query = suggestion;
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Pasarle al viewModel de la tabla la suggestions
    self.viewModel.query = searchBar.text;
    [self.view endEditing:YES];
}

@end
