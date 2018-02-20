//
//  ViewController.h
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 16/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *_measurementsTableView;
}


@end

