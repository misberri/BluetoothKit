//
//  BluetoothKit
//
//  Copyright (c) 2015 Rasmus Taulborg Hummelmose - https://github.com/rasmusth
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import CoreBluetooth

/**
    Class that represents a configuration used when starting a BKCentral object.
*/
public class BKConfiguration {

    // MARK: Properties

    /// The UUID for the service used to send data. This should be unique to your applications.
    public let dataServiceUUID: CBUUID
    public let dataServiceUUIDs: [CBUUID]

    /// The UUID for the characteristic used to send data. This should be unique to your application.
    public var dataServiceCharacteristicUUID: CBUUID?
    public var dataServiceCharacteristicUUIDs: [CBUUID: [CBUUID]]?

    /// Data used to indicate that no more data is coming when communicating.
    public var endOfDataMark: Data

    /// Data used to indicate that a transfer was cancellen when communicating.
    public var dataCancelledMark: Data

    internal var serviceUUIDs: [CBUUID] {
        return dataServiceUUIDs
    }

    // MARK: Initialization

    public init(dataServiceUUID: UUID, dataServiceCharacteristicUUID: UUID) {
        self.dataServiceUUID = CBUUID(nsuuid: dataServiceUUID)
        self.dataServiceUUIDs = [self.dataServiceUUID]
        self.dataServiceCharacteristicUUID = CBUUID(nsuuid: dataServiceCharacteristicUUID)
        endOfDataMark = "EOD".data(using: String.Encoding.utf8)!
        dataCancelledMark = "COD".data(using: String.Encoding.utf8)!
    }

    public init(dataServiceUUIDs: [UUID]) {
        self.dataServiceUUIDs = dataServiceUUIDs.map { uuid -> CBUUID in
            return CBUUID(nsuuid: uuid)
        }
        self.dataServiceUUID = self.dataServiceUUIDs[0]
        self.dataServiceCharacteristicUUID = nil
//        let dataServiceCharacteristicUUID = UUID(uuidString: "")!
//        self.dataServiceCharacteristicUUID = CBUUID(nsuuid: dataServiceCharacteristicUUID)
        endOfDataMark = "EOD".data(using: String.Encoding.utf8)!
        dataCancelledMark = "COD".data(using: String.Encoding.utf8)!
    }

    public init(dataServiceCharacteristicsUUIDs: [UUID: [UUID]]) {

        var serviceCharacteristicsCBUUIDs = [CBUUID: [CBUUID]]()
        var serviceCBUUIDs = [CBUUID]()
        for (serviceUuid, charUuids) in dataServiceCharacteristicsUUIDs {
            let characteristics = charUuids.map { uuid -> CBUUID in
                return CBUUID(nsuuid: uuid)
            }
            serviceCharacteristicsCBUUIDs[CBUUID(nsuuid: serviceUuid)] = characteristics
            serviceCBUUIDs.append(CBUUID(nsuuid: serviceUuid))
        }
        self.dataServiceUUIDs = serviceCBUUIDs
        self.dataServiceUUID = self.dataServiceUUIDs[0]
        self.dataServiceCharacteristicUUID = nil
        self.dataServiceCharacteristicUUIDs = serviceCharacteristicsCBUUIDs

        endOfDataMark = "EOD".data(using: String.Encoding.utf8)!
        dataCancelledMark = "COD".data(using: String.Encoding.utf8)!
    }



    // MARK Functions

    internal func characteristicUUIDsForServiceUUID(_ serviceUUID: CBUUID) -> [CBUUID] {
        if serviceUUID == dataServiceUUID, let charUUID = self.dataServiceCharacteristicUUID {
            return [ charUUID ]
        }
        return []
    }

    internal func remotePeripheral(withIdentifier identifier: UUID, peripheral: CBPeripheral) -> BKRemotePeripheral {
        let remotePeripheral = BKRemotePeripheral(identifier: identifier, peripheral: peripheral)
        remotePeripheral.configuration = self
        return remotePeripheral
    }
}
