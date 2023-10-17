/********* Create a Flood Hotspot table - this is at the site level so it is essentially a flag which specifies if a site has a high chance of having floods on it
This does not tell you anything about individual assets on the sites but it could give the network a greater ability to find causal interference ********/
	Select A.SiteID
	INTO #FloodHotspots
	Fro
		-- It's had at least 2 flood incidents in the last 5 years
	(SELECT DISTINCT
        A.SiteID
        FROM DDMS.FloodIncident AS FI
        JOIN CONFIRM.Asset AS A
        ON FI.SectionID = A.AssetID
		AND A.IsDeletedFlag = 0
		AND A.IsCurrentFlag = 1
        WHERE FI.ReportedDateTime
        BETWEEN DATEADD(YEAR, -5, GETDATE()) AND GETDATE()
        GROUP BY FI.SectionID, A.SiteID
        HAVING COUNT(FI.SectionID) >= 2
    UNION
        -- or at least 1 severe (FSI>=7) flood
        SELECT DISTINCT
            A.SiteID
        FROM DDMS.FloodIncident AS FI
        JOIN CONFIRM.Asset AS A
        ON FI.SectionID = A.AssetID
		AND A.IsDeletedFlag = 0
		AND A.IsCurrentFlag = 1
        WHERE FI.FloodSeverityIndex >= 7
    UNION
        -- or at least 1 third party property was affected
        SELECT DISTINCT
            A.SiteID
        FROM DDMS.FloodIncident AS FI
        JOIN CONFIRM.Asset AS A
        ON FI.SectionID = A.AssetID
		AND A.IsDeletedFlag = 0
		AND A.IsCurrentFlag = 1
        WHERE FI.ThirdPartyImpact NOT IN ( 'None', '[Not Determind]' )) A


/******** Below is the main data engineering to extract maintenance activities, both cyclic and reactive along with the percentage full statistic
***********/
Select * from (Select FJ.JobID
	,FJ.CentralAssetID
	,FJ.SiteID
	,FJ.PlotNo
	,FJ.AssetTypeID
	,FJ.LogNo
	,FJ.EntryDateTime
	,FJ.Notes
	,FJ.JobTypeID
	,FJ.JobTypeCode
	,FJ.JobTypeName
	,CASE 
    When Right(fj.JobStatusID,3) LIKE '%[0-9]%' 
    then Cast(Right(FJ.JobStatusID,3) as Int)
    Else 000
    End as JobStatusID
	,CASE 
	When SiteID in (Select SiteID from #FloodHotspots)
	Then 1
	Else 0
	End as FloodHotspot
	,FJ.JobStatusName
	,FJ.PriorityID
	,FJ.PriorityName
	,FJ.ActualStartingDateTime
	,FJ.ActualCompletionDateTime
	,FJ.ActualCompletionYearMonth
	,FJ.RouteID
	,jpv.ParameterTypeID
	,jpv.ParameterValueID
	,jpv.IsDeletedFlag
	,jpv.IsCurrentFlag
	,jpv.ValidFromDateTime
	,jpv.ValidToDateTime
	,jpv.InsertedDateTime
	,JI.JobItemID
	,JI.SorItemID
FROM [CONFIRM].[JobParameterValue] jpv
  JOIN CONFIRM_Consumption.factjob fj
  on Jpv.JobID = FJ.JobID
  and fj.AssetTypeID = 'DRGU'
and jpv.ParameterTypeID = '%FUL'
and fj.ActualCompletionDateTime is not null
  LEFT JOIN CONFIRM.JobItem JI
  on JI.JobID = fj.JobID
  and JI.IsDeletedFlag = 0 
  and JI.IsCurrentFlag = 1
  and jpv.IsCurrentFlag =1
  and jpv.IsDeletedFlag = 0) a where a.JobStatusID >= 400
   -- and a.JobTypeCode like 'B%'
  
  /********* Below is some code to understand how many interventions per asset there is to get an idea of the range of interventions per asset 
  This is essentially scoping the amount of data we will have available *********/
/*
Select MIN(a.countOfInterventions) as MinimumInterventions ,Max(a.countOfInterventions) MaximumInterventions from (Select FJ.SiteID, FJ.PlotNo, count(*) as countOfInterventions  From
[CONFIRM].[JobParameterValue] jpv
  JOIN CONFIRM_Consumption.factjob fj
  on Jpv.JobID = FJ.JobID
  JOIN CONFIRM.JobItem JI
  on JI.JobID = fj.JobID
  and JI.IsDeletedFlag = 0 
  and JI.IsCurrentFlag = 1
and fj.AssetTypeID = 'DRGU'
and jpv.ParameterTypeID = '%FUL'
and fj.ActualCompletionDateTime is not null and fj.JobStatusID LIKE '%[0-9]%' and Cast(Right(fj.JobStatusID,3) as Int) >= 400
group by fj.SiteID, fj.PlotNo) a

Select MIN(FJ.EntryDateTime) as OldestDate, Max(FJ.EntryDateTime) as NewestDate From
[CONFIRM].[JobParameterValue] jpv
  JOIN CONFIRM_Consumption.factjob fj
  on Jpv.JobID = FJ.JobID
  JOIN CONFIRM.JobItem JI
  on JI.JobID = fj.JobID
  and JI.IsDeletedFlag = 0 
  and JI.IsCurrentFlag = 1 
and fj.AssetTypeID = 'DRGU'
and jpv.ParameterTypeID = '%FUL'
and fj.ActualCompletionDateTime is not null and fj.JobStatusID LIKE '%[0-9]%' and Cast(Right(fj.JobStatusID,3) as Int) >= 400
*/
  