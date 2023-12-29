USE [ELMA]
GO

SELECT 
     Concat([FirstName],' ',[SecondName], ' ',[MiddleName]) as Name
     ,[FirstName]
     ,[SecondName]
     ,[MiddleName]
     ,[Name]  as DocumentType
     ,[DocumentNumber]
     ,[DocumentEndDate]
     ,[DocumentIssued]
     ,[DocumentIssueDate]
     ,[DocumentSeries]
	FROM [dbo].[ContractorIndividual]
INNER JOIN [dbo].[ClientDocumentType] ON [dbo].[ContractorIndividual].DocumentType = [dbo].[ClientDocumentType].Id
	ORDER BY [dbo].[ClientDocumentType].Name asc 
	OFFSET 0 ROWS 
	FETCH NEXT 100000 ROWS ONLY;


SELECT * FROM DBO.ContractorIndividual
	INNER JOIN DBO.Contractor ON Concat(DBO.ContractorIndividual.[FirstName],' ',DBO.ContractorIndividual.[SecondName], ' ',DBO.ContractorIndividual.[MiddleName]) = DBO.Contractor.Name
ORDER BY  DBO.Contractor.Name asc 
	OFFSET 0 ROWS 
FETCH NEXT 1000 ROWS ONLY;
