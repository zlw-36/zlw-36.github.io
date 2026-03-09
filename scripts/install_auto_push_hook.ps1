#!/usr/bin/env pwsh
# 在本地仓库安装一个简单的 post-commit hook，自动在每次提交后执行 `git push`

$hookPath = Join-Path -Path ".git" -ChildPath "hooks\post-commit"

$hookContent = '@echo off\r\nrem 自动生成的 post-commit hook：提交后自动推送\r\n"%~dp0..\..\git" push --no-verify 2>nul || git push --no-verify\r\n'

try {
    if (-not (Test-Path -Path ".git")) {
        Write-Error "当前目录不是 Git 仓库（未找到 .git 目录）。请在仓库根目录运行此脚本。"
        exit 1
    }
    Set-Content -Path $hookPath -Value $hookContent -Encoding ASCII
    # 确保 hook 可执行（在 Unix 平台）
    if ($IsLinux -or $IsMacOS) {
        & chmod +x $hookPath
    }
    Write-Host "已安装 post-commit hook： $hookPath"
} catch {
    Write-Error "安装 hook 时出错： $_"
    exit 1
}
