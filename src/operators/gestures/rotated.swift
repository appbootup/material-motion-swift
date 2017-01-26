/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

extension ExtendableMotionObservable where T: UIRotationGestureRecognizer {

  /**
   Adds the current translation to the initial position and emits the result while the gesture
   recognizer is active.
   */
  func rotated(from initialRotation: MotionObservable<CGFloat>) -> MotionObservable<CGFloat> {
    var cachedInitialRotation: CGFloat?
    return _nextOperator { value, next in
      if value.state == .began || (value.state == .changed && cachedInitialRotation == nil)  {
        cachedInitialRotation = initialRotation.read()
      } else if value.state != .began && value.state != .changed {
        cachedInitialRotation = nil
      }
      if let cachedInitialRotation = cachedInitialRotation {
        let rotation = value.rotation
        next(cachedInitialRotation + rotation)
      }
    }
  }
}
