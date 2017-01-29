//
// Created by Agathe Battestini on 1/15/17.
// Copyright (c) 2017 Rasmus Taulborg Hummelmose. All rights reserved.
//

import Foundation
import CoreBluetooth

public class UVConfiguration: BKConfiguration {



    public override func remotePeripheral(withIdentifier identifier: UUID, peripheral: CBPeripheral) ->
        BKRemotePeripheral {
        let remotePeripheral = UVSensorPeripheral(identifier: identifier, peripheral: peripheral)
        remotePeripheral.configuration = self
        return remotePeripheral
    }

}
