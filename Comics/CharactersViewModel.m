//
//  CharactersViewModel.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "CharactersViewModel.h"
#import "ComicsVineClient.h"
#import "Response.h"
#import "Volume.h"
#import "Character.h"
#import "CharacterResultViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CharactersViewModel ()

@property (nonatomic, copy) NSArray * characters;
@property (nonatomic, strong) ComicsVineClient *client;

@end


@implementation CharactersViewModel

- (instancetype)initWithCharacterID:(NSString *) characterID
{
    self = [super init];
    if (self) {
        _client = [ComicsVineClient new];
        _characterID = characterID;
        [self setupSignals];
    }
    return self;
}



#pragma mark Public

-(NSUInteger)numberOfResults{
    return self.characters.count;
}

-(CharacterResultViewModel *) resultAtIndex:(NSUInteger) index{
    Character *curretCharacter = self.characters[index];
    return [[CharacterResultViewModel alloc] initWithImageUrl:nil characterName:curretCharacter.name characterID:curretCharacter.characterId];
}

#pragma mark Private
-(void) setupSignals{
    
    _didUpdateResults = RACObserve(self, characters);
    
    [[[self fetchCharacterInfo] publish] connect];
    
}

-(RACSignal *) fetchCharacterInfo{
    
    @weakify(self);
    return [[[self.client fetchVolumeCharachtersWithId:self.characterID] deliverOnMainThread] map:^id(Response *response) {
        
        @strongify(self)
        Volume *vol = response.results;
        self.characters = vol.characters;

        
        return nil;
    }];
    
}


@end
