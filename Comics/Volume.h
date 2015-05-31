//
//  Volume.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/16/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Volume : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy, readonly) NSString *title;
@property(nonatomic, copy, readonly) NSArray *characters;




@end
