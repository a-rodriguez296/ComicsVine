//
//  CharacterResultViewModel.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "CharacterResultViewModel.h"

@implementation CharacterResultViewModel


-(instancetype)initWithImageUrl:(NSURL *) imageURL characterName:(NSString *) characterName characterID:(NSString *) characterID{
    if (self = [super init]) {
        
        
        _imageURL = [imageURL copy];
        _characterName = [characterName copy];
        _characterID = [characterID copy];
    }
    return self;
}

@end
