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

@interface SearchViewModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) ComicsVineClient * client;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) GRTManagedStore *store;
//Contexto de escritura que va en bakcground
@property (nonatomic, strong) NSManagedObjectContext * privateContext;

//Contexto de lectura que va en main
@property (nonatomic, strong) NSManagedObjectContext * mainContext;

@property (nonatomic, strong) NSFetchedResultsController * frc;

//Hereda de rac signal
@property (nonatomic, strong) RACSubject * didUpdateContentsSubject;


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
        
        
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:[ManagedVolume fetchRequestForAllVolumes] managedObjectContext:_mainContext sectionNameKeyPath:nil cacheName:nil];
        [_frc setDelegate:self];
        
        [_frc performFetch:NULL];
        
        
        //Forma de crear una señal cuando se llama un método del delegado
//        _didUpdateResults = [self rac_signalForSelector:@selector(controllerDidChangeContent:)];
        
        
        _didUpdateContentsSubject = [RACSubject subject];
    }
    return self;
}

-(RACSignal *)didUpdateResults{
    return self.didUpdateContentsSubject;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //Con esto se manda la señal. Pero es menos código hacerlo así  _didUpdateResults = [self rac_signalForSelector:@selector(controllerDidChangeContent:)]; como esta en el init.
    [self.didUpdateContentsSubject sendNext:nil];
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
    
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
    return [sectionInfo numberOfObjects];
}

-(SearchResultsViewModel *) resultAtIndex:(NSUInteger) index{
    
    ManagedVolume *volume = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return [[SearchResultsViewModel alloc] initWithImageUrl:[NSURL URLWithString:volume.imageURL] title:volume.title publisher:volume.publisher];
}




-(void) fetchCharacterDataAtIndex:(NSUInteger ) index{
    NSString *characterID = [self volumeIdentifierAtIndex:index];
    [[[[[self.client fetchVolumeCharachtersWithId:characterID] map:^id(Response *value) {
        
        
        NSArray *a =[NSArray arrayWithArray:[value.results objectForKey:@"characters]"]];
        
        return nil;
    }] deliverOnMainThread]publish]connect];
}

#pragma mark Private

-(NSString *) volumeIdentifierAtIndex:(NSUInteger ) index{
    ManagedVolume *volume = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return [NSString stringWithFormat:@"%@", volume.identifier];
}


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
        
        [context save:NULL];
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

-(void)fetchMoreResults{
     [[[self fetchNextPage] publish] connect];
}

@end
