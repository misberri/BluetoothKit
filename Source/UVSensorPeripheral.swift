//
// Created by Agathe Battestini on 1/15/17.
// Copyright (c) 2017 SF Collective. All rights reserved.
//

import Foundation
import CoreBluetooth

public enum SensorUUID: String {
    case accelerometer  = "AEE330B9-8DE8-A2A3-C54D-53EC3D53E339"
    case uvsensor       = "5AA3EC66-0603-AF9C-474B-6F593879BA41"
    case barometer      = "1218579C-E4FA-C6A7-4640-2BFC6919827E"
    case battery        = "3853583F-1F6C-DCB2-DC42-37DBAA4AAB0F"
    case tester         = "89960217-F456-BAB2-C845-CA698303A89E"
}

public extension SensorUUID {
    public var uuid: UUID! {
        return UUID(uuidString: self.rawValue)!
    }
}

public struct BLESettings {

    public static let SnseSnseUVServiceUUID             = UUID(uuidString: "34E4AE92-58C7-F392-A645-9E753446F49C")!
    public static let SnseDeviceInformationServiceUUID  = UUID(uuidString: "EDFEC62E-9910-0BAC-5241-D8BDA6932A2F")!

    public static let SnseCharAccelerometerUUID         = SensorUUID.accelerometer.uuid!
    public static let SnseCharUVSensorUUID              = SensorUUID.uvsensor.uuid!
    public static let SnseCharBarometerUUID             = SensorUUID.barometer.uuid!
    public static let SnseCharBatteryUUID               = SensorUUID.battery.uuid!
    public static let SnseCharTesterUUID                = SensorUUID.tester.uuid!

    func senSettingFor(characteristic: CBCharacteristic) -> UUID? {
        let settings = [BLESettings.SnseCharAccelerometerUUID,
                        BLESettings.SnseCharUVSensorUUID,
                        BLESettings.SnseCharBarometerUUID,
                        BLESettings.SnseCharBarometerUUID,
                        BLESettings.SnseCharTesterUUID
        ]
        let last = settings.filter {return characteristic.uuidString == $0.uuidString}.last
        return last
    }
}


public class UVSensorPeripheral: BKRemotePeripheral {

    override init(identifier: UUID, peripheral: CBPeripheral?) {
        super.init(identifier: identifier, peripheral: peripheral)
    }


//    public func write11(characteristic: CBCharacteristic) {
//        if let peripheral = self.peripheral {
//            let data = Data(bytes: [0x11])
//            peripheral.writeValue(data, for: characteristic, type: .withResponse)
//        }
//    }

    public func read(characteristicUuid: UUID) {
        if let peripheral = self.peripheral,
           let characteristic = characteristicFor(characteristicUuid: characteristicUuid) {
            peripheral.readValue(for: characteristic)
        }
    }

    public func readUVSensor() {
        read(characteristicUuid: BLESettings.SnseCharUVSensorUUID)
    }

    public func readAccelerometer() {
        read(characteristicUuid: BLESettings.SnseCharAccelerometerUUID)
    }

    public func services() -> [CBService]? {
        return peripheral?.services
    }
}

extension BKRemotePeripheral: CustomStringConvertible {
    public var description: String {
        var s = String()
        self.serviceCharacteristics.forEach { (uuid: String, characteristics: [CBCharacteristic]) in
            s += "Service: \(uuid):\n"
            characteristics.forEach {char in
                s += "\n  Characteristic \(char.uuid)\n"
                s += "    properties: \(char.properties)\n"
                s += "    value: \(char.value)\n"
                if let descriptors = char.descriptors {
                    descriptors.forEach { (desc: CBDescriptor) in
                        s += "      descriptor: \(desc)\n"
                    }
                }
                s += char.isNotifying ? "    Notify: yes\n" : "    Notify: no\n"
            }
            s += "\n"
        }
        s += "--"
        return s
    }
}

extension CBCharacteristic {
    public var name: String {
        if let descriptors = descriptors {
            let userDescriptor = descriptors.filter { desc -> Bool in
                return desc.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString
            }.last
            if let userDescriptor = userDescriptor, let value = userDescriptor.value as? String {
                return value
            }
        }
        return ""
    }
}

extension CBCharacteristicProperties: CustomStringConvertible {
    public var description: String {
        var s = [String]()
        if self.contains(.read) { s.append("read")}
        if self.contains(.write) { s.append("write")}
        if self.contains(.authenticatedSignedWrites) { s.append("writes signed")}
        if self.contains(.writeWithoutResponse) { s.append("write without response")}
        if self.contains(.notify) { s.append("notify")}
        if self.contains(.notifyEncryptionRequired) { s.append("notify encrypted")}
        if self.contains(.broadcast) { s.append("broadcast")}
        if self.contains(.extendedProperties) { s.append("extended properties")}
        if self.contains(.indicate) { s.append("indicate")}
        if self.contains(.indicateEncryptionRequired) { s.append("indicate encrypted")}

        return s.joined(separator: ",")
    }
}
