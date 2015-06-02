//
//  Character.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/30/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "Character.h"
#import "Image.h"


@implementation Character

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"name": @"name",
             @"characterId": @"id",
             @"image":@"image"};
}

+ (NSValueTransformer *)imageJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Image class]];
}

@end
