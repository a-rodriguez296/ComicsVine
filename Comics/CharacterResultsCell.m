//
//  CharacterResultsCell.m
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import "CharacterResultsCell.h"
#import "CharacterResultViewModel.h"

@implementation CharacterResultsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) configureCellWithModel:(CharacterResultViewModel *) model{
    
    [self.lblCharacterName setText:model.characterName];
}
@end
