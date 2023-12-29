USE [ELMA]
GO

SELECT *
  FROM [dbo].DepositoryGroup 
  WHERE IsDeleted = 0
GO


SELECT DISTINCT [dbo].RegistrationPlace.Name, [dbo].DepositoryGroup.Name,[dbo].DepositoryGroup.ParentGroup 
  FROM [dbo].RegistrationPlace
    INNER JOIN [dbo].[RegistrationPlaceItem] ON [dbo].[RegistrationPlaceItem].RegistrationPlace = [dbo].[RegistrationPlace].Id
	INNER JOIN [dbo].DepositoryGroup ON [dbo].DepositoryGroup.ParentGroup = [dbo].[RegistrationPlaceItem].Id
  WHERE AccountingYear = 506
  AND IsDeleted = 0
  AND [dbo].DepositoryGroup.HardDelete = 0
  ORDER BY ([dbo].RegistrationPlace.Name)
GO

SELECT DISTINCT *
  FROM [dbo].RegistrationPlace
    INNER JOIN [dbo].[RegistrationPlaceItem] ON [dbo].[RegistrationPlaceItem].RegistrationPlace = [dbo].[RegistrationPlace].Id
	INNER JOIN [dbo].DepositoryGroup ON [dbo].DepositoryGroup.ParentGroup = [dbo].[RegistrationPlaceItem].Id
  WHERE AccountingYear = 506
  AND IsDeleted = 0
  AND [dbo].DepositoryGroup.HardDelete = 0
  ORDER BY ([dbo].RegistrationPlace.Name)
GO

SELECT *
  FROM [dbo].RegistrationPlaceItem 

  WHERE AccountingYear = 506
GO

SELECT *
  FROM [dbo].RegistrationPlace

GO

