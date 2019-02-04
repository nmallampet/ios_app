//
//  ScheduleViewController.m
//  sda-mobile-app
//
//  Created by Evan Hughes on 2/4/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * View Controller implementation for Scheduled screen.
 *
 * @author Evan Hughes
 */

#import "ScheduleViewController.h"
#import "ScheduledModel.h"
#import "ScheduledCellView.h"
#import "NetworkManager.h"
#import "Helpers.h"

@interface ScheduleViewController ()

/**
 * An array containing scheduled events.
 */
@property (strong, nonatomic) NSArray *scheduledEvents;

/**
 * An array to load in scheduled events for certain time periods.
 * Initially intended to be a buffer, used in appropriate situations,
 * I don't believe this is being used widely throughout this view controller.
 */
@property (strong, nonatomic) NSArray *dailyScheduledEvents;

/**
 * The label displaying the number of events scheduled for a selected date/month.
 */
@property (weak, nonatomic) IBOutlet UILabel *numberScheduled;

/**
 * The label displaying the selected date/month.
 */
@property (weak, nonatomic) IBOutlet UILabel *dateSelected;

/**
 * A boolean to indicate whether or not the dateSelected label should 
 * display just the month, or the month and day (including weekday)
 */
@property bool justMonth;

/**
 * A boolean indicating whether or not the user has selected a specific date.
 */
@property bool selectedDate;
@end

@implementation ScheduleViewController

/**
 * This disables auto layout (or rather, makes the view unaware of auto layout).
 * Disabling this breaks this screen, a rather large problem we ran into during development.
 */
- (void) disableAutoLayout {
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
}

/**
 * This was intended to be a method called in order to lock the orientation
 * to portrait for this screen specifically. I couldn't find any decent solutions
 * online for doing this. This is a sort of hack that forces the device to portrait,
 * if you are in landscape and then navigate to the scheduled screen.
 * It does NOT, however, prevent orientation changes once on the scheduled screen,
 * something I was unable to figure out.
 */
- (void)lockPortraitOrientation {
    //Not sure this is okay to do. Must be a better way to lock orientation.
    //Forces orientation if in landscape and going to scheduled screen.
    //Does not prevent orientation change within scheduled screen.
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Called after the view has loaded.
 * Does setup for calendar and it's appearance.
 * Does general setup for screen.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableAutoLayout];
    self.scheduledEvents = [[NetworkManager getDataFor:scheduled
                                           withOptions:@{@"monthOffset": @0}]
                            valueForKey:STRINGIFY(scheduled)];
    self.dailyScheduledEvents = self.scheduledEvents; //TODO 5/31: what is this line doing?
    self.calendar = [JTCalendar new];
    self.calendar.calendarAppearance.dayCircleRatio = 1;
    self.calendar.calendarAppearance.ratioContentMenu = .5;
    self.calendar.calendarAppearance.weekDayTextColor = [UIColor blackColor];
    self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
        NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger dateSelectedIndex = comps.month;
        static NSDateFormatter *dateFormatter;
        if(!dateFormatter){
            dateFormatter = [NSDateFormatter new];
            dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
        }
        while(dateSelectedIndex <= 0){
            dateSelectedIndex += 12;
        }

        NSString *monthText = [[dateFormatter standaloneMonthSymbols][dateSelectedIndex - 1] capitalizedString];
        return [NSString stringWithFormat:@"%@ %ld", monthText, comps.year];
    };
    self.justMonth = true;
    [self updateDateLabelWithDate:[NSDate date] updateDateLabelWithString:@""];
    [self updateNumScheduled:[self.scheduledEvents count]];
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    [self addWeekdaysBackground];
    
}

/**
 * Method called to reload data when the next page (month) is loaded.
 */
- (void)calendarDidLoadNextPage {
    ALog(@"calendarDidLoadNextPage");
    self.selectedDate = false;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger now = [cal component:NSMonthCalendarUnit
                          fromDate:[NSDate date]];
    ALog(@"now: %ld", (long)now);
    NSInteger jtCalNow = [cal component:NSMonthCalendarUnit
                               fromDate:self.calendar.contentView.currentDate];
    ALog(@"calendar date: %ld", (long)jtCalNow);
    NSInteger monthDiff = jtCalNow - now;
    ALog(@"month diff: %ld", (long)monthDiff);
    self.scheduledEvents = [[NetworkManager getDataFor:scheduled
                                           withOptions:@{@"monthOffset": [NSNumber numberWithInteger:monthDiff]}]
                            valueForKey:STRINGIFY(scheduled)];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = self.calendar.calendarAppearance.calendar.timeZone;
    NSString *monthText = [[dateFormatter standaloneMonthSymbols][jtCalNow - 1] capitalizedString];
    [self updateDateLabelWithDate:nil updateDateLabelWithString:monthText];
    [self.tableView reloadData];
    [self.calendar reloadData];
}

/**
 * Method called to reload data when the previous page (month) is loaded.
 */
