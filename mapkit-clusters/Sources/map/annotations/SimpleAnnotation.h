
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>

@interface SimpleAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end
