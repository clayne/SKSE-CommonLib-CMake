# This small PowerShell Script fixes the self-referencing imports in the SKSE codebase.
# The problem is the following:
# #include "common/Something.h" inside the common project
# this include makes no sense since you already are in the common project and makes everything complicated because
# you have to fix your imports and use AdditionalIncludeDirectories to include the top level directory of the common
# project which makes no fucking sense at all so why even do this? I have no fucking idea so I'm just ranting about
# as I write this little script.

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [String]
    $Folder,

    [Parameter(Mandatory=$true)]
    [String]
    $Prefix
)

Begin{}
Process{
    Write-Output "Fixing imports in $Folder"

    $Items = Get-ChildItem -Path $Folder -Include ("*.h", "*.cpp") -File -Name
    foreach ($item in $Items) {
        Write-Output "Editing File $Folder\$item"
        $content = Get-Content -Path $Folder\$item
        $content = $content -creplace "#include `"$Prefix/", "#include `""
        Set-Content -Path $Folder\$item -Value $content
    }
}
End{}