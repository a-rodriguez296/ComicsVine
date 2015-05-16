//
//  SuggestionsViewModel.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SuggestionsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Constants.h"
#import "ComicsVineClient.h"
#import "Response.h"
#import "Volume.h"

@interface SuggestionsViewModel ()

@property (nonatomic, copy) NSArray * suggestions;

@end

@implementation SuggestionsViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSignals];
        
    }
    return self;
}


-(NSUInteger)numberOfSuggestions{
    return self.suggestions.count;
}


-(NSString *) suggestionAtIndex:(NSUInteger ) index{
    return self.suggestions[index];
}


#pragma mark Private

-(RACSignal *) fetchSuggestionsWithQuery:(NSString *) query{
    
    //Creación del api client
    ComicsVineClient *client = [[ComicsVineClient alloc] init];
    //En fetchSugg... crea una señal que retorna un response.
    //SE usa map para hacer una transformación.
    return [[client fetchSuggestedVolumesWithQuery:query] map:^id(Response *response) {
        NSArray *volumes = response.results;
        
        NSMutableArray * titles = [NSMutableArray new];
        for (Volume *volume in volumes) {
            [titles addObject:volume.title];
        }
        
        
        
        return titles;
    }];
    
}


-(void) setupSignals{
    
    //Crear una señal que observa al atributo query
    RACSignal *input = RACObserve(self, query); //filter:^BOOL(id value) {}] ;
    
    //Solo enviar valores de la señal despues de 2 caracteres
    input = [input filter:^BOOL(NSString * value) {
        return value.length>2;
    }];
    
    //Intervalo de tiempo de quede existir entre cada cambio en la señal.
    input = [input throttle:0.4];
    
    //Prevenir referencia circular
    @weakify(self);
    //Por cada valor que llega del input/señal generamos una peticion al api client
    //Se usa flattenMap para encadenar con otra señal.
    RACSignal *suggestionsSignal = [input flattenMap:^RACStream *(NSString *query) {
        @strongify(self);
        return [self fetchSuggestionsWithQuery:query];
    }];
    
    //Binding. Asignar el resultado de suggestionsSignal a suggestions. En otras palabras, se le asigna al array el resultado de suggestion signals
    RAC(self, suggestions) = suggestionsSignal;
    
    //Este método sirve por si le quisiera hacer algo a cada elemento de suggestions. Como no le quiero hacer nada, devuelvo nil
    _didUpdateSuggestionsSignal = [suggestionsSignal map:^id(NSArray * suggestions) {
        return  nil;
    }];
    
    //Forma rápida
    //        _didUpdateSuggestionsSignal = [suggestionsSignal mapReplace:nil];
    
}

@end
