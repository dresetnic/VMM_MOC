//
//  VMMailCell.m
//  VVM_MOC
//
//  Created by Dragos Resetnic on 02/07/14.
//  Copyright (c) 2014 DreamCraft. All rights reserved.
//

#import "VMMailCell.h"

@implementation VMMailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    
        
        _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playButton setFrame: CGRectMake(14, 68, 35, 35)];
        [_playButton setTintColor:[UIColor redColor]];
        [_playButton setTitle:@"►" forState:UIControlStateNormal];
        [[_playButton titleLabel] setFont:[UIFont boldSystemFontOfSize:20]];
        [[_playButton layer] setBorderWidth:2];
        [_playButton.layer setBorderColor:[UIColor redColor].CGColor];
        [self.contentView addSubview:_playButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
