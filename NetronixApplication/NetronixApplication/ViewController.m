//
//  ViewController.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 16/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ViewController.h"

#import <EventSource.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSURL *serverURL = [NSURL URLWithString:@"https://jsdemo.envdev.io/sse"];
	EventSource *source = [EventSource eventSourceWithURL:serverURL];
	
	[source onOpen:^(Event *event) {
		NSLog(@"onOpen");
	}];

	[source onError:^(Event *event) {
		NSLog(@"onError: %@", event);
	}];
	
	[source onReadyStateChanged:^(Event *event) {
		NSLog(@"onReadyStateChanged: %@", event);
	}];
	
	
	[source onMessage:^(Event *event) {
//		NSLog(@"%@: %@\n\n", e.event, e.data);
		
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
