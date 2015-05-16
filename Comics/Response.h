//
//  Response.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface Response : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy, readonly) NSNumber *statusCode;
@property(nonatomic, copy, readonly) NSString *errorMessage;
@property(nonatomic, copy, readonly) NSNumber *numberOfTotalResults;
@property(nonatomic, copy, readonly) NSNumber *offset;
@property(nonatomic, strong, readonly) id results;

+(instancetype) responseWithJsonDictionary:(NSDictionary *) JSONDictionary resultClass:(Class) resultClass;

-(NSError *) error;


@end
