//
//  SearchResultsCell.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SearchResultsViewModel;

@interface SearchResultsCell : UITableViewCell

-(void) configureWithSearchResults:(SearchResultsViewModel *) searchResults;


@end
