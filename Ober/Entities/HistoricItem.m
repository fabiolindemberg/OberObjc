//
//  Historic.m
//  Ober
//
//  Created by Fabio Lindemberg on 30/07/20.
//  Copyright © 2020 Fabio Lindemberg. All rights reserved.
//

#import "HistoricItem.h"

@implementation HistoricItem: NSObject

- (instancetype) initFromTitle:(NSString *)title date:(NSString *)date {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.date = date;
    }
    
    return self;
}
- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    
    if((self = [super init])) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
