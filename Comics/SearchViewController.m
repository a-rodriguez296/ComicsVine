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
#import "CharactersViewController.h"

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *characterIdentifier = [self.viewModel volumeIdentifierAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"characterSegue" sender:characterIdentifier];
    
}

#pragma mark - Actions



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsCell"];
    [cell configureWithSearchResults:[self.viewModel resultAtIndex:indexPath.row]];
    return cell;
}




-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == (self.viewModel.numberOfResults -1)) {
        NSLog(@"Last cell");
        [self.viewModel fetchMoreResults];
    }
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"characterSegue"]) {
        NSString *characterID = (NSString *) sender;
        CharactersViewController *charactersVC = (CharactersViewController *)segue.destinationViewController;
        [charactersVC setCharacterID:characterID];
    }
}

@end
