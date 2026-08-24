param(
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildRoot = [System.IO.Path]::Combine($repoRoot, "dist", "build", "openai")
$stageRoot = [System.IO.Path]::Combine($buildRoot, "management-consulting")

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = [System.IO.Path]::Combine($repoRoot, "dist", "management-consulting-openai.zip")
}

$resolvedRepoRoot = [System.IO.Path]::GetFullPath($repoRoot)
$resolvedBuildRoot = [System.IO.Path]::GetFullPath($buildRoot)
if (-not $resolvedBuildRoot.StartsWith($resolvedRepoRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to build outside the repository."
}

if (Test-Path -LiteralPath $buildRoot) {
    Remove-Item -LiteralPath $buildRoot -Recurse -Force
}

$claudeManifestDirectory = [System.IO.Path]::Combine($stageRoot, ".claude-plugin")
$codexManifestDirectory = [System.IO.Path]::Combine($stageRoot, ".codex-plugin")
New-Item -ItemType Directory -Path $claudeManifestDirectory -Force | Out-Null
New-Item -ItemType Directory -Path $codexManifestDirectory -Force | Out-Null

Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, ".claude-plugin", "plugin.json")) -Destination ([System.IO.Path]::Combine($claudeManifestDirectory, "plugin.json"))
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, ".codex-plugin", "plugin.json")) -Destination ([System.IO.Path]::Combine($codexManifestDirectory, "plugin.json"))
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, "skills")) -Destination $stageRoot -Recurse
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, "assets")) -Destination $stageRoot -Recurse
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, "LICENSE")) -Destination $stageRoot
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, "PRIVACY.md")) -Destination $stageRoot
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, "TERMS.md")) -Destination $stageRoot
Copy-Item -LiteralPath ([System.IO.Path]::Combine($repoRoot, "README.md")) -Destination $stageRoot

$resolvedOutputPath = [System.IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $resolvedOutputPath) {
    Remove-Item -LiteralPath $resolvedOutputPath -Force
}

$outputDirectory = Split-Path -Parent $resolvedOutputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

# CreateFromDirectory includes dot-directories on every platform supported by
# PowerShell, which keeps both plugin manifests in the upload archive.
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    $buildRoot,
    $resolvedOutputPath,
    [System.IO.Compression.CompressionLevel]::Optimal,
    $false
)
Write-Output "Wrote $resolvedOutputPath"
