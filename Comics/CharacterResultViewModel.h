//
//  CharacterResultViewModel.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterResultViewModel : NSObject

@property(nonatomic, copy, readonly) NSURL * imageURL;
@property(nonatomic, copy, readonly) NSString * characterName;
@property(nonatomic, copy, readonly) NSString * characterID;

-(instancetype)initWithImageUrl:(NSURL *) imageURL characterName:(NSString *) characterName characterID:(NSString *) characterID;


@end
