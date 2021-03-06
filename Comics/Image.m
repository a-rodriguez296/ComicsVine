//
//  Image.m
//  Comics
//
//  Created by Alejandro Rodriguez on 6/1/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "Image.h"

@implementation Image

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"imageURL":@"small_url"};
}

+ (NSValueTransformer *)imageURLJSONTransformer{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
