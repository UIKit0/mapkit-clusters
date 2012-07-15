
// BSD License. <jano@jano.com.es>

#import "MapVC.h"

@implementation MapVC

@synthesize mapView=mapView_;
@synthesize navigationItem=navigationItem_;
@synthesize clusterer;

@synthesize lastSelectedAnnotationCluster, lastSelectedAnnotation;


/**
 * Initialize the map.
 *
 * It sets the center in Puerta del Sol and loads the annotations for the visible area.
 * Only called from viewDidLoad.
 */
-(void) initializeMap 
{    
    // center map in Puerta del Sol with a span of 0.15 x 0.15 degrees
    MKCoordinateRegion region = { { 40.4308122f, -3.7033481f }, { 0.15f, 0.15f } };
    [self.mapView setRegion:region animated:YES];
    
    // create random Annotations
    NSMutableArray *annotations = [AnnotationSource annotationsForRegion:region number:50];
    NSMutableArray *clusteredAnnotations = [self.clusterer clusterAnnotations:annotations inNumClusters:12];
    [self.mapView addAnnotations:clusteredAnnotations];
}


#pragma mark - MKMapViewDelegate


/** Called when one or more annotation views are added to the map. */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    debug(@"mapView:didAddAnnotationViews:");
    for (UIView *view in views){

        // CLUSTER ADDED
        if ([view isKindOfClass:[AnnotationClusterView class]]){
            // copy the spawn point to its children
            // TODO: this is wrong, if we drag the map, the spawn point changes, we should do this on the select method
            AnnotationClusterView *annClusterView = (AnnotationClusterView*) view;
            AnnotationCluster *annCluster = annClusterView.annotation;
            for (Annotation *annChild in annCluster.annotations) {
                annChild.spawnPoint = annClusterView.center;
            }            
            // animate alpha
            [UIView animateWithDuration:.5
                             animations:^{
                                 view.alpha = 1.0;
                             }
                             completion:^(BOOL finished){ }];

        // ANNOTATION ADDED
        } else if ([view isKindOfClass:[AnnotationView class]]){
            AnnotationView *annView = (AnnotationView*)view;
            annView.alpha=.5;
            // Set the parent cluster as center, so we can animate back to its original position
            CGPoint center = annView.center;
            annView.center = ((Annotation*)annView.annotation).spawnPoint;
            [UIView animateWithDuration:1
                             animations:^{
                                 // animate position
                                 view.center = center;
                                 // animate alpha
                                 view.alpha=1.0;
                             }
                             completion:^(BOOL finished){ }];
        }
    }
}


/** 
 * If a cluster is selected, add their children to the map.
 * 
 * Called when an annotation is selected. 
 */
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    debug(@"didSelectAnnotationView");
    
    BOOL isAnnotationCluster = [view isKindOfClass:[AnnotationClusterView class]];
    BOOL isAnnotation = [view isKindOfClass:[AnnotationView class]];
    
    if (isAnnotationCluster){
        if (self.lastSelectedAnnotationCluster == view.annotation){
            // Case where we re-select the same cluster. Nothing to do.
        } else {
            // Case where we select a different cluster.
            
            // remove cluster's children
            for (Annotation *childAnn in self.lastSelectedAnnotationCluster.annotations) {
                [UIView animateWithDuration:1
                                 animations:^{
                                     childAnn.view.center = childAnn.spawnPoint;
                                     childAnn.view.alpha=0.0;
                                 }
                                 completion:^(BOOL finished){ 
                                     [self.mapView removeAnnotation:childAnn];
                                 }];
            }

            // set as last selected
            self.lastSelectedAnnotationCluster = view.annotation;
            
            // add cluster's children (animated in mapView:didAddAnnotationViews:)
            [self.mapView addAnnotations:self.lastSelectedAnnotationCluster.annotations];
            
        }
    } else if (isAnnotation){
        self.lastSelectedAnnotation = view.annotation;
    }
}

    /*
    if (self.lastSelectedCluster!=nil){
        // is this annotation related to the cluster?
        if ([view.annotation isKindOfClass:[AnnotationCluster class]]){
            AnnotationCluster *cluster = (AnnotationCluster*)view.annotation;
            if (cluster==self.lastSelectedCluster){
                debug(@"same cluster selected again, nothing to do");
            } else {
                debug(@"different cluster selected");
                // contract and remove childs of last one
                for (Annotation *childAnn in self.lastSelectedCluster.annotations) {
                    // animate alpha and position
                    [UIView animateWithDuration:1
                                     animations:^{
                                         childAnn.view.center = childAnn.spawnPoint;
                                         childAnn.view.alpha=0.0;
                                     }
                                     completion:^(BOOL finished){ 
                                         [self.mapView removeAnnotation:childAnn];
                                     }];
                }
                // save a reference to the current cluster
                self.lastSelectedCluster=cluster;
            }
        }
    }
    
    
    id <MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[AnnotationCluster class]]){
        
        // add the children of the cluster (good title for a horror movie!)
        AnnotationCluster *parentAnn = (AnnotationCluster*) annotation;
        AnnotationClusterView *clusterView = (AnnotationClusterView *)view;
        for (Annotation *childAnn in parentAnn.annotations) {
            // we need to update the spawnPoint on the childs because it changes with panning and zoom
            childAnn.spawnPoint=clusterView.center;
            // add the child
            [self.mapView addAnnotation:childAnn];
        }
        
        // Save a reference so next time we can check if the user selected
        // a child of the cluster or not.
        self.lastSelectedCluster = (AnnotationCluster*) annotation;
        
    } else if ([annotation isKindOfClass:[Annotation class]]){
        //Annotation *ann = (Annotation*) annotation;
        
    } else {
        warn(@"unknown annotation %@", [annotation class]);
    }
}
 */   



