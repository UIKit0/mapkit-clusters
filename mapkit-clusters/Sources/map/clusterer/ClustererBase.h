
// BSD License. <jano@jano.com.es>

#import "Clusterer.h"
#import "AnnotationCluster.h"
#import "SimpleAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ClustererBase : NSObject

@property (nonatomic, retain) MKMapView *mapView;

-(GridSize) gridSizeForClusters:(int)numClusters;
-(id) initWithMap:(MKMapView*)aMapView;
-(NSMutableArray*) clusterCoordinatesForGrid:(GridSize)gridSize;
-(NSMutableArray*) clustersForGrid:(GridSize)gridSize;
    
@end
