# Journal des modifications

Le format suit les principes de Keep a Changelog.

## [1.0.0] - 2026-10-29

### Ajouté
- Fonction `Get-PowerPlatformAssetInventory` qui liste en lecture seule les applications et les flux Power Platform avec leur type, leur nom d'affichage, leur environnement et leur propriétaire.
- Paramètre `-IncludeFlows` pour ajouter les flux à l'inventaire.
- Paramètre `-SkipConnection` pour réutiliser une session Power Platform déjà ouverte.
- Fonction `Export-PowerPlatformAssetReport` qui produit un rapport HTML simple à partir des résultats et qui prend en charge `-WhatIf` et `-Confirm`.
