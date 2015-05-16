//
//  Response.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "Response.h"

@implementation Response

+(instancetype) responseWithJsonDictionary:(NSDictionary *) JSONDictionary resultClass:(Class) resultClass{
    
    Response * response = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:JSONDictionary error:NULL];
    
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
