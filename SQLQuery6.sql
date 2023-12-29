USE [ELMA]
GO

SELECT 
 count(*)
 FROM [dbo].[Contractor]
 INNER JOIN [dbo].[ContractorLegal] ON [dbo].[Contractor].Id =  [dbo].[ContractorLegal].Id
 WHERE IsDeleted = 0 AND HardDelete = 0
GO


SELECT * FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ContractorIndividual' or TABLE_NAME = 'Contractor';


SELECT * FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'BCCColvirClient';
SELECT TOP 100 * FROM BCCColvirClient
select count(*) from BCCColvirClient;
SELECT top 10
			FirstName,
			SecondName,
			MiddleName,
			DocumentType,
			DocumentSeries,
			DocumentNumber,
			DocumentIssued,
			DocumentIssueDate,
			DocumentEndDate
			Code,
			IINBIN,
			INN,
			Type
FROM DBO.ContractorIndividual
	INNER JOIN DBO.Contractor ON Concat(DBO.ContractorIndividual.[FirstName],' ',DBO.ContractorIndividual.[SecondName], ' ',DBO.ContractorIndividual.[MiddleName]) = DBO.Contractor.Name
WHERE IsDeleted = 0 AND HardDelete = 0

SELECT top 100 * FROM DBO.Contractor


SELECT top 100 * FROM DBO.ContractorIndividual