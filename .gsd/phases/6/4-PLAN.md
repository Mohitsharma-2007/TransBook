---
phase: 6
plan: 4
wave: 4
---

# Plan 6.4: Inno Setup Installer

## Objective
Create the Inno Setup installer script to package the Flutter Windows build into a professional installer.

## Context
- `e:\TransBook\TRD.md` -> Section 10 (Installer)

## Tasks

<task type="auto">
  <name>Inno Setup Script</name>
  <files>
    - `e:\TransBook\installer\transbook_setup.iss`
  </files>
  <action>
    - Create Inno Setup `.iss` script with:
      - App metadata: Trans Book v1.0.0, JSV Technologies publisher.
      - Source from `build\windows\x64\runner\Release\*`.
      - Desktop + Start Menu shortcuts.
      - Post-install launch option.
      - File association for `.tbk` backup files.
      - Compression: lzma2/ultra64.
      - Min version: Windows 10 2004+ (10.0.19041).
      - x64 only.
  </action>
  <verify>Test-Path installer/transbook_setup.iss</verify>
  <done>ISS script exists and matches TRD spec.</done>
</task>

<task type="auto">
  <name>Build & Package Script</name>
  <files>
    - `e:\TransBook\scripts\build_installer.ps1`
  </files>
  <action>
    - Create PowerShell script that:
      1. Runs `flutter build windows --release`
      2. Invokes Inno Setup Compiler on the .iss file
      3. Outputs installer to `dist/` folder
    - Make it a one-command build-and-package workflow.
  </action>
  <verify>Test-Path scripts/build_installer.ps1</verify>
  <done>Build script exists with flutter build + Inno compile steps.</done>
</task>

## Success Criteria
- [ ] Inno Setup .iss file matches TRD specification.
- [ ] Build script automates the full package workflow.
