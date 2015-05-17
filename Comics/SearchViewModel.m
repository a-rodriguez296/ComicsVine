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
#import "ManagedVolume.h"
#import "Response.h"

@interface SearchViewModel ()

@property (nonatomic, strong) ComicsVineClient * client;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) NSManagedObjectContext * privateContext;
@property (nonatomic, strong) NSManagedObjectContext * mainContext;

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

    return [[[self.client fetchVolumesWithQuery:self.query page:self.currentPage++] doNext:^(Response * value) {
        
        //Guardar datos en la base de datos
        
        
        
    }] deliverOnMainThread];
}

-(void) beginNewSearch{
    self.currentPage = 1;
    
    //TODO: reset DB
    NSManagedObjectContext *context = self.privateContext;
    [self.privateContext performBlock:^{
        
        //El contexto privado siempre debe accederse desde background. Por esa razón esto se hace desde un bloque
        [ManagedVolume deleteAllVolumesInManagedObjectContext:context];
    }];
    
    //Pasar de señal fria a señal caliente
    [[[self fetchNextPage] publish] connect];
}

@end
