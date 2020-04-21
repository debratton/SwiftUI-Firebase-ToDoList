//
//  TextGestureRecognizer.swift
//  ToDoList
//
//  Created by David E Bratton on 4/11/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import SwiftUI

class TextGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}
