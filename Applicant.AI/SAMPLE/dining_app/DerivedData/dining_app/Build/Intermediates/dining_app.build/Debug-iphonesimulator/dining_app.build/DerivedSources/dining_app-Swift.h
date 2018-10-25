// Generated by Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import Foundation;
@import CoreLocation;
@import MapKit;
@import CoreGraphics;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;

SWIFT_CLASS("_TtC10dining_app11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions SWIFT_WARN_UNUSED_RESULT;
- (void)showAlert;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
- (void)application:(UIApplication * _Nonnull)application performFetchWithCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class DiningLocation;
@class UIColor;
@class UITableView;
@class UITableViewCell;
@class UIStoryboardSegue;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC10dining_app26CoursesTableViewController")
@interface CoursesTableViewController : UITableViewController
@property (nonatomic, strong) DiningLocation * _Null_unspecified atDiningHall;
@property (nonatomic, readonly, strong) UIColor * _Nonnull green;
@property (nonatomic, readonly, strong) UIColor * _Nonnull red;
@property (nonatomic, readonly, strong) UIColor * _Nonnull orange;
@property (nonatomic, copy) NSString * _Nonnull notServing;
@property (nonatomic, copy) NSString * _Nonnull servingMeal;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull favoriteMenuItems;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)reloadTableView;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;

SWIFT_CLASS("_TtC10dining_app34CustomClosestLocationTableViewCell")
@interface CustomClosestLocationTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified closest_dining_distance;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified closest_dining_name;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10dining_app25CustomCourseTableViewCell")
@interface CustomCourseTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified Menu_Item_Price;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified Menu_Item_Name;
- (void)awakeFromNib;
- (void)layoutSubviews;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIButton;

SWIFT_CLASS("_TtC10dining_app33CustomDiningHallCellTableViewCell")
@interface CustomDiningHallCellTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified OpenNow;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified DiningName;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified DiningType;
@property (nonatomic, readonly, strong) UIColor * _Nonnull green;
@property (nonatomic, readonly, strong) UIColor * _Nonnull red;
@property (nonatomic, readonly, strong) UIColor * _Nonnull yellow;
@property (nonatomic, readonly, strong) UIColor * _Nonnull grey;
@property (nonatomic, strong) UIButton * _Nullable accessoryButton;
- (void)awakeFromNib;
- (void)layoutSubviews;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class CLLocation;
@class CLLocationManager;
@class CustomPointAnnotation;
@class MKPinAnnotationView;
@class MKMapView;
@protocol MKAnnotation;
@class MKAnnotationView;
@class UIControl;

SWIFT_CLASS("_TtC10dining_app26CustomMapCellTableViewCell")
@interface CustomMapCellTableViewCell : UITableViewCell <CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) CLLocation * _Nonnull currentLocation;
@property (nonatomic, strong) CLLocationManager * _Nonnull locationmManager;
@property (nonatomic, readonly) CLLocationDistance regionRadius;
@property (nonatomic, copy) NSArray<DiningLocation *> * _Nonnull diningLocations;
@property (nonatomic, strong) CustomPointAnnotation * _Null_unspecified pointAnnotation;
@property (nonatomic, strong) MKPinAnnotationView * _Null_unspecified pinAnnotationView;
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified map;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)centerMapOnLocationWithCenterLocation:(CLLocation * _Nonnull)centerLocation;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
- (MKAnnotationView * _Nullable)mapView:(MKMapView * _Nonnull)mapView viewForAnnotation:(id <MKAnnotation> _Nonnull)annotation SWIFT_WARN_UNUSED_RESULT;
- (void)mapView:(MKMapView * _Nonnull)mapView annotationView:(MKAnnotationView * _Nonnull)view calloutAccessoryControlTapped:(UIControl * _Nonnull)control;
- (void)addAllPins;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10dining_app21CustomPointAnnotation")
@interface CustomPointAnnotation : MKPointAnnotation
@property (nonatomic, strong) UIColor * _Nonnull pinColor;
- (nonnull instancetype)initWithPinColor:(UIColor * _Nonnull)pinColor OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UIBarButtonItem;

