
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnnotationClusterView.h"
#import "AnnotationSource.h"
#import "AnnotationView.h"
#import "Clusterer.h"
#import "GridClusterer.h"
#import "KMeansClusterer.h"
#import "MapView.h"

@interface MapVC : UIViewController <MKMapViewDelegate>

// elements of the interface
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) IBOutlet MapView *mapView;

@property (nonatomic, retain) NSObject <Clusterer> *clusterer;

// last selected annotation cluster
@property (nonatomic, retain) AnnotationCluster *lastSelectedAnnotationCluster;

// last selected annotation
@property (nonatomic, retain) Annotation *lastSelectedAnnotation;


@end


@interface MapVC (PrivateMethods)
-(void) initializeMap;    
@end