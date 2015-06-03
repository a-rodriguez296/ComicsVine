//
//  SearchViewModel.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResultsViewModel;
@class RACSignal;

@interface SearchViewModel : NSObject



@property (nonatomic, copy) NSString *query;
@property(nonatomic, strong, readonly) RACSignal *didUpdateResults;
@property(nonatomic, readonly) NSUInteger numberOfResults;


-(SearchResultsViewModel *) resultAtIndex:(NSUInteger) index;
-(void) fetchMoreResults;
-(NSString *) volumeIdentifierAtIndex:(NSUInteger ) index;
@end
