//
//  Volume.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "Volume.h"
#import "Character.h"

@implementation Volume

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"title": @"name",
             @"characters": @"characters"};
}

+ (NSValueTransformer *)charactersJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Character class]];
}

@end
