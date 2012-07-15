
Not ready yet, come back later!


![Clustered annotations](https://github.com/j4n0/mapkit-clusters/raw/master/pages/mapkit.png)

Annotation clustering to show a high number of pins without cluttering the screen.
This uses the k-means algorithm to do the clustering.

There will be bugs. Also, the code is complicated, maybe there is no other way to do this.

LOGIC TO EXPAND/CONTRACT NODES

 - lastSelectedCluster
 - lastSelectedAnnotation
 
 - didAdd:
       if (added is kind of cluster){
           // animate fade in
       } else if (added is kind of annotation){
           // animate fade in and position expand
       }
 
 - select:
 
       if (selected isKindOf cluster){
           if (lastSelectedCluster == cluster){
               // case where the same cluster is selected, nothing changes
           } else {
               // case where a different cluster is selected
               // remove last cluster
               with lastSelectedCluster:
                   - contract and remove children 
                     Note: To access the views of the children you need each 
                           child to keep a reference to its view.
                           This can be done in the viewForAnnotation method.
                   - remove lastSelectedCluster
               // add new cluster
               lastSelectedCluster = cluster
               with lastSelectedCluster:
                   - add and expand children
           }
       } else if (lastSelectedCluster isKindOf annotation){
           lastSelectedAnnotation = annotation
       }

 - deselect:
 
       if (deselected == lastSelectedCluster){
           // we deselected the cluster..
           if (lastSelectedAnnotation == nil){
               // ..because we clicked on the ground   
           } else if (lastSelectedAnnotation is child of lastSelectedCluster){
               // ..because we clicked on one of its children
               // nothing to do
           } else {
               // .. because we clicked on a foreign annotation
               // do the removal thing (but probably we never reach this case)
           }
       } else if (deselected is kind of annotation){
           // we deselected an annotation
           // nothing to do
       } else if (deselected is kind of cluster){
           // we deselected a cluster which isn't the lastSelectedCluster
           // this shouldn't happen
       }

