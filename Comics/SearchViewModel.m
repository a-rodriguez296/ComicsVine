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


@implementation SearchViewModel


-(NSUInteger)numberOfResults{
    
    return 1;
}

-(SearchResultsViewModel *) resultAtIndex:(NSUInteger) index{
    return [[SearchResultsViewModel alloc] initWithImageUrl:[NSURL URLWithString:@"https://justinmarroquin.files.wordpress.com/2013/09/1016831_679253562090048_2110826334_n.jpg?w=640"] title:@"titlulo asdfadsf adsf adsfadsfadsf adsfadsfasdf adsfasdf" publisher:@"asdfasdfasdfad adsfadsfadsf"];
}

@end
