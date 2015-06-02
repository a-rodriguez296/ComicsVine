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
             @"image1":@"image"};
}

+ (NSValueTransformer *)image1JSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Image class]];
}

@end
