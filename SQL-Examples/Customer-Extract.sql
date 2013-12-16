
SET NOCOUNT ON
 set fmtonly off;





 
SELECT DISTINCT
      [CustomerID] as CustomerID
  INTO #OilCustomers   
  FROM [BIDW].[dbo].[vwBUUsedOil]
  WHERE FiscalYearNum >= 2010 and [CUSTOMERID]  <> 10129126;

 

  
 With Employees as

(


SELECT row_number()  over (Partition by e.[EmployeeNumber] ORDER BY e.[DateTo] desc) as ID
  ,[EmployeeNumber] as EmployeeID
    ,[EmployeeName] as EmployeeName
     
  FROM [BIDW].[dbo].[vwBUEmployee] e
WHERE LEN([EmployeeName]) > 1

)


,


 
 
Customers as

(

SELECT cd.[CUSTOMERID] as CustomerID
    
        ,Case When len([ChainID]) < 1 or [ChainID] is null
  Then cd.[CUSTOMERID] Else [ChainID] end as ChainID
  ,Case When [CorporateParentID] = 0 and [ChainID] is null Then cd.[CUSTOMERID]
  When [CorporateParentID] is null and [ChainID] is not null Then [ChainID]
  Else [CorporateParentID] end as ParentID
     
  FROM [BIDW].[dbo].[vwBUCustomerDetail] cd
 
 WHERE [CUSTOMERID]  <> 10129126
  )
 
  ,
 

 
  Names as
 
  (
 
  SELECT cd.[CUSTOMERID] as CustomerID
      ,[CustomerName] as Name
     
  FROM [BIDW].[dbo].[vwBUCustomerDetail] cd
 WHERE cd.[CUSTOMERID]  <> 10129126
 
  )
 
 
  ,


  Products as
 
 
 
(
SELECT Cast([MaterialNumber] as int) as ProductID
      ,[MaterialName] as Product
      ,[Level1HierarchyCode]
      ,[Level1HierarchyDescription]
      ,[Level2HierarchyCode]
      ,[Level2HierarchyDescription]
      ,[Level3HierarchyCode]
      ,[Level3HierarchyDescription]
      ,[Level4HierarchyCode]
      ,[Level4HierarchyDescription]
  FROM [BIDW].[dbo].[vwBUMaterial]
WHERE [Level1HierarchyCode] is not null and IsNumeric([MaterialNumber]) = 1
)
 








SELECT cd.[CUSTOMERID] as cuCustomerID
      ,cd.[CustomerName] as cuCustomerName
      ,cd.[Street1] as cuAddress
      ,cd.[CITY] as cuCity
      ,cd.[County] as cuCounty
      ,cd.[State] as cuState
      ,cd.[PostalCode] as cuZipCode
      ,cd.[COUNTRY] as cuCountry
      ,cd.[PHONE] as cuPhone
      
      ,c1.ChainID as cuChainID
      ,n2.Name as cuChainName
      ,c1.ParentID as cuParentID
      ,n3.Name as cuParentName
      
   ,CASE WHEN c1.ParentID <> c1.ChainID then 'Strategic' ELSE 'Branch' END AS cuAccountType
      
      ,cd.[CustomerClass] as cuCustomerClass
      ,cd.[CustomerSegment] as cuSegmentCodeID
      ,cd.[SegmentCodeDescription] as cuSegmentCode
      ,Cast(cd.[SICCode] as int) as cuSICCode
   ,CASE WHEN cd.[CustomerSegment] <=18 THEN 'Automotive'
   WHEN cd.[CustomerSegment] >=20 and cd.[CustomerSegment]<=54 THEN 'Industrial'
   WHEN cd.[CustomerSegment] >=56 and cd.[CustomerSegment]<=97 THEN 'Specialty'
   END AS cuSegmentGroup

   ,CASE WHEN cd.[CustomerSegment] in ('1','2','3','4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '35', '62', '63', '72', '73', '74', '75', '76', '82', '92', '93', '95', '96', '97') THEN 'Auto' ELSE 'Non-Auto' END AS cuSegmentProfile
   
      
      ,cd.[CreateDate] as cuCreateDate


     
  FROM [BIDW].[dbo].[vwBUCustomerDetail] cd


INNER JOIN #OilCustomers  o on cd.CustomerID = o.CustomerID
LEFT JOIN Customers c1 on cd.CustomerID = c1.CustomerID
LEFT JOIN Customers c2 on c1.ParentID = c2.CustomerID
LEFT JOIN Names n on c1.CustomerID = n.CustomerID
LEFT JOIN  Names n2 on c1.ChainID = n2.CustomerID
LEFT JOIN  Names n3 on c1.ParentID = n3.CustomerID






 DROP TABLE #OilCustomers