SWIFT_CLASS("_TtC10dining_app31DiningHalls_TableViewController")
@interface DiningHalls_TableViewController : UITableViewController <CLLocationManagerDelegate>
@property (nonatomic, copy) NSArray<DiningLocation *> * _Nonnull diningLocations;
@property (nonatomic, copy) NSArray<DiningLocation *> * _Nonnull locationsByDistance;
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> * _Nonnull nameToDistance;
@property (nonatomic, strong) CLLocation * _Nonnull currentLocation;
@property (nonatomic, strong) CLLocationManager * _Nonnull locationManager;
@property (nonatomic, copy) NSString * _Nonnull sortedBy;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull favorites;
@property (nonatomic, weak) IBOutlet UIBarButtonItem * _Null_unspecified filter;
- (IBAction)filterAction:(UIBarButtonItem * _Nonnull)sender;
- (void)viewDidLoad;
- (void)reloadTableView;
- (void)updateNameToDistance;
- (void)toggleFilter;
- (void)sortDistance;
- (void)sortName;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/// Represents a dining location on campus (e.g., Java Blue café in East Quad
/// or East Quad Dining Hall)
SWIFT_CLASS("_TtC10dining_app14DiningLocation")
@interface DiningLocation : NSObject <NSCoding>
/// Name of dining location
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
/// ID of dining location, used to uniquely identify it
/// (e.g., in an API request or when saving favorites)
@property (nonatomic, readonly, copy) NSString * _Nonnull id;
/// Geographical coordinate of dining location
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
/// Regular open hours of this dining location, represented as an array of strings,
/// where each string is a new line of text
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nonnull hours;
/// Regular open hours of this dining location, represented as an array of dictionaries,
/// where each element in the array is a dictionary corresponding to each day of the week
/// (element at index 0 is dictionary corresponding to Sunday)
/// Each dictionary has…
/// keys that are strings representing the description of the event (e.g., “Brunch”)
/// and values that represent open times for that event (e.g., “10:30 AM – 2 PM”)
@property (nonatomic, readonly, copy) NSArray<NSDictionary<NSString *, NSString *> *> * _Nonnull detailedHours;
/// Contact phone number for this dining location
@property (nonatomic, readonly, copy) NSString * _Nullable contactPhone;
/// Contact email address for this dining location
@property (nonatomic, readonly, copy) NSString * _Nullable contactEmail;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
/// Textual representation of the dining location object that shows its name
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class MenuItem;

SWIFT_CLASS("_TtC10dining_app28FavoritesTableViewController")
@interface FavoritesTableViewController : UITableViewController
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull favoriteDiningHalls;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull favoriteMenuItems;
@property (nonatomic, copy) NSArray<MenuItem *> * _Nonnull favoriteMenuItemsServedToday;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull favoriteMenuItemsServedTodayStrs;
@property (nonatomic, weak) IBOutlet UIBarButtonItem * _Null_unspecified clearButton;
- (IBAction)clear:(UIBarButtonItem * _Nonnull)sender;
- (void)viewDidLoad;
- (void)reloadTableView;
- (void)clear;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (BOOL)tableView:(UITableView * _Nonnull)tableView canEditRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView moveRowAtIndexPath:(NSIndexPath * _Nonnull)fromIndexPath toIndexPath:(NSIndexPath * _Nonnull)to;
- (BOOL)tableView:(UITableView * _Nonnull)tableView canMoveRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)findAndSendNotifications;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10dining_app16MapTableViewCell")
@interface MapTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified map;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/// Represents a single menu item (e.g. Mac and Cheese)
SWIFT_CLASS("_TtC10dining_app8MenuItem")
@interface MenuItem : NSObject <NSCoding>
/// Name of the menu item (e.g., <code>"Mac and Cheese"</code>)
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
/// Optional string representing the URL of the image of this menu item.
/// Most menu items do not have an image, but many menu items in the cafés do.
@property (nonatomic, readonly, copy) NSString * _Nullable imageURL;
/// Description of the menu item, such as its contents
@property (nonatomic, readonly, copy) NSString * _Nullable infoLabel;
/// Array of allergens, such as milk
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nonnull allergens;
/// Array of special markers, such as deep fried
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nonnull markers;
/// Optional string describing the serving size (e.g., 1 slice)
@property (nonatomic, readonly, copy) NSString * _Nullable servingSize;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/// Textual representation of nutrition fact object that shows its name
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UIImageView;
@class NSURLResponse;

