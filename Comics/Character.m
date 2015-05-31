//
//  Character.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/30/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "Character.h"
#import "Volume.h"

@implementation Character

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"name": @"name",
             @"characterId": @"id"};
}

+ (NSValueTransformer *)charactersJSONTransformer {

    return [MTLJSONAdapter arrayTransformerWithModelClass:[Volume class]];
}


@end
