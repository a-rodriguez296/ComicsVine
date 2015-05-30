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
    return [[[client fetchSuggestedVolumesWithQuery:query] map:^id(Response *response) {
        NSArray *volumes = response.results;
        
        NSMutableArray * titles = [NSMutableArray new];
        for (Volume *volume in volumes) {
            if ([titles containsObject:volume.title]) {
                continue;
            }
            [titles addObject:volume.title];
        }
        
        return titles;
    }] deliverOnMainThread];
    
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
    //El catch se utiliza para el manejo del error. Si no se pone el catch y hay error, la aplicación se revienta
    RAC(self, suggestions) = [suggestionsSignal catch:^RACSignal *(NSError *error) {
        
        //Hay que devolver un array pq el atributo suggestions es un array
        return [RACSignal return:@[error.localizedDescription]];
    }];
    
    //Este método sirve por si le quisiera hacer algo a cada elemento de suggestions. Como no le quiero hacer nada, devuelvo nil
    //Acá la señal didUpdate... es una señal que observa  suggestions
    _didUpdateSuggestionsSignal = [RACObserve(self, suggestions) mapReplace:nil];
    
    //Si quiero hacer un map de algo se puede hacer asi
//    [suggestionsSignal map:^id(NSArray * suggestions) {
//        return  nil;
//    }];

    
}

@end