SWIFT_CLASS("_TtC10dining_app27MenuItemTableViewController")
@interface MenuItemTableViewController : UITableViewController
@property (nonatomic, strong) MenuItem * _Null_unspecified selectedMenuItem;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) BOOL addedToHealthKit;
@property (nonatomic, readonly, copy) NSString * _Nonnull api_key;
@property (nonatomic, readonly, copy) NSString * _Nonnull flickr_url;
@property (nonatomic, readonly, copy) NSString * _Nonnull search_method;
@property (nonatomic, readonly, copy) NSString * _Nonnull format;
@property (nonatomic, readonly) NSInteger json_callback;
@property (nonatomic, readonly) NSInteger privacy_level;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified mainImg;
- (void)viewDidLoad;
- (void)updateFavorite;
- (void)moreInfo;
- (void)downloadImageWithUrl:(NSURL * _Nonnull)url;
- (void)getDataFromUrlWithUrl:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completion;
- (void)getFlickrPhoto:(NSString * _Nonnull)search_text;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)toggleFavorite;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10dining_app27MoreInfoTableViewController")
@interface MoreInfoTableViewController : UITableViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) CustomPointAnnotation * _Null_unspecified pointAnnotation;
@property (nonatomic, strong) MKPinAnnotationView * _Null_unspecified pinAnnotationView;
@property (nonatomic, copy) NSString * _Nonnull menuItem;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull locationsServed;
@property (nonatomic, copy) NSString * _Nonnull closestServed;
@property (nonatomic, copy) NSArray<MKPointAnnotation *> * _Nonnull mapAnnotations;
@property (nonatomic, readonly) CLLocationDistance regionRadius;
@property (nonatomic, strong) CLLocationManager * _Nonnull locationManager;
@property (nonatomic, strong) CLLocation * _Nonnull currentLocation;
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified map;
- (void)viewDidLoad;
- (void)centerMapOnLocationWithCenterLocation:(CLLocation * _Nonnull)centerLocation;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (void)findAllDiningHallsWithMeal:(NSString * _Nonnull)meal;
- (void)displayAllDiningHalls;
- (void)highLightClosestRow;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
- (MKAnnotationView * _Nullable)mapView:(MKMapView * _Nonnull)mapView viewForAnnotation:(id <MKAnnotation> _Nonnull)annotation SWIFT_WARN_UNUSED_RESULT;
- (void)mapView:(MKMapView * _Nonnull)mapView annotationView:(MKAnnotationView * _Nonnull)view calloutAccessoryControlTapped:(UIControl * _Nonnull)control;
- (void)openMapForPlaceWithLocation:(NSString * _Nonnull)location;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSNumber (SWIFT_EXTENSION(dining_app))
@property (nonatomic, readonly) BOOL isBool;
@end


SWIFT_CLASS("_TtC10dining_app23SearchItemTableViewCell")
@interface SearchItemTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified dining_name;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified subTitle;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UISearchController;
@class UISegmentedControl;

SWIFT_CLASS("_TtC10dining_app25SearchTableViewController")
@interface SearchTableViewController : UITableViewController <CLLocationManagerDelegate>
@property (nonatomic, copy) NSArray<DiningLocation *> * _Nonnull diningLocations;
@property (nonatomic, strong) DiningLocation * _Null_unspecified randomDiningLocation;
@property (nonatomic, strong) DiningLocation * _Null_unspecified closestDiningLocation;
@property (nonatomic) double closestDiningDistance;
@property (nonatomic, strong) CLLocation * _Nonnull currentLocation;
@property (nonatomic, strong) CLLocationManager * _Nonnull locationManager;
@property (nonatomic, readonly, strong) UISearchController * _Nonnull searchController;
@property (nonatomic, copy) NSArray<DiningLocation *> * _Nonnull filteredLocations;
@property (nonatomic, copy) NSDictionary<NSString *, NSArray<NSString *> *> * _Nonnull filteredMenuItems;
@property (nonatomic, copy) NSArray<MenuItem *> * _Nonnull arrayForDict;
@property (nonatomic, copy) NSString * _Nonnull mealChosen;
@property (nonatomic, copy) NSString * _Nonnull nameToPass;
@property (nonatomic, weak) IBOutlet UISegmentedControl * _Null_unspecified mealSelection;
- (IBAction)mealChoice:(UISegmentedControl * _Nonnull)sender;
- (void)viewDidLoad;
- (void)reloadTableView;
- (void)filterContentForSearchTextWithSearchText:(NSString * _Nonnull)searchText scope:(NSString * _Nonnull)scope;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)openMapForPlace;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (void)findNearestDiningLocation;
- (void)callSegueFromCellWithMyData:(NSString * _Nonnull)dataobject;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface SearchTableViewController (SWIFT_EXTENSION(dining_app)) <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController * _Nonnull)searchController SWIFT_AVAILABILITY(ios,introduced=8.0);
@end

