//
//  SearchResultsCell.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SearchResultsCell.h"
#import "SearchResultsViewModel.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface SearchResultsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPublisher;

@end


@implementation SearchResultsCell




-(void) configureWithSearchResults:(SearchResultsViewModel *) searchResults{
    
    [self.coverImage setImageWithURL:searchResults.imageURL];
    [self.lblTitle setText:searchResults.title];
    [self.lblPublisher setText:searchResults.publisher];
}


-(void)prepareForReuse{
    [super prepareForReuse];
    
    [self.coverImage cancelImageRequestOperation];
    [self.coverImage setImage:nil];
}

@end