/**
 * Contract the child annotations of a cluster when it is deselected 
 * AND the selected annotation is not one of their children.
 *
 * Called when an annotation is deselected.
 */
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    debug(@"didDeselectAnnotationView");

    if (view.annotation == self.lastSelectedAnnotationCluster){
        trace(@"we deselected the cluster...");
        if (self.lastSelectedAnnotation == nil){
            trace(@"..because we clicked on the ground");
            for (Annotation *childAnn in self.lastSelectedAnnotationCluster.annotations) {
                [UIView animateWithDuration:1
                                 animations:^{
                                     childAnn.view.center = childAnn.spawnPoint;
                                     childAnn.view.alpha=0.0;
                                 }
                                 completion:^(BOOL finished){ 
                                     [self.mapView removeAnnotation:childAnn];
                                 }];
            }
            self.lastSelectedAnnotationCluster = nil;
        } else {
            
            BOOL isChildOfLastSelectedAnnotationCluster = FALSE;
            for (Annotation *childAnn in lastSelectedAnnotationCluster.annotations) {
                if (childAnn==lastSelectedAnnotation){
                    isChildOfLastSelectedAnnotationCluster = TRUE;
                    break;
                }
            }
            
            if (isChildOfLastSelectedAnnotationCluster){
                trace(@"..because we clicked on one of its children");
                trace(@"nothing to do");
            } else {
                trace(@".. because we clicked on a foreign annotation (case where we have single annotations added)");
                trace(@"remove cluster's children");
                for (Annotation *childAnn in self.lastSelectedAnnotationCluster.annotations) {
                    [UIView animateWithDuration:1
                                     animations:^{
                                         childAnn.view.center = childAnn.spawnPoint;
                                         childAnn.view.alpha=0.0;
                                     }
                                     completion:^(BOOL finished){ 
                                         [self.mapView removeAnnotation:childAnn];
                                     }];
                }
                self.lastSelectedAnnotationCluster = nil;
            }
        }
    } else if ([view.annotation isKindOfClass:[Annotation class]]){
        trace(@"we deselected an annotation");
        // nothing to do
    } else if ([view.annotation isKindOfClass:[AnnotationCluster class]]){
        trace(@"we deselected a cluster which isn't the lastSelectedCluster");
        warn(@"how the fuck did this even happen?");
    } 
}

/*
    id <MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[AnnotationCluster class]]){
        
        // contract and remove childs
        AnnotationCluster *cluster = (AnnotationCluster*) annotation;
        for (Annotation *childAnn in cluster.annotations) {
            // animate alpha and position
            [UIView animateWithDuration:1
                             animations:^{
                                 childAnn.view.center = childAnn.spawnPoint;
                                 childAnn.view.alpha=0.0;
                             }
                             completion:^(BOOL finished){ 
                                 [self.mapView removeAnnotation:childAnn];
                             }];
        }
        
    } else if ([annotation isKindOfClass:[Annotation class]]){
        // nothing to do
    } else if ([annotation isKindOfClass:[SimpleAnnotation class]]){
        // nothing to do 
    } else {
        warn(@"unknown annotation %@", [annotation class]);
    }
}
*/



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[AnnotationCluster class]]){
        
        // cluster view with badge number
        static NSString* const clusterViewId = @"clusterViewId";
        AnnotationClusterView *annotationView = (AnnotationClusterView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:clusterViewId];
        if (annotationView == nil) {
            annotationView = [[AnnotationClusterView alloc] initWithAnnotation:annotation reuseIdentifier:clusterViewId];
            annotationView.alpha=0.0; // will animate to 1 in mapView:didAddAnnotationViews:
        }
        AnnotationCluster *cluster = (AnnotationCluster*) annotation;
        annotationView.badgeNumber = [cluster.annotations count];
        return annotationView;
        
    } else if ([annotation isKindOfClass:[Annotation class]]){
        
        // annotation view
        Annotation *ann = (Annotation*) annotation;
        static NSString* const annotationViewId = @"annotationViewId";
        AnnotationView *annotationView = (AnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewId];
        if (annotationView == nil) {
            annotationView = [[AnnotationView alloc] initWithAnnotation:ann reuseIdentifier:annotationViewId];
            annotationView.alpha=0.0; // will animate to 1 in mapView:didAddAnnotationViews:
        }
        ann.view = annotationView;
        return annotationView;
        
    } else {
        
        // standard annotation
        return [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPinAnnotationView"];
    }
}



#pragma mark - UIViewController

-(void) loadView {
    self.mapView = [MapView new];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.clusterer = [[KMeansClusterer alloc] initWithMap:self.mapView];
    [self initializeMap];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
