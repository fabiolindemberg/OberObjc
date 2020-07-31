//
//  Historic.h
//  Ober
//
//  Created by Fabio Lindemberg on 30/07/20.
//  Copyright © 2020 Fabio Lindemberg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoricItem : NSObject <NSCoding>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *date;

- (instancetype) initFromTitle: (NSString *) title
                          date: (NSString *) date;
@end

NS_ASSUME_NONNULL_END
