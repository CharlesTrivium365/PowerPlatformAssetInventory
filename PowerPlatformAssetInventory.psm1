#Requires -Version 5.1

function Get-PowerPlatformAssetInventory {
    <#
    .SYNOPSIS
        Dresse l'inventaire en lecture seule des applications et des flux Power Platform avec leur proprietaire.

    .DESCRIPTION
        Get-PowerPlatformAssetInventory se connecte a Power Platform avec Add-PowerAppsAccount puis liste les
        applications avec Get-AdminPowerApp. Avec le parametre IncludeFlows, il ajoute les flux listes avec
        Get-AdminFlow. Chaque actif est retourne sous forme d'objet PowerShell avec son type, son nom
        d'affichage, son environnement et son proprietaire.

        La fonction ne modifie jamais le locataire. Elle sert a reperer les applications et les flux sans
        proprietaire clair ou concentres sur une seule personne. Validez les resultats avant toute action.

        Les cmdlets Add-PowerAppsAccount, Get-AdminPowerApp et Get-AdminFlow proviennent du module
        Microsoft.PowerApps.Administration.PowerShell. Confirmez la version du module et les noms des
        proprietes dans la documentation Microsoft avant de vous y fier.

    .PARAMETER IncludeFlows
        Ajoute les flux a l'inventaire en plus des applications. Les flux sont listes avec Get-AdminFlow.

    .PARAMETER SkipConnection
        N'appelle pas Add-PowerAppsAccount. Utilisez ce parametre si une session Power Platform est deja ouverte.

    .EXAMPLE
        Get-PowerPlatformAssetInventory

        Se connecte a Power Platform puis liste les applications avec leur environnement et leur proprietaire.

    .EXAMPLE
        Get-PowerPlatformAssetInventory -IncludeFlows

        Liste les applications et les flux de tous les environnements accessibles.

    .EXAMPLE
        Get-PowerPlatformAssetInventory -IncludeFlows | Export-PowerPlatformAssetReport -Path .\inventaire.html

        Produit un rapport HTML a partir de l'inventaire complet.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .LINK
        https://trivium365.com/blog/plugin-power-platform-admin-cowork-gouvernance-langage-naturel/
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [switch]$IncludeFlows,

        [switch]$SkipConnection
    )

    begin {
        $moduleName = 'Microsoft.PowerApps.Administration.PowerShell'
        if (-not (Get-Module -Name $moduleName -ListAvailable)) {
            throw "Le module $moduleName est requis. Installez-le avec Install-Module $moduleName."
        }

        if (-not $SkipConnection) {
            Write-Verbose 'Connexion a Power Platform avec Add-PowerAppsAccount.'
            Add-PowerAppsAccount | Out-Null
        }
    }

    process {
        Write-Verbose 'Lecture des applications avec Get-AdminPowerApp.'
        foreach ($app in Get-AdminPowerApp) {
            [pscustomobject]@{
                AssetType = 'Application'
                DisplayName = $app.DisplayName
                EnvironmentName = $app.EnvironmentName
                Owner = $app.Owner.displayName
            }
        }

        if ($IncludeFlows) {
            Write-Verbose 'Lecture des flux avec Get-AdminFlow.'
            foreach ($flow in Get-AdminFlow) {
                [pscustomobject]@{
                    AssetType = 'Flow'
                    DisplayName = $flow.DisplayName
                    EnvironmentName = $flow.EnvironmentName
                    Owner = $flow.Owner.displayName
                }
            }
        }
    }
}

function Export-PowerPlatformAssetReport {
    <#
    .SYNOPSIS
        Produit un rapport HTML simple a partir d'un inventaire Power Platform.

    .DESCRIPTION
        Export-PowerPlatformAssetReport transforme les objets produits par Get-PowerPlatformAssetInventory en
        un rapport HTML autonome avec un tableau. Le rapport est ecrit dans le fichier indique par le
        parametre Path.

        Cette fonction ecrit un fichier sur le disque. Elle prend en charge -WhatIf et -Confirm.

    .PARAMETER InputObject
        Les objets d'inventaire a inclure dans le rapport. Acceptes depuis le pipeline.

    .PARAMETER Path
        Chemin du fichier HTML a creer.

    .EXAMPLE
        Get-PowerPlatformAssetInventory | Export-PowerPlatformAssetReport -Path .\inventaire.html

        Ecrit le rapport HTML des applications dans inventaire.html.

    .EXAMPLE
        Get-PowerPlatformAssetInventory -IncludeFlows | Export-PowerPlatformAssetReport -Path .\inventaire.html -WhatIf

        Montre ce qui serait ecrit sans creer le fichier.

    .OUTPUTS
        System.IO.FileInfo
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject[]]$InputObject,

        [Parameter(Mandatory)]
        [string]$Path
    )

    begin {
        $items = [System.Collections.Generic.List[psobject]]::new()
    }

    process {
        foreach ($item in $InputObject) {
            $items.Add($item)
        }
    }

    end {
        if ($PSCmdlet.ShouldProcess($Path, 'Ecrire le rapport HTML')) {
            $head = '<title>Inventaire Power Platform</title><style>body{font-family:Segoe UI,Arial,sans-serif;margin:2em;}table{border-collapse:collapse;width:100%;}th,td{border:1px solid #ccc;padding:6px 10px;text-align:left;}th{background:#f2f2f2;}</style>'
            $preContent = '<h1>Inventaire des actifs Power Platform</h1><p>Rapport en lecture seule. Verifiez le contenu et les permissions de partage avant de le distribuer.</p>'
            $html = $items | ConvertTo-Html -Head $head -PreContent $preContent
            Set-Content -Path $Path -Value $html -Encoding UTF8
            Get-Item -Path $Path
        }
    }
}

Export-ModuleMember -Function 'Get-PowerPlatformAssetInventory', 'Export-PowerPlatformAssetReport'
