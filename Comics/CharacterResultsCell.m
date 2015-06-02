//
//  CharacterResultsCell.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "CharacterResultsCell.h"
#import "CharacterResultViewModel.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation CharacterResultsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) configureCellWithModel:(CharacterResultViewModel *) model{
    
    [self.lblCharacterName setText:model.characterName];
    [self.imgCharacter setImageWithURL:model.imageURL];
}


-(void)prepareForReuse{
    [super prepareForReuse];
    
    [self.imgCharacter cancelImageRequestOperation];
    [self.imgCharacter setImage:nil];
}
@end
