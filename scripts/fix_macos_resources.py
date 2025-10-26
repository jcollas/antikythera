#!/usr/bin/env python3
"""
Script to fix macOS target resources - exclude iOS-specific storyboard
"""

import re
import sys
from pathlib import Path

def main():
    project_path = Path('AntikytheraOpenGLPrototype_v3/AntikytheraOpenGLPrototype.xcodeproj/project.pbxproj')

    if not project_path.exists():
        print(f"Error: {project_path} not found")
        sys.exit(1)

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Create backup
    backup_path = project_path.with_suffix('.pbxproj.backup3')
    with open(backup_path, 'w') as f:
        f.write(content)
    print(f"Created backup at {backup_path}")

    # Find the macOS Resources build phase and remove storyboard reference
    # First, find the macOS Resources phase UUID
    macos_resources_match = re.search(r'([0-9A-F]{24}) /\* Resources \*/ = \{[^}]*?isa = PBXResourcesBuildPhase;[^}]*?files = \(([^)]*?)\);[^}]*?\};', content, re.DOTALL)

    if macos_resources_match:
        # Get all Resources phases
        all_resources = re.findall(r'([0-9A-F]{24}) /\* Resources \*/ = \{[^}]*?isa = PBXResourcesBuildPhase;[^}]*?files = \(([^)]*?)\);[^}]*?\};', content, re.DOTALL)

        # The second one should be macOS (first is iOS)
        if len(all_resources) >= 2:
            macos_resources_uuid = all_resources[1][0]
            macos_files = all_resources[1][1]

            print(f"Found macOS Resources phase: {macos_resources_uuid}")

            # Remove storyboard reference from macOS resources
            # Find the storyboard build file UUID
            storyboard_match = re.search(r'([0-9A-F]{24}) /\* Main\.storyboard in Resources \*/', content)
            if storyboard_match:
                storyboard_uuid = storyboard_match.group(1)
                print(f"Found storyboard build file UUID: {storyboard_uuid}")

                # Remove this UUID from macOS resources
                macos_files_clean = re.sub(rf'\s*{storyboard_uuid} /\* Main\.storyboard in Resources \*/,?', '', macos_files)

                # Replace the macOS resources section
                old_phase = f"{macos_resources_uuid} /* Resources */ = {{\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = ({macos_files});"
                new_phase = f"{macos_resources_uuid} /* Resources */ = {{\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = ({macos_files_clean});"

                content = content.replace(old_phase, new_phase)
                print("Removed storyboard from macOS resources")

    # Write the modified content
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\nSuccessfully updated {project_path}")
    print("\nChanges made:")
    print("  - Removed Main.storyboard from macOS target resources")
    print(f"\nBackup saved to: {backup_path}")

if __name__ == '__main__':
    main()
