# Syncs android/app/google-services.json from Firebase.
# Requires: Firebase CLI (npm i -g firebase-tools) and: firebase login
#
# 1) Firebase Console -> Project settings -> Android app -> Add fingerprint
#    (Play: App signing key SHA-1 from Play Console)
# 2) From repo root:
#    powershell -ExecutionPolicy Bypass -File tools/sync_android_google_services.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root
$out = Join-Path $root "android\app\google-services.json"
Write-Host "Writing: $out"
if (Test-Path $out) { Remove-Item -Force $out }
firebase apps:sdkconfig ANDROID "1:696315304984:android:3e94f4ff56bf05e3c0b76d" -o $out
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Done. Rebuild: flutter build appbundle --release"
