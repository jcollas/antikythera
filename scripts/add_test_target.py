#!/usr/bin/env python3
"""
Script to add test target to Xcode project
"""

import re
import sys
from pathlib import Path

def generate_uuid():
    """Generate a 24-character hex UUID in Xcode format"""
    import random
    return ''.join(random.choices('0123456789ABCDEF', k=24))

def main():
    project_path = Path('Antikythera.xcodeproj/project.pbxproj')

    if not project_path.exists():
        print(f"Error: {project_path} not found")
        sys.exit(1)

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Generate UUIDs for test target components
    uuids = {
        'test_target': generate_uuid(),
        'test_product': generate_uuid(),
        'test_sources_phase': generate_uuid(),
        'test_frameworks_phase': generate_uuid(),
        'test_resources_phase': generate_uuid(),
        'test_debug_config': generate_uuid(),
        'test_release_config': generate_uuid(),
        'test_config_list': generate_uuid(),
        'test_info_plist': generate_uuid(),

        # Test source files
        'GearTests.swift_file': generate_uuid(),
        'GearTests.swift_build': generate_uuid(),
        'ConnectorTests.swift_file': generate_uuid(),
        'ConnectorTests.swift_build': generate_uuid(),
        'AntikytheraMechanismTests.swift_file': generate_uuid(),
        'AntikytheraMechanismTests.swift_build': generate_uuid(),

        # Test JSON file
        'test_device_json_file': generate_uuid(),
        'test_device_json_build': generate_uuid(),

        # XCTest framework
        'XCTest_framework': generate_uuid(),
        'XCTest_build': generate_uuid(),

        # Tests group
        'tests_group': generate_uuid(),
        'model_tests_group': generate_uuid(),
    }

    print("Generated UUIDs for test target")

    # Create backup
    backup_path = project_path.with_suffix('.pbxproj.backup-tests')
    with open(backup_path, 'w') as f:
        f.write(content)
    print(f"Created backup at {backup_path}")

    # 1. Add file references for test files
    file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?/\* End PBXFileReference section \*/)', content, re.DOTALL)
    if file_ref_section:
        insert_pos = file_ref_section.end(1) - len('/* End PBXFileReference section */')

        new_file_refs = f"""		{uuids['GearTests.swift_file']} /* GearTests.swift */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = GearTests.swift; sourceTree = "<group>"; }};
		{uuids['ConnectorTests.swift_file']} /* ConnectorTests.swift */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = ConnectorTests.swift; sourceTree = "<group>"; }};
		{uuids['AntikytheraMechanismTests.swift_file']} /* AntikytheraMechanismTests.swift */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = AntikytheraMechanismTests.swift; sourceTree = "<group>"; }};
		{uuids['test_device_json_file']} /* test-device.json */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.json; path = "test-device.json"; sourceTree = "<group>"; }};
		{uuids['test_product']} /* AntikytheraTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = AntikytheraTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};
		{uuids['XCTest_framework']} /* XCTest.framework */ = {{isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = XCTest.framework; path = Platforms/iPhoneOS.platform/Developer/Library/Frameworks/XCTest.framework; sourceTree = DEVELOPER_DIR; }};
"""
        content = content[:insert_pos - 1] + new_file_refs + content[insert_pos - 1:]

    # 2. Add build files for test sources
    build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/.*?/\* End PBXBuildFile section \*/)', content, re.DOTALL)
    if build_file_section:
        insert_pos = build_file_section.end(1) - len('/* End PBXBuildFile section */')

        new_build_files = f"""		{uuids['GearTests.swift_build']} /* GearTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {uuids['GearTests.swift_file']} /* GearTests.swift */; }};
		{uuids['ConnectorTests.swift_build']} /* ConnectorTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {uuids['ConnectorTests.swift_file']} /* ConnectorTests.swift */; }};
		{uuids['AntikytheraMechanismTests.swift_build']} /* AntikytheraMechanismTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {uuids['AntikytheraMechanismTests.swift_file']} /* AntikytheraMechanismTests.swift */; }};
		{uuids['test_device_json_build']} /* test-device.json in Resources */ = {{isa = PBXBuildFile; fileRef = {uuids['test_device_json_file']} /* test-device.json */; }};
		{uuids['XCTest_build']} /* XCTest.framework in Frameworks */ = {{isa = PBXBuildFile; fileRef = {uuids['XCTest_framework']} /* XCTest.framework */; }};
"""
        content = content[:insert_pos - 1] + new_build_files + content[insert_pos - 1:]

    # 3. Add test product to Products group
    products_group = re.search(r'(19C28FACFE9D520D11CA2CBB /\* Products \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if products_group:
        children = products_group.group(2)
        children = children.rstrip()
        if children and not children.endswith(','):
            children += ','
        children += f"\n\t\t\t\t{uuids['test_product']} /* AntikytheraTests.xctest */,"
        content = content[:products_group.start(2)] + children + content[products_group.end(2):]

    # 4. Add XCTest framework to Frameworks group
    frameworks_group = re.search(r'(29B97323FDCFA39411CA2CEA /\* Frameworks \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if frameworks_group:
        children = frameworks_group.group(2)
        if '/* XCTest.framework */' not in children:
            children = children.rstrip()
            if children and not children.endswith(','):
                children += ','
            children += f"\n\t\t\t\t{uuids['XCTest_framework']} /* XCTest.framework */,"
            content = content[:frameworks_group.start(2)] + children + content[frameworks_group.end(2):]

    # 5. Add Tests group structure
    # Find the main group (29B97314FDCFA39411CA2CEA)
    main_group = re.search(r'(29B97314FDCFA39411CA2CEA = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if main_group:
        children = main_group.group(2)
        children = children.rstrip()
        if children and not children.endswith(','):
            children += ','
        children += f"\n\t\t\t\t{uuids['tests_group']} /* Tests */,"
        content = content[:main_group.start(2)] + children + content[main_group.end(2):]

    # Add the Tests group definition before End PBXGroup
    group_section = re.search(r'(/\* Begin PBXGroup section \*/.*?/\* End PBXGroup section \*/)', content, re.DOTALL)
    if group_section:
        insert_pos = group_section.end(1) - len('/* End PBXGroup section */')

        tests_groups = f"""		{uuids['tests_group']} /* Tests */ = {{
			isa = PBXGroup;
			children = (
				{uuids['model_tests_group']} /* ModelTests */,
			);
			path = Tests;
			sourceTree = "<group>";
		}};
		{uuids['model_tests_group']} /* ModelTests */ = {{
			isa = PBXGroup;
			children = (
				{uuids['GearTests.swift_file']} /* GearTests.swift */,
				{uuids['ConnectorTests.swift_file']} /* ConnectorTests.swift */,
				{uuids['AntikytheraMechanismTests.swift_file']} /* AntikytheraMechanismTests.swift */,
				{uuids['test_device_json_file']} /* test-device.json */,
			);
			path = ModelTests;
			sourceTree = "<group>";
		}};
"""
        content = content[:insert_pos - 1] + tests_groups + content[insert_pos - 1:]

    # 6. Create PBXSourcesBuildPhase for tests
    sources_section = re.search(r'(/\* Begin PBXSourcesBuildPhase section \*/.*?/\* End PBXSourcesBuildPhase section \*/)', content, re.DOTALL)
    if sources_section:
        insert_pos = sources_section.end(1) - len('/* End PBXSourcesBuildPhase section */')

        test_sources = f"""		{uuids['test_sources_phase']} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{uuids['GearTests.swift_build']} /* GearTests.swift in Sources */,
				{uuids['ConnectorTests.swift_build']} /* ConnectorTests.swift in Sources */,
				{uuids['AntikytheraMechanismTests.swift_build']} /* AntikytheraMechanismTests.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""
        content = content[:insert_pos - 1] + test_sources + content[insert_pos - 1:]

    # 7. Create PBXFrameworksBuildPhase for tests
    frameworks_section = re.search(r'(/\* Begin PBXFrameworksBuildPhase section \*/.*?/\* End PBXFrameworksBuildPhase section \*/)', content, re.DOTALL)
    if frameworks_section:
        insert_pos = frameworks_section.end(1) - len('/* End PBXFrameworksBuildPhase section */')

        test_frameworks = f"""		{uuids['test_frameworks_phase']} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{uuids['XCTest_build']} /* XCTest.framework in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""
        content = content[:insert_pos - 1] + test_frameworks + content[insert_pos - 1:]

    # 8. Create PBXResourcesBuildPhase for tests
    resources_section = re.search(r'(/\* Begin PBXResourcesBuildPhase section \*/.*?/\* End PBXResourcesBuildPhase section \*/)', content, re.DOTALL)
    if resources_section:
        insert_pos = resources_section.end(1) - len('/* End PBXResourcesBuildPhase section */')

        test_resources = f"""		{uuids['test_resources_phase']} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{uuids['test_device_json_build']} /* test-device.json in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""
        content = content[:insert_pos - 1] + test_resources + content[insert_pos - 1:]

    # 9. Create PBXNativeTarget for tests
    target_section = re.search(r'(/\* Begin PBXNativeTarget section \*/.*?/\* End PBXNativeTarget section \*/)', content, re.DOTALL)
    if target_section:
        insert_pos = target_section.end(1) - len('/* End PBXNativeTarget section */')

        test_target = f"""		{uuids['test_target']} /* AntikytheraTests */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {uuids['test_config_list']} /* Build configuration list for PBXNativeTarget "AntikytheraTests" */;
			buildPhases = (
				{uuids['test_sources_phase']} /* Sources */,
				{uuids['test_frameworks_phase']} /* Frameworks */,
				{uuids['test_resources_phase']} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = AntikytheraTests;
			productName = AntikytheraTests;
			productReference = {uuids['test_product']} /* AntikytheraTests.xctest */;
			productType = "com.apple.product-type.bundle.unit-test";
		}};
"""
        content = content[:insert_pos - 1] + test_target + content[insert_pos - 1:]

    # 10. Add test target to project targets
    project_section = re.search(r'(29B97313FDCFA39411CA2CEA /\* Project object \*/ = \{.*?targets = \()(.*?)(\);)', content, re.DOTALL)
    if project_section:
        targets = project_section.group(2)
        targets = targets.rstrip()
        if targets and not targets.endswith(','):
            targets += ','
        targets += f"\n\t\t\t\t{uuids['test_target']} /* AntikytheraTests */,"
        content = content[:project_section.start(2)] + targets + content[project_section.end(2):]

    # 11. Create build configurations for test target
    config_section = re.search(r'(/\* Begin XCBuildConfiguration section \*/.*?/\* End XCBuildConfiguration section \*/)', content, re.DOTALL)
    if config_section:
        insert_pos = config_section.end(1) - len('/* End XCBuildConfiguration section */')

        debug_config = f"""		{uuids['test_debug_config']} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				DEVELOPMENT_TEAM = ZW9JSEAYHF;
				INFOPLIST_FILE = Tests/Info.plist;
				IPHONEOS_DEPLOYMENT_TARGET = 14.0;
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
				PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.AntikytheraTests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SDKROOT = iphoneos;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/Antikythera.app/Antikythera";
			}};
			name = Debug;
		}};
		{uuids['test_release_config']} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				DEVELOPMENT_TEAM = ZW9JSEAYHF;
				INFOPLIST_FILE = Tests/Info.plist;
				IPHONEOS_DEPLOYMENT_TARGET = 14.0;
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
				PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.AntikytheraTests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SDKROOT = iphoneos;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/Antikythera.app/Antikythera";
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
"""
        content = content[:insert_pos - 1] + debug_config + content[insert_pos - 1:]

    # 12. Create configuration list for test target
    config_list_section = re.search(r'(/\* Begin XCConfigurationList section \*/.*?/\* End XCConfigurationList section \*/)', content, re.DOTALL)
    if config_list_section:
        insert_pos = config_list_section.end(1) - len('/* End XCConfigurationList section */')

        test_config_list = f"""		{uuids['test_config_list']} /* Build configuration list for PBXNativeTarget "AntikytheraTests" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{uuids['test_debug_config']} /* Debug */,
				{uuids['test_release_config']} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
"""
        content = content[:insert_pos - 1] + test_config_list + content[insert_pos - 1:]

    # Write the modified content
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\nSuccessfully updated {project_path}")
    print("\nChanges made:")
    print("  - Added AntikytheraTests target")
    print("  - Added test source files to project")
    print("  - Added XCTest framework")
    print("  - Created Tests group structure")
    print("  - Configured test target build settings")
    print(f"\nBackup saved to: {backup_path}")
    print("\nNext step: Create Tests/Info.plist file")

if __name__ == '__main__':
    main()
