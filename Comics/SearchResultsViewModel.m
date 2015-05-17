//
//  SearchResultsViewModel.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "SearchResultsViewModel.h"

@implementation SearchResultsViewModel


-(instancetype)initWithImageUrl:(NSURL *) imageURL title:(NSString *) title publisher:(NSString *) publisher{
    if (self = [super init]) {
        
        
        _imageURL = [imageURL copy];
        _title = [title copy];
        _publisher = [publisher copy];
    }
    return self;
}

@end
