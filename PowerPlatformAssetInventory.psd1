@{
    RootModule        = 'PowerPlatformAssetInventory.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd7a2e8c4-5f3b-4a19-9c6e-2b8f1a0d4e73'
    Author            = 'Charles Jenkins'
    Copyright         = '(c) 2026 Charles Jenkins. Licence MIT.'
    Description       = 'Module PowerShell en lecture seule qui inventorie les applications et les flux Power Platform avec leur environnement et leur proprietaire.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Get-PowerPlatformAssetInventory', 'Export-PowerPlatformAssetReport')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags = @('PowerPlatform', 'Governance', 'Inventory', 'ReadOnly', 'PowerApps')
        }
    }
}
