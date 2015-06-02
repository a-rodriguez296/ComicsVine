//
//  Image.h
//  Comics
//
//  Created by Alejandro Rodriguez on 6/1/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel.h"

@interface Image : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSURL *imageURL;

@end
