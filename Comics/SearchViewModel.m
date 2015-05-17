//
//  SearchViewModel.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchResultsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ComicsVineClient.h"


@interface SearchViewModel ()

@property (nonatomic, strong) ComicsVineClient * client;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation SearchViewModel

- (instancetype)init
{
    if ( self == [super init]) {
        _currentPage = 1;
        _client = [ComicsVineClient new];
        
//        RACSignal *input = [RACObserve(self, query) filter:^BOOL(NSString *value) {
//            return value.length>0;
//        }];
    }
    return self;
}

-(void) setQuery:(NSString *)query{
    if (![_query isEqualToString:query]) {
        _query = [query copy];
        [self beginNewSearch];
    }
}

-(NSUInteger)numberOfResults{
    
    return 1;
}

-(SearchResultsViewModel *) resultAtIndex:(NSUInteger) index{
    return nil;
}

#pragma mark Private

-(RACSignal *) fetchNextPage{
    return nil;
}

-(void) beginNewSearch{
    self.currentPage = 1;
    //TODO: reset DB
    [self fetchNextPage];
}

@end
