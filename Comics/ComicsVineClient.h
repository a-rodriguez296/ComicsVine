//
//  ComicsVineClient.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  RACSignal;

@interface ComicsVineClient : NSObject


-(RACSignal *) fetchSuggestedVolumesWithQuery:(NSString *) query;

-(RACSignal *) fetchVolumesWithQuery:(NSString *) query page:(NSUInteger) page;
-(RACSignal *) fetchVolumeCharachtersWithId:(NSString *) volumeID;

@end
