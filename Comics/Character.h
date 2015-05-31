//
//  Character.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/30/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//
#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface Character : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSString *characterId;

@end
