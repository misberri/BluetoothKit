//
// Created by Agathe Battestini on 1/23/17.
// Copyright (c) 2017 Rasmus Taulborg Hummelmose. All rights reserved.
//

import Foundation
import CoreBluetooth


public extension CBCharacteristic {
    var uuidString: String {
        return self.uuid.uuidString
    }
}
