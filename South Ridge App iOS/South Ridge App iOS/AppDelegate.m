//
//  AppDelegate.m
//  South Ridge App iOS
//
//  Created by Kris Krause on 12/16/12.
//  Copyright (c) 2012 Kris Krause. All rights reserved.
//

#import "AppDelegate.h"

#import "PhotosViewController.h"
#import "AboutViewController.h"
#import "PodcastViewController.h"
#import "NewsViewController.h"
#import "VideoViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    AboutViewController *about;
    PhotosViewController *photos;
    PodcastViewController *podcasts;
    VideoViewController *videos;
    NewsViewController *news;
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        about = [[AboutViewController alloc] initWithNibName:@"AboutView_iPhone" bundle:nil];
        photos = [[PhotosViewController alloc] initWithNibName:@"PhotosView_iPhone" bundle:nil];
        podcasts = [[PodcastViewController alloc] initWithNibName:@"PodcastView_iPhone" bundle:nil];
        videos = [[VideoViewController alloc] initWithNibName:@"VideoView_iPhone" bundle:nil];
        news = [[NewsViewController alloc] initWithNibName:@"NewsView_iPhone" bundle:nil];
    } else {
        about = [[AboutViewController alloc] initWithNibName:@"AboutView_iPad" bundle:nil];
        photos = [[PhotosViewController alloc] initWithNibName:@"PhotosView_iPad" bundle:nil];
        podcasts = [[PodcastViewController alloc] initWithNibName:@"PodcastView_iPad" bundle:nil];
        videos = [[VideoViewController alloc] initWithNibName:@"VideoView_iPad" bundle:nil];
        news = [[NewsViewController alloc] initWithNibName:@"NewsView_iPad" bundle:nil];
    }
    
    about.tabBarItem.title = @"About Us";
    about.tabBarItem.image = [UIImage imageNamed:@"112-group.png"];
    
    photos.tabBarItem.title = @"Photos";
    photos.tabBarItem.image = [UIImage imageNamed:@"86-camera.png"];
    
    podcasts.tabBarItem.title = @"Podcasts";
    podcasts.tabBarItem.image = [UIImage imageNamed:@"31-ipod.png"];
    
    videos.tabBarItem.title = @"Videos";
    videos.tabBarItem.image = [UIImage imageNamed:@"70-tv.png"];
    
    news.tabBarItem.title = @"eNews";
    news.tabBarItem.image = [UIImage imageNamed:@"08-chat.png"];
    
    [tbc setViewControllers:[NSArray arrayWithObjects:photos, podcasts, videos, news, about, nil]];
    
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
