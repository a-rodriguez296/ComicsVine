//
//  ComicsVineClient.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "ComicsVineClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"
#import "Response.h"

@interface ComicsVineClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation ComicsVineClient


- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.comicvine.com/api"]];
    }
    return self;
}

-(RACSignal *) fetchSuggestedVolumesWithQuery:(NSString *) query{
    
    
    NSDictionary *parameters = @{@"api_key":APIKey,
                                 @"format": format,
                                 @"field_list":@"name",
                                 @"limit":@10,@"page":@1,
                                 @"query":query,
                                 @"resources":@"volume"};
    
    
    return [self GET:@"search" parameters:parameters resultClass:Nil];
}


#pragma mark Private Methods

-(RACSignal *) GET:(NSString *) path parameters:(NSDictionary *) parameters {
    
    

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        

        AFHTTPRequestOperation * operation = [self.requestManager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        
        
        //Cuando el subscriber muera, se ejecuta el metodo [operation cancel]
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}


-(RACSignal *) GET:(NSString *) path parameters:(NSDictionary *) parameters resultClass:(Class) resultClass{
    return [[self GET:path parameters:parameters] map:^id(NSDictionary *JSONDictionary) {
        return [Response responseWithJsonDictionary:JSONDictionary resultClass:resultClass];
    }];
}

@end