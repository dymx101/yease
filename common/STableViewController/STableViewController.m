//
// STableViewController.m
//
// @author Shiki
//

#import "STableViewController.h"
#import "AppDelegate.h"

#define DEFAULT_HEIGHT_OFFSET 50.0f

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation STableViewController

@synthesize tableView;
@synthesize headerView;
@synthesize footerView;

@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;

@synthesize canLoadMore;

@synthesize pullToRefreshEnabled;

@synthesize clearsSelectionOnViewWillAppear;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) initialize
{
    pullToRefreshEnabled = YES;
    
    canLoadMore = YES;
    
    clearsSelectionOnViewWillAppear = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *_AppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_AppDelegate.notifierView hide];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
    if ((self = [super init]))
        [self initialize];
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
        [self initialize];
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.separatorStyle = NO;
    
    
    //表头
    self.headerView = [[iHeaderView alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
    [tableView addSubview:self.headerView];
    //表尾
    
    self.footerView = [[iFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.canLoadMore=NO;
    
    
    
    [self.view addSubview:tableView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (clearsSelectionOnViewWillAppear) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        if (selected)
            [self.tableView deselectRowAtIndexPath:selected animated:animated];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) headerRefreshHeight
{
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
    }];
    
    [self.headerView.activityIndicator startAnimating];
    self.headerView.infoLabel.text = @"刷新中...";
    self.headerView.arrow.transform=CGAffineTransformMakeRotation(0);
    self.headerView.arrow.hidden=YES;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }];
    
    [self.headerView.activityIndicator stopAnimating];
    self.headerView.arrow.hidden=NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginRefresh
{
    if (pullToRefreshEnabled)
        [self pinHeaderView];
    
    [self setFooterViewVisibility:NO];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willShowHeaderView:(UIScrollView *)scrollView
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    if (willRefreshOnRelease)
    {
        self.headerView.infoLabel.text = @"松开立即刷新...";
        [UIView animateWithDuration:.2
                         animations:^{
                             self.headerView.arrow.transform=CGAffineTransformMakeRotation(M_PI);
                         }];
    }
    else
    {
        self.headerView.infoLabel.text = @"下拉可以刷新...";
        [UIView animateWithDuration:.2
                         animations:^{
                             self.headerView.arrow.transform=CGAffineTransformMakeRotation(0);
                         }];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) refresh
{
    if (isRefreshing||isLoadingMore)
        return NO;
    
    [self willBeginRefresh];
    isRefreshing = YES;
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshCompleted
{
    isRefreshing = NO;
    if (pullToRefreshEnabled)
        [self unpinHeaderView];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView
{
    if (!tableView)
        return;
    
    tableView.tableFooterView = nil;
    tableView.tableFooterView = footerView;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginLoadingMore
{
    [self.footerView.activityIndicator startAnimating];
    self.footerView.infoLabel.hidden=NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadMoreCompleted
{
    isLoadingMore = NO;
    
    [self.footerView.activityIndicator stopAnimating];
    self.footerView.infoLabel.hidden=YES;
    
    if (!self.canLoadMore) {
        // Do something if there are no more items to load
        
        [self setFooterViewVisibility:NO];
        
        // Just show a textual info that there are no more items to load
        self.footerView.infoLabel.hidden = NO;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
    if (isLoadingMore||isRefreshing)
        return NO;
    
    [self willBeginLoadingMore];
    isLoadingMore = YES;
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) footerLoadMoreHeight
{
    if (footerView)
        return footerView.frame.size.height;
    else
        return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterViewVisibility:(BOOL)visible
{
    if (visible && self.tableView.tableFooterView != footerView)
        self.tableView.tableFooterView = footerView;
    else if (!visible)
        self.tableView.tableFooterView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) allLoadingCompleted
{
    if (isRefreshing)
        [self refreshCompleted];
    if (isLoadingMore)
        [self loadMoreCompleted];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isRefreshing)
        return;
    isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isRefreshing && isDragging && scrollView.contentOffset.y < 0) {
        [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight]
                       scrollView:scrollView];
    } else if (!isLoadingMore && canLoadMore) {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        if (scrollPosition < [self footerLoadMoreHeight]) {
            [self loadMore];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isRefreshing)
        return;
    
    isDragging = NO;
    if (scrollView.contentOffset.y <= 0 - [self headerRefreshHeight]) {
        if (pullToRefreshEnabled)
            [self refresh];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) releaseViewComponents
{
    headerView = nil;
    footerView = nil;
    tableView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    [self releaseViewComponents];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload
{
    [self releaseViewComponents];
    [super viewDidUnload];
}

@end
