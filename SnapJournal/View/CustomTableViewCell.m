//
//  CustomTableViewCell.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:25];
    self.titleLabel.textColor = [UIColor blackColor];
    self.detailLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    self.detailLabel.textColor = [UIColor blackColor];
    self.dateLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:16];
    self.dateLabel.textColor = [UIColor blackColor];
    self.locationLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    self.locationLabel.textColor = [UIColor blackColor];
    self.tempLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    self.tempLabel.textColor = [UIColor blackColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