- (void)calendarDidLoadPreviousPage {
    ALog(@"calendarDidLoadPreviousPage");
    self.selectedDate = false;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger now = [cal component:NSMonthCalendarUnit
                        fromDate:[NSDate date]];
    ALog(@"now: %ld", (long)now);
    NSInteger jtCalNow = [cal component:NSMonthCalendarUnit
                               fromDate:self.calendar.contentView.currentDate];
    ALog(@"calendar date: %ld", (long)jtCalNow);
    NSInteger monthDiff = jtCalNow - now;
    ALog(@"month diff: %ld", (long)monthDiff);
    self.scheduledEvents = [[NetworkManager getDataFor:scheduled
                                           withOptions:@{@"monthOffset": [NSNumber numberWithInteger:monthDiff]}]
                            valueForKey:STRINGIFY(scheduled)];

    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = self.calendar.calendarAppearance.calendar.timeZone;
    NSString *monthText = [[dateFormatter standaloneMonthSymbols][jtCalNow - 1] capitalizedString];
    [self updateDateLabelWithDate:nil updateDateLabelWithString:monthText];
    [self.tableView reloadData];
    [self.calendar reloadData];
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Called after the view loads, before the view will appear.
 */
- (void) viewWillAppear:(BOOL)animated {
    [self lockPortraitOrientation];
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Called after the view appears.
 *
 * NOTE: I wanted to make the call to addPrevNextArrows
 *       in viewDidLoad, but they wouldn't show up, and I 
 *       never could figure out why.
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self lockPortraitOrientation];
    [self.calendar reloadData];
    [self addPrevNextArrows];
}

/**
 * Method called by the next button to load the previous
 * page (month) of the calendar.
 */
- (void) loadPrevPage {
    [self.calendar loadPreviousPage];
}

/**
 * Method called by the next button to load the next
 * page (month) of the calendar.
 */
- (void) loadNextPage {
    [self.calendar loadNextPage];
}

/**
 * Method that adds the previous and next arrows 
 * in the area of the calendarMenuView.
 * It also adds invisible buttons on top of the arrows
 * that can be used to go to the previous or next month 
 * instead of swiping.
 */
