# PowerPlatformAssetInventory

PowerPlatformAssetInventory est un module PowerShell en lecture seule qui dresse l'inventaire des applications et des flux Power Platform avec leur environnement et leur propriétaire.

## Pourquoi maintenant

Un administrateur Power Platform doit souvent répondre à une question simple. Quels actifs critiques appartiennent à des personnes qui ont quitté l'organisation? Pour y répondre, il faut croiser plusieurs vues d'administration, l'annuaire des utilisateurs, la liste des connecteurs et les réglages de partage. L'information existe déjà dans votre locataire. La rassembler prend du temps.

Le 25 octobre 2026, Microsoft a présenté le plugin Power Platform Admin pour Copilot Cowork qui vise à réduire ce travail manuel en répondant à ces questions en langage naturel. Ce module reprend l'approche classique en lecture seule décrite dans l'article de Charles Jenkins. Il reste utile même si vous n'activez pas Cowork.

Si vous activez le plugin dans Cowork, créez d'abord une politique de facturation à l'usage dans le Centre d'administration Microsoft 365. Selon Microsoft Learn, les administrateurs doivent mettre en place une politique de facturation avant qu'un utilisateur se serve des expériences qui exigent la facturation à l'usage.

## Ce que fait l'outil

- Il se connecte à Power Platform avec `Add-PowerAppsAccount`.
- Il liste les applications avec `Get-AdminPowerApp`.
- Avec `-IncludeFlows`, il ajoute les flux listés avec `Get-AdminFlow`.
- Il retourne des objets PowerShell que vous pouvez trier, filtrer ou exporter.
- Il ne modifie jamais le locataire.

## Prérequis

- PowerShell 5.1 ou une version plus récente.
- Le module `Microsoft.PowerApps.Administration.PowerShell`.
- Un rôle d'administration suffisant. Le script de l'article indique le rôle Administrateur Power Platform ou Administrateur général.

## Installation

```powershell
Install-Module Microsoft.PowerApps.Administration.PowerShell -Scope CurrentUser
Import-Module .\PowerPlatformAssetInventory.psd1
```

## Utilisation

Inventaire des applications avec connexion interactive.

```powershell
Get-PowerPlatformAssetInventory
```

Inventaire des applications et des flux.

```powershell
Get-PowerPlatformAssetInventory -IncludeFlows
```

Réutiliser une session Power Platform déjà ouverte.

```powershell
Get-PowerPlatformAssetInventory -SkipConnection
```

Produire un rapport HTML à partir de l'inventaire complet.

```powershell
Get-PowerPlatformAssetInventory -IncludeFlows |
    Export-PowerPlatformAssetReport -Path .\inventaire-power-platform.html
```

Voir ce qui serait écrit sans créer le fichier.

```powershell
Get-PowerPlatformAssetInventory |
    Export-PowerPlatformAssetReport -Path .\inventaire.html -WhatIf
```

## Exemple de sortie

Les valeurs ci-dessous sont fictives et servent uniquement d'illustration.

```
AssetType    DisplayName            EnvironmentName                                 Owner
---------    -----------            ---------------                                 -----
Application  Suivi des commandes    Default-00000000-0000-0000-0000-000000000000    Alex Fournier
Application  Tableau des conges     Default-00000000-0000-0000-0000-000000000000
Flow         Rappel d'approbation   Default-00000000-0000-0000-0000-000000000000    Sam Tremblay
```

Lisez la colonne du propriétaire pour repérer les applications sans propriétaire clair ou concentrées sur une seule personne. C'est la même question que le plugin traite en langage naturel.

## Limites connues

- Le module lit uniquement les données. Il ne modifie jamais le locataire.
- L'outil utilise `Add-PowerAppsAccount` pour la connexion, `Get-AdminPowerApp` pour les applications et `Get-AdminFlow` pour les flux. Ces cmdlets proviennent du module `Microsoft.PowerApps.Administration.PowerShell`. L'article rappelle de confirmer la version du module ainsi que les noms des propriétés dans la documentation Microsoft avant de vous y fier.
- Le propriétaire des flux suit le même modèle que celui des applications selon l'article. Validez la propriété `Owner` des flux dans votre locataire.
- Dès que vous produisez un rapport par propriétaire, vous traitez des renseignements personnels de votre personnel. La Loi 25 s'applique. Limitez l'accès à ces constats et vérifiez le contenu du rapport ainsi que ses permissions de partage avant de le distribuer.
- Ce module ne remplace pas vos solutions de gouvernance. Il complète les vues d'administration que vous utilisez déjà.

## Article et sources

- Article de Charles Jenkins: https://trivium365.com/blog/plugin-power-platform-admin-cowork-gouvernance-langage-naturel/
- Introducing the Power Platform Admin Plugin in Cowork: Agentic Governance with Natural Language, Copilot Studio Blog: https://techcommunity.microsoft.com/blog/copilot-studio-blog/introducing-the-power-platform-admin-plugin-in-cowork-agentic-governance-with-na/4567557
- User subscription license and usage-based billing, Microsoft Learn: https://learn.microsoft.com/fr-fr/microsoft-365/copilot/user-subscription-license-usage-based-billing
