//
//  CharacterResultsCell.h
//  Comics
//
//  Created by Alejandro Rodriguez on 5/31/15.
//  Copyright (c) 2015 Alejandro Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CharacterResultViewModel;

@interface CharacterResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCharacter;
@property (weak, nonatomic) IBOutlet UILabel *lblCharacterName;

-(void) configureCellWithModel:(CharacterResultViewModel *) model;


@end
