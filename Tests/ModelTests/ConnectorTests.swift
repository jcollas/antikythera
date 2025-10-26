//
//  ConnectorTests.swift
//  Antikythera
//
//  Unit tests for Connector and PinAndSlotConnector classes
//

import XCTest
@testable import Antikythera

class ConnectorTests: XCTestCase {

    // MARK: - Connector Initialization Tests

    func testConnectorInitializationWithRadius() {
        // Given
        let radius: Float = 5.0

        // When
        let connector = Connector(radius: radius)

        // Then
        XCTAssertEqual(connector.radius, 5.0, "Connector radius should be initialized")
        XCTAssertEqual(connector.rotation, 0.0, "Initial rotation should be 0")
        XCTAssertNil(connector.topComponent, "Top component should be nil initially")
        XCTAssertNil(connector.bottomComponent, "Bottom component should be nil initially")
    }

    func testConnectorInitializationWithComponents() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let radius: Float = 2.0

        // When
        let connector = Connector(radius: radius, top: gear1, bottom: gear2)

        // Then
        XCTAssertEqual(connector.radius, 2.0, "Radius should be set")
        XCTAssertTrue(connector.topComponent === gear1, "Top component should be gear1")
        XCTAssertTrue(connector.bottomComponent === gear2, "Bottom component should be gear2")
        XCTAssertTrue(connector.hasTopComponent, "Should have top component")
        XCTAssertTrue(connector.hasBottomComponent, "Should have bottom component")
    }

    func testConnectorInitializationFromInfo() throws {
        // Given
        let gear1 = createTestGear(name: "topGear", teeth: 60)
        let gear2 = createTestGear(name: "bottomGear", teeth: 30)
        let allGears = ["topGear": gear1, "bottomGear": gear2]

        let connectorInfo = ConnectorInfo(
            name: "testConnector",
            radius: 3.0,
            topGear: "topGear",
            bottomGear: "bottomGear",
            connectionType: "connector"
        )

        // When
        let connector = try Connector(info: connectorInfo, allGears: allGears)

        // Then
        XCTAssertEqual(connector.name, "testConnector", "Name should be set from info")
        XCTAssertEqual(connector.radius, 3.0, "Radius should be set from info")
        XCTAssertTrue(connector.topComponent === gear1, "Top component should be linked")
        XCTAssertTrue(connector.bottomComponent === gear2, "Bottom component should be linked")

        // Verify neighbor relationships were established
        XCTAssertTrue(gear1.neighbors.contains { $0 === connector }, "Gear1 should have connector as neighbor")
        XCTAssertTrue(gear2.neighbors.contains { $0 === connector }, "Gear2 should have connector as neighbor")
    }

    func testConnectorInitializationWithMissingGear() {
        // Given
        let gear1 = createTestGear(name: "topGear", teeth: 60)
        let allGears = ["topGear": gear1] // Missing bottomGear

        let connectorInfo = ConnectorInfo(
            name: "testConnector",
            radius: 3.0,
            topGear: "topGear",
            bottomGear: "missingGear",
            connectionType: "connector"
        )

        // When/Then: Should throw error
        XCTAssertThrowsError(try Connector(info: connectorInfo, allGears: allGears)) { error in
            XCTAssertTrue(error is AntikytheraError, "Should throw AntikytheraError")
        }
    }

    // MARK: - Connector Factory Method Tests

    func testMakeConnectorFactoryWithConnectorType() throws {
        // Given
        let gear1 = createTestGear(name: "topGear", teeth: 60)
        let gear2 = createTestGear(name: "bottomGear", teeth: 30)
        let allGears = ["topGear": gear1, "bottomGear": gear2]

        let connectorInfo = ConnectorInfo(
            name: "testConnector",
            radius: 3.0,
            topGear: "topGear",
            bottomGear: "bottomGear",
            connectionType: "connector"
        )

        // When
        let connector = try Connector.makeConnector(info: connectorInfo, allGears: allGears)

        // Then
        XCTAssertTrue(connector is Connector, "Should create Connector instance")
        XCTAssertFalse(connector is PinAndSlotConnector, "Should not be PinAndSlotConnector")
    }

    func testMakeConnectorFactoryWithPinAndSlotType() throws {
        // Given
        let gear1 = createTestGear(name: "topGear", teeth: 60)
        let gear2 = createTestGear(name: "bottomGear", teeth: 30)
        let allGears = ["topGear": gear1, "bottomGear": gear2]

        let connectorInfo = ConnectorInfo(
            name: "testConnector",
            radius: 3.0,
            topGear: "topGear",
            bottomGear: "bottomGear",
            connectionType: "pin-and-slot"
        )

        // When
        let connector = try Connector.makeConnector(info: connectorInfo, allGears: allGears)

        // Then
        XCTAssertTrue(connector is PinAndSlotConnector, "Should create PinAndSlotConnector instance")
    }

    func testMakeConnectorFactoryWithInvalidType() {
        // Given
        let gear1 = createTestGear(name: "topGear", teeth: 60)
        let gear2 = createTestGear(name: "bottomGear", teeth: 30)
        let allGears = ["topGear": gear1, "bottomGear": gear2]

        let connectorInfo = ConnectorInfo(
            name: "testConnector",
            radius: 3.0,
            topGear: "topGear",
            bottomGear: "bottomGear",
            connectionType: "invalid-type"
        )

        // When/Then: Should throw error
        XCTAssertThrowsError(try Connector.makeConnector(info: connectorInfo, allGears: allGears)) { error in
            guard case AntikytheraError.BuildError(let message) = error else {
                XCTFail("Expected BuildError")
                return
            }
            XCTAssertTrue(message.contains("Unrecognized"), "Error message should mention unrecognized type")
        }
    }

    // MARK: - Connector Rotation Tests

    func testConnectorDirectRotation() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let connector = Connector(radius: 2.0, top: gear1, bottom: gear2)

        // When
        connector.rotate(45.0)

        // Then
        XCTAssertEqual(connector.rotation, 45.0, accuracy: 0.001, "Connector rotation should be updated")
        // Both gears should also rotate
        XCTAssertNotEqual(gear1.rotation, 0.0, "Top gear should rotate")
        XCTAssertNotEqual(gear2.rotation, 0.0, "Bottom gear should rotate")
    }

    func testConnectorPropagatesRotationToComponents() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let connector = Connector(radius: 2.0, top: gear1, bottom: gear2)

        // When: Rotate connector by 10 degrees
        connector.rotate(10.0)

        // Then: Both components should receive rotation update
        // Note: The actual rotation values will be scaled by gear ratios
        XCTAssertEqual(connector.rotation, 10.0, accuracy: 0.001, "Connector should rotate")
        XCTAssertNotEqual(gear1.rotation, 0.0, "Gear1 should have rotated")
        XCTAssertNotEqual(gear2.rotation, 0.0, "Gear2 should have rotated")
    }

    func testConnectorUpdateRotationFromSource() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let connector = Connector(radius: 2.0, top: gear1, bottom: gear2)

        // When: Update rotation as if it came from gear1
        connector.updateRotation(10.0, fromSource: gear1)

        // Then: Connector should rotate, and only gear2 should receive the update
        XCTAssertEqual(connector.rotation, 10.0, accuracy: 0.001, "Connector rotation should be updated")
        XCTAssertEqual(gear1.rotation, 0.0, "Gear1 should not rotate (it's the source)")
        XCTAssertNotEqual(gear2.rotation, 0.0, "Gear2 should rotate")
    }

    func testConnectorDoesNotPropagatBackToSource() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let connector = Connector(radius: 2.0, top: gear1, bottom: gear2)

        // When: Update rotation from gear1
        let initialGear1Rotation = gear1.rotation
        connector.updateRotation(10.0, fromSource: gear1)

        // Then: gear1 should not have its rotation changed (no circular update)
        XCTAssertEqual(gear1.rotation, initialGear1Rotation, accuracy: 0.001, "Source gear should not be updated")
    }

    // MARK: - PinAndSlotConnector Tests

    func testPinAndSlotConnectorInitialization() {
        // Given
        let gear1 = createTestGear(name: "topGear", teeth: 60)
        let gear2 = createTestGear(name: "bottomGear", teeth: 90)
        let allGears = ["topGear": gear1, "bottomGear": gear2]

        let connectorInfo = ConnectorInfo(
            name: "pinSlotConnector",
            radius: 3.0,
            topGear: "topGear",
            bottomGear: "bottomGear",
            connectionType: "pin-and-slot"
        )

        // When
        let connector = try! PinAndSlotConnector(info: connectorInfo, allGears: allGears)

        // Then
        XCTAssertEqual(connector.name, "pinSlotConnector", "Name should be set")
        XCTAssertEqual(connector.radius, 3.0, "Radius should be set")

        // arborOffset should be (bottomGear.radius*2) - (topGear.radius*2)
        let expectedArborOffset = (gear2.radius * 2) - (gear1.radius * 2)
        XCTAssertEqual(connector.arborOffset, expectedArborOffset, accuracy: 0.001, "Arbor offset should be calculated")

        // pinOffset should be topGear.radius * 0.7
        let expectedPinOffset = gear1.radius * 0.7
        XCTAssertEqual(connector.pinOffset, expectedPinOffset, accuracy: 0.001, "Pin offset should be calculated")
    }

    func testPinAndSlotConnectorSlotOffset() {
        // Given
        let connector = PinAndSlotConnector(radius: 2.0, arborOffset: 5.0, pinOffset: 3.0)

        // When/Then
        XCTAssertEqual(connector.slotOffset, connector.pinOffset, "Slot offset should equal pin offset")
    }

    func testPinAndSlotConnectorRotationProperties() {
        // Given
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 90)
        let connector = PinAndSlotConnector(radius: 2.0, arborOffset: 5.0, pinOffset: 3.0)
        connector.setConnections(gear1, bottom: gear2)

        // When
        connector.rotate(45.0)

        // Then
        XCTAssertEqual(connector.pinRotation, 45.0, accuracy: 0.001, "Pin rotation should match connector rotation")
        XCTAssertEqual(connector.slotRotation, gear2.rotation, accuracy: 0.001, "Slot rotation should match bottom gear rotation")
    }

    func testPinAndSlotConnectorBottomComponentRotationCalculation() {
        // Given: Pin-and-slot with specific geometry
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 90)
        let connector = PinAndSlotConnector(radius: 2.0, arborOffset: 5.0, pinOffset: 3.0)
        connector.setConnections(gear1, bottom: gear2)

        // When: Rotate the connector
        connector.rotate(10.0)

        // Then: Bottom gear should rotate based on pin-and-slot mechanism
        // The actual calculation is complex (involves vector math), so we just verify it rotates
        XCTAssertNotEqual(gear2.rotation, 0.0, "Bottom gear should rotate")
        XCTAssertNotEqual(gear2.rotation, 10.0, "Bottom gear rotation should be different from direct rotation")
    }

    // MARK: - Connection Management Tests

    func testSetConnections() {
        // Given
        let connector = Connector(radius: 2.0)
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)

        // When
        connector.setConnections(gear1, bottom: gear2)

        // Then
        XCTAssertTrue(connector.topComponent === gear1, "Top component should be set")
        XCTAssertTrue(connector.bottomComponent === gear2, "Bottom component should be set")
    }

    func testHasComponentProperties() {
        // Given
        let connector = Connector(radius: 2.0)
        let gear1 = createTestGear(name: "gear1", teeth: 60)

        // When/Then: Initially no components
        XCTAssertFalse(connector.hasTopComponent, "Should not have top component initially")
        XCTAssertFalse(connector.hasBottomComponent, "Should not have bottom component initially")

        // When: Set top component
        connector.setConnections(gear1, bottom: connector)

        // Then
        XCTAssertTrue(connector.hasTopComponent, "Should have top component")
        XCTAssertTrue(connector.hasBottomComponent, "Should have bottom component")
    }

    // MARK: - Integration Tests

    func testConnectorInGearChain() {
        // Given: gear1 -> connector -> gear2
        let gear1 = createTestGear(name: "gear1", teeth: 60)
        let gear2 = createTestGear(name: "gear2", teeth: 30)
        let connector = Connector(radius: 1.0, top: gear1, bottom: gear2)

        // When: Rotate gear1
        gear1.rotate(10.0)

        // Then: Rotation should propagate through connector to gear2
        XCTAssertEqual(gear1.rotation, 10.0, accuracy: 0.001, "Gear1 should rotate")
        XCTAssertNotEqual(connector.rotation, 0.0, "Connector should rotate")
        XCTAssertNotEqual(gear2.rotation, 0.0, "Gear2 should rotate")
    }

    // MARK: - Helper Methods

    private func createTestGear(name: String, teeth: Int, radiusScale: Float? = nil) -> Gear {
        let gearInfo = GearInfo(
            name: name,
            teeth: teeth,
            radiusScale: radiusScale,
            placement: PlacementInfo(positionType: "fixed", toGear: nil, x: 0, y: 0, z: 0, offset: nil, radians: nil),
            linkedTo: nil
        )
        return Gear(gearInfo)
    }
}
