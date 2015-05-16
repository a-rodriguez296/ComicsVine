//
//  SuggestionsViewModel.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface SuggestionsViewModel : NSObject

@property (nonatomic, copy) NSString * query;
@property (nonatomic, assign, readonly) NSUInteger numberOfSuggestions;

//Este es como el "delegado"
@property (nonatomic, strong, readonly) RACSignal *didUpdateSuggestionsSignal;

-(NSString *) suggestionAtIndex:(NSUInteger ) index;

@end