@class UIActivityIndicatorView;

SWIFT_CLASS("_TtC10dining_app30Specific_Dining_ViewController")
@interface Specific_Dining_ViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) DiningLocation * _Null_unspecified selectedDiningLocation;
@property (nonatomic, strong) UITableView * _Nonnull tableView;
@property (nonatomic) NSInteger defaultDay;
@property (nonatomic, copy) NSString * _Nonnull selectedDiningName;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) NSInteger capacity;
@property (nonatomic) NSInteger occupancy;
@property (nonatomic) BOOL noMeals;
@property (nonatomic) BOOL noMealFilled;
@property (nonatomic) BOOL noneHaveMeals;
@property (nonatomic) BOOL noMealTextSet;
@property (nonatomic) BOOL isUpdatingData;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic) BOOL isFav;
@property (nonatomic, readonly, copy) NSDate * _Nonnull date;
@property (nonatomic, readonly, copy) NSCalendar * _Nonnull calendar;
@property (nonatomic, copy) NSDate * _Nonnull day1;
@property (nonatomic, copy) NSDate * _Nonnull day2;
@property (nonatomic, copy) NSDate * _Nonnull day3;
@property (nonatomic, copy) NSDate * _Nonnull day4;
@property (nonatomic, copy) NSDate * _Nonnull day5;
@property (nonatomic, copy) NSDate * _Nonnull day6;
@property (nonatomic, copy) NSDate * _Nonnull day7;
@property (nonatomic, copy) NSArray<NSDate *> * _Nonnull days;
@property (nonatomic) BOOL tableHidden;
@property (nonatomic, strong) UIActivityIndicatorView * _Nonnull indicator;
@property (nonatomic, readonly, strong) UIColor * _Nonnull blue;
@property (nonatomic, readonly, strong) UIColor * _Nonnull red;
@property (nonatomic, readonly, copy) NSString * _Nonnull reuseCellIdentifier;
@property (nonatomic, readonly, copy) NSString * _Nonnull reuseCellIdentifier2;
@property (nonatomic, readonly, copy) NSString * _Nonnull reuseCellIdentifier3;
@property (nonatomic, readonly, copy) NSString * _Nonnull reuseCellIdentifier4;
@property (nonatomic, readonly, copy) NSString * _Nonnull reuseCellIdentifier5;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified mainImg;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified dateLabel;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal6;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal5;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal4;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal3;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal2;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal1;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified cal0;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified favIcon;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum6;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum5;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum4;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum3;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum2;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum1;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified calNum0;
- (IBAction)chooseDay6:(UIButton * _Nonnull)sender;
- (IBAction)chooseDay5:(UIButton * _Nonnull)sender;
- (IBAction)chooseDay4:(UIButton * _Nonnull)sender;
- (IBAction)chooseDay3:(UIButton * _Nonnull)sender;
- (IBAction)chooseDay2:(UIButton * _Nonnull)sender;
- (IBAction)chooseDay1:(UIButton * _Nonnull)sender;
- (IBAction)chooseDay0:(UIButton * _Nonnull)sender;
- (void)viewDidLoad;
- (void)updateFavorite;
- (void)continueInit;
- (void)activityIndicator;
- (void)disableTouch;
- (void)enableTouch;
- (void)setDefaultColorWithDef:(NSInteger)def sender:(NSInteger)sender;
- (void)initTitleColors SWIFT_METHOD_FAMILY(none);
- (void)initButtonsLabelsAndBackgrounds SWIFT_METHOD_FAMILY(none);
- (void)setDaysOfWeekWithDay:(NSInteger)Day;
- (void)updateDateLabelWithNum:(NSInteger)Num;
- (void)setCalBackgroundWithImage:(NSInteger)Image;
- (void)updateMealsWithNum:(NSInteger)Num;
- (void)filterMeals;
- (void)finishUpdateWithNum:(NSInteger)Num;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)openMapForPlace;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)toggleFavorite;
- (void)didReceiveMemoryWarning;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10dining_app19TraitsTableViewCell")
@interface TraitsTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified traitsLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UILabel (SWIFT_EXTENSION(dining_app))
- (void)addImageWithImageName:(NSString * _Nonnull)imageName afterLabel:(BOOL)bolAfterLabel;
- (void)removeImage;
@end


@interface UITabBar (SWIFT_EXTENSION(dining_app))
- (CGSize)sizeThatFits:(CGSize)size SWIFT_WARN_UNUSED_RESULT;
@end

#pragma clang diagnostic pop