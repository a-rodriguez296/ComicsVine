//
//  SearchResultsViewModel.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/17/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultsViewModel : NSObject

@property(nonatomic, copy, readonly) NSURL * imageURL;
@property(nonatomic, copy, readonly) NSString * title;
@property(nonatomic, copy, readonly) NSString *publisher;


-(instancetype)initWithImageUrl:(NSURL *) imageURL title:(NSString *) title publisher:(NSString *) publisher;

@end
