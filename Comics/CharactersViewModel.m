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
#import "Character.h"
#import "Volume.h"
#import "Image.h"
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
    return [[CharacterResultViewModel alloc] initWithImageUrl:curretCharacter.image.imageURL characterName:curretCharacter.name characterID:curretCharacter.characterId];
}

#pragma mark Private
-(void) setupSignals{
    
    _didUpdateResults = RACObserve(self, characters);
    
    [[[self fetchCharacterInfo] publish] connect];
    
}

-(RACSignal *) fetchCharacterInfo{
    
    @weakify(self);
    return [[[[self.client fetchCharactersWithVolumeID:self.characterID]  map:^id(Response *response) {
        Volume *vol = response.results;
        return vol.characters;
    }] flattenMap:^id(NSArray * charactersArray) {
        
        NSMutableArray *idsArray = [NSMutableArray array];
        for (Character *currentCharacter in charactersArray) {
            [idsArray addObject:currentCharacter.characterId];
        }
        NSString *stringForQuery = [[idsArray valueForKey:@"description"] componentsJoinedByString:@"|"];
        
        @strongify(self);
        return [[self.client fetchCharactersInfoWithId:stringForQuery] deliverOnMainThread];
    }] doNext:^(Response *response) {
        
        @strongify(self);
        self.characters = response.results;
        
    }];
    
}


@end
