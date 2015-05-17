//
//  SearchViewModel.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchResultsViewModel.h"
#import "ComicsVineClient.h"
#import "ManagedVolume.h"
#import "Response.h"
#import "ManagedVolume.h"

#import <Groot/Groot.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SearchViewModel ()

@property (nonatomic, strong) ComicsVineClient * client;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) GRTManagedStore *store;
//Contexto de escritura que va en bakcground
@property (nonatomic, strong) NSManagedObjectContext * privateContext;

//Contexto de lectura que va en main
@property (nonatomic, strong) NSManagedObjectContext * mainContext;

@end

@implementation SearchViewModel

- (instancetype)init
{
    if ( self == [super init]) {
        _currentPage = 1;
        _client = [ComicsVineClient new];
        
        
        _store = [GRTManagedStore temporaryManagedStore];
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:_store.persistentStoreCoordinator];
        
        _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_privateContext setPersistentStoreCoordinator:_store.persistentStoreCoordinator];
        
        //Escuchar la notificacion cuando se guarda algo en el contexto privado
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_privateContext];
    }
    return self;
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

    NSManagedObjectContext *context = self.privateContext;
    
    return [[[self.client fetchVolumesWithQuery:self.query page:self.currentPage++] doNext:^(Response * response) {
        
        //Guardar datos en la base de datos
        [GRTJSONSerialization insertObjectsForEntityName:[ManagedVolume entityName] fromJSONArray:response.results inManagedObjectContext:self.privateContext error:NULL];
        
        //Hacer el save para que el contexto principal se entere. Esto es un método sincronico.
        [context performBlockAndWait:^{
            [context save:NULL];
        }];
        
        
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

-(void) privateContextDidSave:(NSNotification *) notification{
    
    NSManagedObjectContext *context = self.mainContext;
    [context performBlock:^{
        
        //Acá es donde se hace el merge de los contextos
        [context mergeChangesFromContextDidSaveNotification:notification];
        
    }];
}

@end
