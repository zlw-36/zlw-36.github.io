#!/usr/bin/env pwsh
Param(
    [string]$Summary = ""
)

# Stage 所有更改
git add -A

# 获取变更文件列表
$lines = & git status --porcelain
if (-not $lines) {
    Write-Host "没有待提交的更改。"
    exit 0
}
$files = @()
foreach ($l in $lines) {
    if ($l.Length -ge 4) {
        $files += $l.Substring(3).Trim()
    }
}
$files = $files | Select-Object -Unique
$filesList = ($files -join ", ")

if ($Summary -ne "") {
    $msg = "自动提交: $Summary"
} else {
    $msg = "自动提交: 修改 $filesList"
}

git commit -m $msg
if ($LASTEXITCODE -ne 0) {
    Write-Error "git commit 失败"
    exit $LASTEXITCODE
}

git push
if ($LASTEXITCODE -ne 0) {
    Write-Error "git push 失败"
    exit $LASTEXITCODE
}

Write-Host "已推送: $msg"
