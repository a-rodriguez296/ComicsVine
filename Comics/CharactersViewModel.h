//
//  CharactersViewModel.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharacterResultViewModel;
@class RACSignal;

@interface CharactersViewModel : NSObject


@property (nonatomic, copy) NSString *characterID;
@property(nonatomic, strong, readonly) RACSignal *didUpdateResults;
@property(nonatomic, readonly) NSUInteger numberOfResults;



- (instancetype)initWithCharacterID:(NSString *) characterID;
-(CharacterResultViewModel *) resultAtIndex:(NSUInteger) integer;


@end
