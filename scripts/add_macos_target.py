#!/usr/bin/env python3
"""
Script to add macOS target to Xcode project
"""

import re
import sys
from pathlib import Path

def generate_uuid():
    """Generate a 24-character hex UUID in Xcode format"""
    import random
    return ''.join(random.choices('0123456789ABCDEF', k=24))

def main():
    project_path = Path('AntikytheraOpenGLPrototype_v3/AntikytheraOpenGLPrototype.xcodeproj/project.pbxproj')

    if not project_path.exists():
        print(f"Error: {project_path} not found")
        sys.exit(1)

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Generate UUIDs for macOS target
    uuids = {
        'target': generate_uuid(),
        'product': generate_uuid(),
        'frameworks_phase': generate_uuid(),
        'resources_phase': generate_uuid(),
        'sources_phase': generate_uuid(),
        'debug_config': generate_uuid(),
        'release_config': generate_uuid(),
        'config_list': generate_uuid(),
        'info_plist': generate_uuid(),
        'info_plist_build': generate_uuid(),
        'AppKit.framework': generate_uuid(),
        'AppKit_build': generate_uuid(),
    }

    print("Generated UUIDs for macOS target:")
    for name, uuid in uuids.items():
        print(f"  {name}: {uuid}")

    # Create backup
    backup_path = project_path.with_suffix('.pbxproj.backup2')
    with open(backup_path, 'w') as f:
        f.write(content)
    print(f"\nCreated backup at {backup_path}")

    # Add macOS Info.plist file reference
    file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?/\* End PBXFileReference section \*/)', content, re.DOTALL)
    if file_ref_section:
        insert_pos = file_ref_section.end(1) - len('/* End PBXFileReference section */')
        new_file_ref = f"\t\t{uuids['info_plist']} /* AntikytheraOpenGLPrototype-macOS-Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = \"AntikytheraOpenGLPrototype-macOS-Info.plist\"; sourceTree = \"<group>\"; }};\n"
        new_file_ref += f"\t\t{uuids['product']} /* AntikytheraOpenGLPrototype.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = AntikytheraOpenGLPrototype.app; sourceTree = BUILT_PRODUCTS_DIR; }};\n"
        new_file_ref += f"\t\t{uuids['AppKit.framework']} /* AppKit.framework */ = {{isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = AppKit.framework; path = System/Library/Frameworks/AppKit.framework; sourceTree = SDKROOT; }};\n"
        content = content[:insert_pos - 1] + new_file_ref + content[insert_pos - 1:]

    # Add macOS product to Products group
    products_group = re.search(r'(19C28FACFE9D520D11CA2CBB /\* Products \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if products_group:
        children = products_group.group(2)
        children = children.rstrip()
        if children and not children.endswith(','):
            children += ','
        children += f"\n\t\t\t\t{uuids['product']} /* AntikytheraOpenGLPrototype.app */,"
        content = content[:products_group.start(2)] + children + content[products_group.end(2):]

    # Add AppKit to Frameworks group
    frameworks_group = re.search(r'(29B97323FDCFA39411CA2CEA /\* Frameworks \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if frameworks_group:
        children = frameworks_group.group(2)
        if '/* AppKit.framework */' not in children:
            children = children.rstrip()
            if children and not children.endswith(','):
                children += ','
            children += f"\n\t\t\t\t{uuids['AppKit.framework']} /* AppKit.framework */,"
            content = content[:frameworks_group.start(2)] + children + content[frameworks_group.end(2):]

    # Add Info.plist to Resources group
    resources_group = re.search(r'(29B97317FDCFA39411CA2CEA /\* Resources \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if resources_group:
        children = resources_group.group(2)
        children = children.rstrip()
        if children and not children.endswith(','):
            children += ','
        children += f"\n\t\t\t\t{uuids['info_plist']} /* AntikytheraOpenGLPrototype-macOS-Info.plist */,"
        content = content[:resources_group.start(2)] + children + content[resources_group.end(2):]

    # Add PBXBuildFile for Info.plist
    build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/.*?/\* End PBXBuildFile section \*/)', content, re.DOTALL)
    if build_file_section:
        insert_pos = build_file_section.end(1) - len('/* End PBXBuildFile section */')
        new_build_file = f"\t\t{uuids['info_plist_build']} /* AntikytheraOpenGLPrototype-macOS-Info.plist in Resources */ = {{isa = PBXBuildFile; fileRef = {uuids['info_plist']} /* AntikytheraOpenGLPrototype-macOS-Info.plist */; }};\n"
        new_build_file += f"\t\t{uuids['AppKit_build']} /* AppKit.framework in Frameworks */ = {{isa = PBXBuildFile; fileRef = {uuids['AppKit.framework']} /* AppKit.framework */; }};\n"
        content = content[:insert_pos - 1] + new_build_file + content[insert_pos - 1:]

    # Create PBXFrameworksBuildPhase for macOS
    frameworks_section = re.search(r'(/\* Begin PBXFrameworksBuildPhase section \*/.*?/\* End PBXFrameworksBuildPhase section \*/)', content, re.DOTALL)
    if frameworks_section:
        # Get all the framework build file UUIDs we need (from iOS target)
        ios_frameworks = re.search(r'1D60588F0D05DD3D006BFB54 /\* Frameworks \*/ = \{.*?files = \((.*?)\);', content, re.DOTALL)
        if ios_frameworks:
            framework_files = ios_frameworks.group(1).strip()
            # Replace UIKit with AppKit
            framework_files = re.sub(r'1DF5F4E00D08C38300B7A737 /\* UIKit\.framework in Frameworks \*/',
                                    f'{uuids["AppKit_build"]} /* AppKit.framework in Frameworks */', framework_files)

        insert_pos = frameworks_section.end(1) - len('/* End PBXFrameworksBuildPhase section */')
        new_frameworks = f"\t\t{uuids['frameworks_phase']} /* Frameworks */ = {{\n"
        new_frameworks += f"\t\t\tisa = PBXFrameworksBuildPhase;\n"
        new_frameworks += f"\t\t\tbuildActionMask = 2147483647;\n"
        new_frameworks += f"\t\t\tfiles = (\n"
        new_frameworks += f"\t\t\t\t{framework_files}\n"
        new_frameworks += f"\t\t\t);\n"
        new_frameworks += f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        new_frameworks += f"\t\t}};\n"
        content = content[:insert_pos - 1] + new_frameworks + content[insert_pos - 1:]

    # Create PBXResourcesBuildPhase for macOS
    resources_section = re.search(r'(/\* Begin PBXResourcesBuildPhase section \*/.*?/\* End PBXResourcesBuildPhase section \*/)', content, re.DOTALL)
    if resources_section:
        # Get resource files from iOS target
        ios_resources = re.search(r'1D60588D0D05DD3D006BFB54 /\* Resources \*/ = \{.*?files = \((.*?)\);', content, re.DOTALL)
        if ios_resources:
            resource_files = ios_resources.group(1).strip()

        insert_pos = resources_section.end(1) - len('/* End PBXResourcesBuildPhase section */')
        new_resources = f"\t\t{uuids['resources_phase']} /* Resources */ = {{\n"
        new_resources += f"\t\t\tisa = PBXResourcesBuildPhase;\n"
        new_resources += f"\t\t\tbuildActionMask = 2147483647;\n"
        new_resources += f"\t\t\tfiles = (\n"
        new_resources += f"\t\t\t\t{resource_files}\n"
        new_resources += f"\t\t\t);\n"
        new_resources += f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        new_resources += f"\t\t}};\n"
        content = content[:insert_pos - 1] + new_resources + content[insert_pos - 1:]

    # Create PBXSourcesBuildPhase for macOS
    sources_section = re.search(r'(/\* Begin PBXSourcesBuildPhase section \*/.*?/\* End PBXSourcesBuildPhase section \*/)', content, re.DOTALL)
    if sources_section:
        # Get source files from iOS target
        ios_sources = re.search(r'1D60588E0D05DD3D006BFB54 /\* Sources \*/ = \{.*?files = \((.*?)\);', content, re.DOTALL)
        if ios_sources:
            source_files = ios_sources.group(1).strip()

        insert_pos = sources_section.end(1) - len('/* End PBXSourcesBuildPhase section */')
        new_sources = f"\t\t{uuids['sources_phase']} /* Sources */ = {{\n"
        new_sources += f"\t\t\tisa = PBXSourcesBuildPhase;\n"
        new_sources += f"\t\t\tbuildActionMask = 2147483647;\n"
        new_sources += f"\t\t\tfiles = (\n"
        new_sources += f"\t\t\t\t{source_files}\n"
        new_sources += f"\t\t\t);\n"
        new_sources += f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        new_sources += f"\t\t}};\n"
        content = content[:insert_pos - 1] + new_sources + content[insert_pos - 1:]

    # Create PBXNativeTarget for macOS
    native_target_section = re.search(r'(/\* Begin PBXNativeTarget section \*/.*?/\* End PBXNativeTarget section \*/)', content, re.DOTALL)
    if native_target_section:
        insert_pos = native_target_section.end(1) - len('/* End PBXNativeTarget section */')
        new_target = f"\t\t{uuids['target']} /* AntikytheraOpenGLPrototype-macOS */ = {{\n"
        new_target += f"\t\t\tisa = PBXNativeTarget;\n"
        new_target += f"\t\t\tbuildConfigurationList = {uuids['config_list']} /* Build configuration list for PBXNativeTarget \"AntikytheraOpenGLPrototype-macOS\" */;\n"
        new_target += f"\t\t\tbuildPhases = (\n"
        new_target += f"\t\t\t\t{uuids['resources_phase']} /* Resources */,\n"
        new_target += f"\t\t\t\t{uuids['sources_phase']} /* Sources */,\n"
        new_target += f"\t\t\t\t{uuids['frameworks_phase']} /* Frameworks */,\n"
        new_target += f"\t\t\t);\n"
        new_target += f"\t\t\tbuildRules = (\n"
        new_target += f"\t\t\t);\n"
        new_target += f"\t\t\tdependencies = (\n"
        new_target += f"\t\t\t);\n"
        new_target += f"\t\t\tname = \"AntikytheraOpenGLPrototype-macOS\";\n"
        new_target += f"\t\t\tproductName = \"AntikytheraOpenGLPrototype-macOS\";\n"
        new_target += f"\t\t\tproductReference = {uuids['product']} /* AntikytheraOpenGLPrototype.app */;\n"
        new_target += f"\t\t\tproductType = \"com.apple.product-type.application\";\n"
        new_target += f"\t\t}};\n"
        content = content[:insert_pos - 1] + new_target + content[insert_pos - 1:]

    # Add macOS target to project targets list
    project_section = re.search(r'(29B97313FDCFA39411CA2CEA /\* Project object \*/ = \{.*?targets = \()(.*?)(\);)', content, re.DOTALL)
    if project_section:
        targets = project_section.group(2)
        targets = targets.rstrip()
        if targets and not targets.endswith(','):
            targets += ','
        targets += f"\n\t\t\t\t{uuids['target']} /* AntikytheraOpenGLPrototype-macOS */,"
        content = content[:project_section.start(2)] + targets + content[project_section.end(2):]

    # Create XCBuildConfiguration for macOS Debug
    build_config_section = re.search(r'(/\* Begin XCBuildConfiguration section \*/.*?/\* End XCBuildConfiguration section \*/)', content, re.DOTALL)
    if build_config_section:
        insert_pos = build_config_section.end(1) - len('/* End XCBuildConfiguration section */')

        debug_config = f"\t\t{uuids['debug_config']} /* Debug */ = {{\n"
        debug_config += f"\t\t\tisa = XCBuildConfiguration;\n"
        debug_config += f"\t\t\tbuildSettings = {{\n"
        debug_config += f"\t\t\t\tALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;\n"
        debug_config += f"\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;\n"
        debug_config += f"\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;\n"
        debug_config += f"\t\t\t\tCOMBINE_HIDPI_IMAGES = YES;\n"
        debug_config += f"\t\t\t\tCOPY_PHASE_STRIP = NO;\n"
        debug_config += f"\t\t\t\tDEVELOPMENT_TEAM = ZW9JSEAYHF;\n"
        debug_config += f"\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;\n"
        debug_config += f"\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;\n"
        debug_config += f"\t\t\t\tINFOPLIST_FILE = \"AntikytheraOpenGLPrototype-macOS-Info.plist\";\n"
        debug_config += f"\t\t\t\tLD_RUNPATH_SEARCH_PATHS = \"@executable_path/../Frameworks\";\n"
        debug_config += f"\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 11.0;\n"
        debug_config += f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = \"com.yourcompany.AntikytheraOpenGLPrototype-macOS\";\n"
        debug_config += f"\t\t\t\tPRODUCT_NAME = AntikytheraOpenGLPrototype;\n"
        debug_config += f"\t\t\t\tSDKROOT = macosx;\n"
        debug_config += f"\t\t\t\tSWIFT_OBJC_BRIDGING_HEADER = \"Antikythera-Bridging-Header.h\";\n"
        debug_config += f"\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-Onone\";\n"
        debug_config += f"\t\t\t\tSWIFT_VERSION = 5.0;\n"
        debug_config += f"\t\t\t}};\n"
        debug_config += f"\t\t\tname = Debug;\n"
        debug_config += f"\t\t}};\n"

        release_config = f"\t\t{uuids['release_config']} /* Release */ = {{\n"
        release_config += f"\t\t\tisa = XCBuildConfiguration;\n"
        release_config += f"\t\t\tbuildSettings = {{\n"
        release_config += f"\t\t\t\tALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;\n"
        release_config += f"\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;\n"
        release_config += f"\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;\n"
        release_config += f"\t\t\t\tCOMBINE_HIDPI_IMAGES = YES;\n"
        release_config += f"\t\t\t\tCOPY_PHASE_STRIP = YES;\n"
        release_config += f"\t\t\t\tDEVELOPMENT_TEAM = ZW9JSEAYHF;\n"
        release_config += f"\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;\n"
        release_config += f"\t\t\t\tINFOPLIST_FILE = \"AntikytheraOpenGLPrototype-macOS-Info.plist\";\n"
        release_config += f"\t\t\t\tLD_RUNPATH_SEARCH_PATHS = \"@executable_path/../Frameworks\";\n"
        release_config += f"\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 11.0;\n"
        release_config += f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = \"com.yourcompany.AntikytheraOpenGLPrototype-macOS\";\n"
        release_config += f"\t\t\t\tPRODUCT_NAME = AntikytheraOpenGLPrototype;\n"
        release_config += f"\t\t\t\tSDKROOT = macosx;\n"
        release_config += f"\t\t\t\tSWIFT_OBJC_BRIDGING_HEADER = \"Antikythera-Bridging-Header.h\";\n"
        release_config += f"\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-Owholemodule\";\n"
        release_config += f"\t\t\t\tSWIFT_VERSION = 5.0;\n"
        release_config += f"\t\t\t}};\n"
        release_config += f"\t\t\tname = Release;\n"
        release_config += f"\t\t}};\n"

        content = content[:insert_pos - 1] + debug_config + release_config + content[insert_pos - 1:]

    # Create XCConfigurationList for macOS target
    config_list_section = re.search(r'(/\* Begin XCConfigurationList section \*/.*?/\* End XCConfigurationList section \*/)', content, re.DOTALL)
    if config_list_section:
        insert_pos = config_list_section.end(1) - len('/* End XCConfigurationList section */')

        new_config_list = f"\t\t{uuids['config_list']} /* Build configuration list for PBXNativeTarget \"AntikytheraOpenGLPrototype-macOS\" */ = {{\n"
        new_config_list += f"\t\t\tisa = XCConfigurationList;\n"
        new_config_list += f"\t\t\tbuildConfigurations = (\n"
        new_config_list += f"\t\t\t\t{uuids['debug_config']} /* Debug */,\n"
        new_config_list += f"\t\t\t\t{uuids['release_config']} /* Release */,\n"
        new_config_list += f"\t\t\t);\n"
        new_config_list += f"\t\t\tdefaultConfigurationIsVisible = 0;\n"
        new_config_list += f"\t\t\tdefaultConfigurationName = Release;\n"
        new_config_list += f"\t\t}};\n"

        content = content[:insert_pos - 1] + new_config_list + content[insert_pos - 1:]

    # Write the modified content
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\nSuccessfully updated {project_path}")
    print("\nChanges made:")
    print("  - Added macOS native target")
    print("  - Added AppKit framework for macOS")
    print("  - Shared source files with iOS target")
    print("  - Configured macOS deployment target (11.0)")
    print("  - Set up macOS build configurations")
    print(f"\nBackup saved to: {backup_path}")

if __name__ == '__main__':
    main()
