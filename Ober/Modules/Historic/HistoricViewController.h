//
//  HistoricViewController.h
//  Ober
//
//  Created by Fabio Lindemberg on 30/07/20.
//  Copyright © 2020 Fabio Lindemberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoricItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoricViewController : UIViewController

@property NSMutableArray<HistoricItem*>* historic;
@property (weak, nonatomic) IBOutlet UITableView *tbHistoric;
@end

NS_ASSUME_NONNULL_END
