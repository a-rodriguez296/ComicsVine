//
//  Response.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "Response.h"

@interface Response ()

@property (nonatomic, strong) id results;

@end


@implementation Response

+(instancetype) responseWithJsonDictionary:(NSDictionary *) JSONDictionary resultClass:(Class) resultClass{
    
    //Acá se hacer el parseo de los atributos propios de esta clase. V.gr statusCode, errorMessage, etc
    Response * response = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:JSONDictionary error:NULL];
    
    //Acá se hace el parseo de los atributos que no son propios de esta clase. En este caso resultClass es Volume.
    id results = JSONDictionary[@"results"];
    
    if (resultClass != Nil) {
        if ([results isKindOfClass:[NSArray class]]) {
            response.results = [MTLJSONAdapter modelsOfClass:resultClass fromJSONArray:results error:NULL];
        }
        else{
            response.results = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:results error:NULL];
        }
    }
    else{
        response.results = results;
    }
    
    
       return response;
}

-(NSError *)error{
    if (self.statusCode.integerValue == 1) {
        return nil;
    }
    
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: self.errorMessage};
    return [NSError errorWithDomain:@"ComicVineErrorDomain" code:self.statusCode.integerValue userInfo:userInfo];
}



#pragma mark MTLJSONSerializing

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"statusCode":@"status_code",
             @"errorMessage":@"error",
             @"numberOfTotalResults":@"number_of_total_results",
             @"offset":@"offset"};
    
}
@end
