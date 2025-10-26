#!/usr/bin/env python3
"""
Script to update Xcode project file for Metal conversion
Adds Metal files, removes OpenGL files, updates frameworks
"""

import re
import sys
from pathlib import Path

def generate_uuid():
    """Generate a 24-character hex UUID in Xcode format"""
    import random
    return ''.join(random.choices('0123456789ABCDEF', k=24))

def main():
    project_path = Path('Antikythera/Antikythera.xcodeproj/project.pbxproj')

    if not project_path.exists():
        print(f"Error: {project_path} not found")
        sys.exit(1)

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Generate UUIDs for new Metal files
    uuids = {
        'MetalRenderer.swift': {'file': generate_uuid(), 'build': generate_uuid()},
        'MetalView.swift': {'file': generate_uuid(), 'build': generate_uuid()},
        'MetalModel3D.swift': {'file': generate_uuid(), 'build': generate_uuid()},
        'MetalViewController.swift': {'file': generate_uuid(), 'build': generate_uuid()},
        'MetalRenderContext.swift': {'file': generate_uuid(), 'build': generate_uuid()},
        'Shaders.metal': {'file': generate_uuid(), 'build': generate_uuid()},
        'Metal.framework': {'file': generate_uuid(), 'build': generate_uuid()},
        'MetalKit.framework': {'file': generate_uuid(), 'build': generate_uuid()},
    }

    print("Generated UUIDs:")
    for name, ids in uuids.items():
        print(f"  {name}:")
        print(f"    File: {ids['file']}")
        print(f"    Build: {ids['build']}")

    # Create backup
    backup_path = project_path.with_suffix('.pbxproj.backup')
    with open(backup_path, 'w') as f:
        f.write(content)
    print(f"\nCreated backup at {backup_path}")

    # Find the PBXBuildFile section
    build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/.*?/\* End PBXBuildFile section \*/)', content, re.DOTALL)
    if not build_file_section:
        print("Error: Could not find PBXBuildFile section")
        sys.exit(1)

    # Add new PBXBuildFile entries
    new_build_files = []
    for name, ids in uuids.items():
        if name.endswith('.framework'):
            framework_name = name
            new_build_files.append(
                f"\t\t{ids['build']} /* {framework_name} in Frameworks */ = {{isa = PBXBuildFile; fileRef = {ids['file']} /* {framework_name} */; }};"
            )
        else:
            new_build_files.append(
                f"\t\t{ids['build']} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {ids['file']} /* {name} */; }};"
            )

    # Insert new build files after the last existing one
    insert_pos = build_file_section.end(1) - len('/* End PBXBuildFile section */')
    new_content = (
        content[:insert_pos - 1] +
        '\n' + '\n'.join(new_build_files) + '\n' +
        content[insert_pos - 1:]
    )
    content = new_content

    # Find the PBXFileReference section and add file references
    file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?/\* End PBXFileReference section \*/)', content, re.DOTALL)
    if not file_ref_section:
        print("Error: Could not find PBXFileReference section")
        sys.exit(1)

    new_file_refs = []
    for name, ids in uuids.items():
        if name.endswith('.framework'):
            new_file_refs.append(
                f"\t\t{ids['file']} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = {name}; path = System/Library/Frameworks/{name}; sourceTree = SDKROOT; }};"
            )
        elif name.endswith('.metal'):
            new_file_refs.append(
                f"\t\t{ids['file']} /* {name} */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.metal; name = {name}; path = Classes/{name}; sourceTree = SOURCE_ROOT; }};"
            )
        else:
            new_file_refs.append(
                f"\t\t{ids['file']} /* {name} */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; name = {name}; path = Classes/{name}; sourceTree = SOURCE_ROOT; }};"
            )

    insert_pos = file_ref_section.end(1) - len('/* End PBXFileReference section */')
    new_content = (
        content[:insert_pos - 1] +
        '\n' + '\n'.join(new_file_refs) + '\n' +
        content[insert_pos - 1:]
    )
    content = new_content

    # Update PBXFrameworksBuildPhase to add Metal frameworks and remove OpenGLES/GLKit
    frameworks_phase = re.search(r'(1D60588F0D05DD3D006BFB54 /\* Frameworks \*/ = \{.*?files = \()(.*?)(\);)', content, re.DOTALL)
    if frameworks_phase:
        # Remove OpenGLES and GLKit
        framework_files = frameworks_phase.group(2)
        framework_files = re.sub(r'\s*28FD15000DC6FC520079059D /\* OpenGLES\.framework in Frameworks \*/,?', '', framework_files)
        framework_files = re.sub(r'\s*C0FDE53C1C2A357D008283F4 /\* GLKit\.framework in Frameworks \*/,?', '', framework_files)

        # Add Metal frameworks
        framework_files = framework_files.rstrip()
        if framework_files and not framework_files.endswith(','):
            framework_files += ','
        framework_files += f"\n\t\t\t\t{uuids['Metal.framework']['build']} /* Metal.framework in Frameworks */,"
        framework_files += f"\n\t\t\t\t{uuids['MetalKit.framework']['build']} /* MetalKit.framework in Frameworks */,"

        content = content[:frameworks_phase.start(2)] + framework_files + content[frameworks_phase.end(2):]

    # Update PBXSourcesBuildPhase to add Metal sources and remove GLView/GLViewController
    sources_phase = re.search(r'(1D60588E0D05DD3D006BFB54 /\* Sources \*/ = \{.*?files = \()(.*?)(\);)', content, re.DOTALL)
    if sources_phase:
        source_files = sources_phase.group(2)
        # Remove old OpenGL files
        source_files = re.sub(r'\s*28FD14FE0DC6FC130079059D /\* GLView\.swift in Sources \*/,?', '', source_files)
        source_files = re.sub(r'\s*1F92F5EC0FDFF83200548BE8 /\* GLViewController\.swift in Sources \*/,?', '', source_files)
        source_files = re.sub(r'\s*C9CCAB26116D87B60097AE70 /\* GLModel3D\.swift in Sources \*/,?', '', source_files)

        # Add new Metal files
        source_files = source_files.rstrip()
        if source_files and not source_files.endswith(','):
            source_files += ','
        source_files += f"\n\t\t\t\t{uuids['MetalRenderer.swift']['build']} /* MetalRenderer.swift in Sources */,"
        source_files += f"\n\t\t\t\t{uuids['MetalView.swift']['build']} /* MetalView.swift in Sources */,"
        source_files += f"\n\t\t\t\t{uuids['MetalModel3D.swift']['build']} /* MetalModel3D.swift in Sources */,"
        source_files += f"\n\t\t\t\t{uuids['MetalViewController.swift']['build']} /* MetalViewController.swift in Sources */,"
        source_files += f"\n\t\t\t\t{uuids['MetalRenderContext.swift']['build']} /* MetalRenderContext.swift in Sources */,"
        source_files += f"\n\t\t\t\t{uuids['Shaders.metal']['build']} /* Shaders.metal in Sources */,"

        content = content[:sources_phase.start(2)] + source_files + content[sources_phase.end(2):]

    # Update the Classes group to add Metal files
    classes_group = re.search(r'(080E96DDFE201D6D7F000001 /\* Classes \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if classes_group:
        children = classes_group.group(2)
        # Add Metal files after Common.swift reference
        common_ref = '1F92F5EB0FDFF83200548BE8 /* Common.swift */,'
        if common_ref in children:
            children = children.replace(
                common_ref,
                f"{common_ref}\n\t\t\t\t{uuids['MetalRenderer.swift']['file']} /* MetalRenderer.swift */,\n\t\t\t\t{uuids['MetalView.swift']['file']} /* MetalView.swift */,\n\t\t\t\t{uuids['MetalViewController.swift']['file']} /* MetalViewController.swift */,\n\t\t\t\t{uuids['MetalModel3D.swift']['file']} /* MetalModel3D.swift */,\n\t\t\t\t{uuids['MetalRenderContext.swift']['file']} /* MetalRenderContext.swift */,\n\t\t\t\t{uuids['Shaders.metal']['file']} /* Shaders.metal */,"
            )

        content = content[:classes_group.start(2)] + children + content[classes_group.end(2):]

    # Update Frameworks group
    frameworks_group = re.search(r'(29B97323FDCFA39411CA2CEA /\* Frameworks \*/ = \{.*?children = \()(.*?)(\);)', content, re.DOTALL)
    if frameworks_group:
        children = frameworks_group.group(2)
        # Remove OpenGLES and GLKit
        children = re.sub(r'\s*28FD14FF0DC6FC520079059D /\* OpenGLES\.framework \*/,?', '', children)
        children = re.sub(r'\s*C0FDE53B1C2A357D008283F4 /\* GLKit\.framework \*/,?', '', children)

        # Add Metal frameworks after QuartzCore
        quartz_ref = '28FD15070DC6FC5B0079059D /* QuartzCore.framework */,'
        if quartz_ref in children:
            children = children.replace(
                quartz_ref,
                f"{quartz_ref}\n\t\t\t\t{uuids['Metal.framework']['file']} /* Metal.framework */,\n\t\t\t\t{uuids['MetalKit.framework']['file']} /* MetalKit.framework */,"
            )

        content = content[:frameworks_group.start(2)] + children + content[frameworks_group.end(2):]

    # Update deployment target to iOS 14.0
    content = re.sub(r'IPHONEOS_DEPLOYMENT_TARGET = 11\.0;', 'IPHONEOS_DEPLOYMENT_TARGET = 14.0;', content)
    content = re.sub(r'IPHONEOS_DEPLOYMENT_TARGET = 8\.0;', 'IPHONEOS_DEPLOYMENT_TARGET = 14.0;', content)

    # Write the modified content
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\nSuccessfully updated {project_path}")
    print("\nChanges made:")
    print("  - Added Metal framework references")
    print("  - Added MetalKit framework references")
    print("  - Removed OpenGLES framework")
    print("  - Removed GLKit framework")
    print("  - Added Metal source files (MetalRenderer, MetalView, etc.)")
    print("  - Removed OpenGL source files (GLView, GLViewController, GLModel3D)")
    print("  - Updated deployment target to iOS 14.0")
    print(f"\nBackup saved to: {backup_path}")

if __name__ == '__main__':
    main()
