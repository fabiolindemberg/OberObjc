//
//  HistoricViewController.m
//  Ober
//
//  Created by Fabio Lindemberg on 30/07/20.
//  Copyright © 2020 Fabio Lindemberg. All rights reserved.
//

#import "HistoricViewController.h"

@interface HistoricViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation HistoricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.historic = [[NSMutableArray<HistoricItem *> alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self configUI];
    
    [self.tbHistoric reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
}

#pragma mark - Custom Methods

- (void) configUI {
    
    [self.tbHistoric setTableFooterView: [UIView new]];
    [self.tbHistoric setBackgroundView: self.historic.count == 0 ? [self getNoDataView] : nil];
}

- (UIView*) getNoDataView {
    
    UILabel *label = [UILabel new];
    label.text = @"The historic is empty";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"historicItem"];
    
    HistoricItem *item = self.historic[indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.date;
    
    return cell;
}

@end
