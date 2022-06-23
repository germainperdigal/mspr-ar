import 'dart:async';
import 'dart:math' as math;
import 'package:app_mspr/config/collection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:collection/collection.dart';

class ScanWidget extends StatefulWidget {
  @override
  ScanView createState() => ScanView();
}

/// Scan view
class ScanView extends State<ScanWidget> {
  late ARKitController arkitController;
  ARKitNode? boxNode;
  Timer? timer;
  bool anchorWasFound = false;

  /// Clean frame
  cleanFrame(ARKitController frame, String? nodeId) {
    if (nodeId != null) {
      frame.remove(nodeId);
    }
  }

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  void _onPinchHandler(List<ARKitNodePinchResult> pinch) {
    print(pinch);
    final pinchNode = pinch.firstOrNull;
    if (pinchNode != null) {
      final scale = vector.Vector3.all(pinchNode.scale);
      boxNode?.scale = scale;
    }
  }

  void _onPanHandler(List<ARKitNodePanResult> pan) {
    print(pan);
    final panNode = pan.firstOrNull;
    if (panNode != null) {
      final old = boxNode?.eulerAngles;
      final newAngleY = panNode.translation.x * math.pi / 180;
      boxNode?.eulerAngles =
          vector.Vector3(old?.x ?? 0, newAngleY, old?.z ?? 0);
    }
  }

  void _onRotationHandler(List<ARKitNodeRotationResult> rotation) {
    print(rotation);

    final rotationNode = rotation.firstOrNull;
    if (rotationNode != null) {
      final rotation = boxNode?.eulerAngles ??
          vector.Vector3.zero() + vector.Vector3.all(rotationNode.rotation);
      boxNode?.eulerAngles = rotation;
    }
  }

  /// Build
  @override
  Widget build(BuildContext context) {
    var currentObject = null;

    return Scaffold(
        body: ARKitSceneView(
          detectionImagesGroupName: 'AR Resources',
          enablePinchRecognizer: true,
          enablePanRecognizer: true,
          enableRotationRecognizer: true,
          onARKitViewCreated: (c) {
            c.onNodePinch = (pinch) => _onPinchHandler(pinch);
            c.onNodePan = (pan) => _onPanHandler(pan);
            c.onNodeRotation = (rotation) => _onRotationHandler(rotation);
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
                boxNode = node;
                currentObject = objectUrl;
              }
            };
          },
        )
    );
  }
}