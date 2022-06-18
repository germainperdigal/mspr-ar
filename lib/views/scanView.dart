import 'dart:async';

import 'package:app_mspr/config/collection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:arkit_plugin/arkit_plugin.dart';

/// Scan view
class ScanView extends StatelessWidget {
  late ARKitController arkitController;
  Timer? timer;
  bool anchorWasFound = false;

  /// Clean frame
  cleanFrame(ARKitController frame, String? nodeId) {
    if (nodeId != null) {
      frame.remove(nodeId);
    }
  }

  /// Build
  @override
  Widget build(BuildContext context) {
    var currentObject = null;

    return Scaffold(
        body: ARKitSceneView(
          detectionImagesGroupName: 'AR Resources',
          onARKitViewCreated: (c) {
            c.onAddNodeForAnchor = (anchor) {
              if (anchor is ARKitImageAnchor) {
                cleanFrame(c, currentObject);

                var objectUrl = modelsCollection[anchor.referenceImageName ?? 'monkey'] ?? 'monkey.dae';
                final node = ARKitReferenceNode(
                    name: objectUrl,
                    url: 'models.scnassets/$objectUrl',
                    position: vector.Vector3(
                      anchor.transform.getColumn(3).x,
                      anchor.transform.getColumn(3).y,
                      anchor.transform.getColumn(3).z,
                    ),
                    scale: vector.Vector3.all(0.1)
                );
                c.add(node);
                currentObject = objectUrl;
              }
            };
          },
        )
    );
  }
}