//
//  Image.h
//  Comics
//
//  Created by Alejandro Rodriguez on 6/1/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Image : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSString *stImage;
@property (nonatomic,copy)NSString *icon;

@end