- (void) addPrevNextArrows {
    CGFloat nextArrowFrameX = self.view.frame.size.width-75;
    UIImage *prevImage = [[UIImage imageNamed:@"ic_action_previous_item"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImageView *prev1 = [[UIImageView alloc] initWithImage:prevImage];
    UIImageView *prev2 = [[UIImageView alloc] initWithImage:prevImage];
    UIImage *nextImage = [[UIImage imageNamed:@"ic_action_next_item"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImageView *next1 = [[UIImageView alloc] initWithImage:nextImage];
    UIImageView *next2 = [[UIImageView alloc] initWithImage:nextImage];
    
    
    UIButton *prevButton = [[UIButton alloc] init];
    UIButton *nextButton = [[UIButton alloc] init];
    [prevButton addTarget:self action:@selector(loadPrevPage) forControlEvents:UIControlEventTouchUpInside];
    [prevButton.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [nextButton addTarget:self action:@selector(loadNextPage) forControlEvents:UIControlEventTouchUpInside];
    [nextButton.layer setBackgroundColor:[UIColor clearColor].CGColor];
    
    
    UIView *arrowView = [[UIView alloc] init];
    
    arrowView.frame = self.calendarMenuView.frame;
    prev1.frame = CGRectMake(0, 0, 32, 32);
    prev2.frame = CGRectMake(8, 0, 32, 32);
    next1.frame = CGRectMake(nextArrowFrameX, 0, 32, 32);
    next2.frame = CGRectMake(nextArrowFrameX - 8, 0, 32, 32);
    
    CGRect prevButtonFrame = self.calendarMenuView.frame;
    CGRect nextButtonFrame = self.calendarMenuView.frame;
    prevButtonFrame.size.width = 32;
    nextButtonFrame.size.width = 32;
    prevButtonFrame.size.height = 32;
    nextButtonFrame.size.height = 32;
    nextButtonFrame.origin.x = nextArrowFrameX + 8;
    
    prevButton.frame = prevButtonFrame;
    nextButton.frame = nextButtonFrame;
    [self.view addSubview:prevButton];
    [self.view addSubview:nextButton];

    [arrowView addSubview:prev1];
    [arrowView addSubview:prev2];
    [arrowView addSubview:next1];
    [arrowView addSubview:next2];

    [self.view addSubview:arrowView];
    [self.view sendSubviewToBack:arrowView];
}

/**
 * Method that adds the gray bar and blue line highlighting the
 * days of the week on the calendar.
 */
- (void) addWeekdaysBackground {
    UIView *background= [[UIView alloc] init];
    CGRect bgFrame = self.calendarContentView.frame;
    bgFrame.size.width = self.view.frame.size.width;
    bgFrame.size.height = 20;
    background.frame = bgFrame;
    background.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    UIView *backgroundLine = [[UIView alloc] init];
    CGRect bglFrame = background.frame;
    bglFrame.size.height = bgFrame.size.height + 3;
    backgroundLine.frame = bglFrame;
    backgroundLine.backgroundColor = [UIColor colorWithRed:0.518 green:0.816 blue:0.925 alpha:1];
    [self.view addSubview:background];
    [self.view addSubview:backgroundLine];
    [self.view sendSubviewToBack:background];
    [self.view sendSubviewToBack:backgroundLine];
}

/**
 * Method called to update the dateSelected label.
 * Because some methods need to pass an NSDate,
 * and others an NSString, the method takes both,
 * and checks if the NSDate is nil or the NSString is empty,
 * and updates the opposite.
 * 
 * @params date - an NSDate which needs to be converted to string
 * @params string - string with which the label should be updated
 */
- (void) updateDateLabelWithDate:(NSDate *) date
       updateDateLabelWithString:(NSString* ) string{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    if(date == nil && ![string isEqualToString:@""]){
        self.dateSelected.text = [NSString stringWithFormat:@"  %@", string];
    } else if ([string isEqualToString:@""]){
        if(self.justMonth){
            [dateFormat setDateFormat:@"  LLLL"];
        } else {
            [dateFormat setDateFormat:@"  LLLL, EEE - d"];
        }
        NSString *dateString = [dateFormat stringFromDate:date];
        self.dateSelected.text = dateString;
    }
   
}

/**
 * Method called to update the numberScheduled label.
 *
 * @params numScheduled - the number which to display on the label
 */
- (void) updateNumScheduled:(NSInteger) numScheduled {
    self.numberScheduled.text = [NSString stringWithFormat:@"Scheduled: %lu", numScheduled];
}

/**
 * This is a JTCalendar method. Called for each day displayed on the calendar. 
 * If it returns YES, then a dot is drawn on that date indicating there are events
 * on that day.
 *
 * I have since customzied the JTCalendar to display a gray rectangle instead of a 
 * small dot to indicate events.
 */
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    for (ScheduledModel *i in self.scheduledEvents) {
        if([dateString isEqualToString:i.scheduledOn]){
            return YES;
        }
    }
    return NO;
}


/**
 * This is a JTCalendar method. Called when a date is selected (touched) on the calendar.
 * Here we update the labels displaying what date is selected and how many events are 
 * scheduled for that date.
 */
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {
    self.dailyScheduledEvents = self.scheduledEvents;
    NSMutableArray *schedEvents = [NSMutableArray new];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    for (ScheduledModel *i in self.scheduledEvents) {
        if([dateString isEqualToString:i.scheduledOn]){
            ALog(@"events scheduled for this day!");
            [schedEvents addObject:i];
        }
    }
    self.dailyScheduledEvents = schedEvents;
    ALog(@"%lu events scheduled for this day", [self.dailyScheduledEvents count]);
    self.justMonth = false;
    self.selectedDate = true;
    [self updateDateLabelWithDate:date updateDateLabelWithString:@""];
    [self updateNumScheduled:[schedEvents count]];
    [self.tableView reloadData];
}

/**
 * All table view methods make a check to super to see if the tableview is
 * actually the overflow menu and not the desired tableView.
 * If it is the overflow menu, we call the overflow menu's tableView method instead.
 */

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Populates tableView's cell at indexPath with appropriate information.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    NSString *cellId = @"ScheduledTableCell";
    ScheduledCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    ScheduledModel *model = self.dailyScheduledEvents[indexPath.row];
    if(self.selectedDate){
        cell.nameLabel.text = model.name;
        cell.environmentLabel.text = model.environment;
        cell.processLabel.text = [@"Process: " stringByAppendingFormat:@"%@", model.process];
        cell.scheduledOnLabel.text = [@"Scheduled On: " stringByAppendingFormat:@"%@", model.scheduledOn];
        cell.versionLabel.text = [@"Version: " stringByAppendingFormat:@"%@", model.version];
        
    } else {
        cell.nameLabel.text = model.name;
        cell.environmentLabel.text = model.environment;
        cell.processLabel.text = [@"Process: " stringByAppendingFormat:@"%@", model.process];
        cell.scheduledOnLabel.text = [@"Scheduled On: " stringByAppendingFormat:@"%@", model.scheduledOn];
        cell.versionLabel.text = [@"Version: " stringByAppendingFormat:@"%@", model.version];
    }
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    ALog(@"scheduledEvents: %@", self.scheduledEvents);
    return cell;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Sets action for each cell in provided tableView at provided indexPath.
 *
 * INCOMPLETE - Should probable reference the Status or Action Items
 * screens for info on how to approach expanding or collapsing of 
 * table cells.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        
    }
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Sets number of rows in provided tableview.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    NSInteger count;
    if(self.selectedDate){
        count = [self.dailyScheduledEvents count];
    } else {
        count = [self.scheduledEvents count];
    }
    [self updateNumScheduled:count];
    if(count > 0)
        return count;
    CGRect noDataFrame = CGRectMake(0, 0, 300, 100);
    UIView *noData = [[UIView alloc] initWithFrame:noDataFrame];
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:noDataFrame];
    [noData addSubview: noDataLabel];
    noDataLabel.text = @"   No records found.";
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.numberOfLines = 0;
    self.tableView.backgroundView = noData;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return count;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Dictates the height of each cell in provided tableView at provided indexPath.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 170;
}

@end
