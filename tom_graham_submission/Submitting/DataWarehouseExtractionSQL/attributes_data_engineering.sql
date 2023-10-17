IF OBJECT_ID(N'tempdb..#Temp_AAM') IS NOT NULL
BEGIN
	DROP TABLE #Temp_AAM
END
 
 SELECT distinct 
			   AAT.SiteID,
               AAT.PlotNo,
               AAT.AttributeTypeID,
			   AAT.AttributeValueID AS AVValueID,
			   AV.[Name] AS AVValueName
		INTO #Temp_AAM
        FROM CONFIRM.AssetAttributeType AS AAT
			inner join CONFIRM.[Asset] A
			on A.SiteID = AAT.SiteID and A.PlotNo = AAT.PlotNo AND A.IsDeletedFlag = 0
			and A.IsCurrentFlag = 1
			and A.AssetTypeID = 'DRGU'
            INNER JOIN CONFIRM.AttributeValue AS AV
                ON AAT.AttributeValueID = AV.AttributeValueID
                   AND AAT.AttributeTypeID = AV.AttributeTypeID
                   AND AV.IsCurrentFlag = 1 AND AV.[IsDeletedFlag] = 0
            LEFT JOIN CONFIRM.AssetMeasurementType AS AMT
                ON AMT.SiteID = AAT.SiteID
                   AND AMT.PlotNo = AAT.PlotNo
				   AND AMT.IsCurrentFlag = 1 AND AMT.[IsDeletedFlag] = 0 
		WHERE AAT.AttributeTypeID IN ('HD41','VALI','HD21','HD40','TMAR','HD55','HD33','HD19','ISEC','HD51','HD05','HD37','HD30','HD48','HD36','XSP ','HD42','HD60','HD35','HD53'
,'HD11','HD32','HD29','HD17','HD44','HD27','HD47','HD24','HD38','HD12','HD09','HD20','HD43','HD26','HD01','HD57','HD46','HD06','HD66','HD54','ZZZZ','HD07','IT62','HD75','HD15','HD56','HD72'
,'HD39','HD14','HD16','HD28','HD65','HD25','HD03','HD63','HD10','HD34','HD08','HD04','HD31','HD59','HD23','HD49','HD52','HD76','HD64','HD45','CYRT','HD02','HD22','HD50','HD61','HD62'
,'HD13','HD18','HD58','HD69')
			AND AAT.[IsDeletedFlag] = 0 and AAT.[IsCurrentFlag] = 1

;with AVValueID AS (
select * FROM #Temp_AAM AS SourceTable
PIVOT
    (
        MAX(AVValueID)
        FOR AttributeTypeID IN (
			[HD41] ,[VALI] ,[HD21] ,[HD40] ,[TMAR] ,[HD55] ,[HD33] ,[HD19] ,[ISEC] ,[HD51] ,[HD05] ,[HD37] ,[HD30] ,[HD48] ,[HD36] ,[XSP] ,[HD42]
,[HD60] ,[HD35],[HD53],[HD11],[HD32],[HD29],[HD17],[HD44],[HD27],[HD47],[HD24],[HD38],[HD12],[HD09],[HD20],[HD43],[HD26],[HD01],[HD57],[HD46],[HD06],[HD66]
,[HD54],[ZZZZ],[HD07],[IT62],[HD75],[HD15],[HD56],[HD72],[HD39],[HD14],[HD16],[HD28],[HD65],[HD25],[HD03],[HD63],[HD10],[HD34],[HD08],[HD04],[HD31],[HD59],[HD23]
,[HD49],[HD52],[HD76],[HD64],[HD45],[CYRT],[HD02],[HD22],[HD50],[HD61],[HD62],[HD13],[HD18],[HD58],[HD69])
    ) AS PivotTable
)

/*
,AVValueName AS (
select * FROM #Temp_AAM AS SourceTable
PIVOT
    (
        MAX(AVValueName)
        FOR AttributeTypeID IN (
			[HD41] ,[VALI] ,[HD21] ,[HD40] ,[TMAR] ,[HD55] ,[HD33] ,[HD19] ,[ISEC] ,[HD51] ,[HD05] ,[HD37] ,[HD30] ,[HD48] ,[HD36] ,[XSP] ,[HD42]
,[HD60] ,[HD35],[HD53],[HD11],[HD32],[HD29],[HD17],[HD44],[HD27],[HD47],[HD24],[HD38],[HD12],[HD09],[HD20],[HD43],[HD26],[HD01],[HD57],[HD46],[HD06],[HD66]
,[HD54],[ZZZZ],[HD07],[IT62],[HD75],[HD15],[HD56],[HD72],[HD39],[HD14],[HD16],[HD28],[HD65],[HD25],[HD03],[HD63],[HD10],[HD34],[HD08],[HD04],[HD31],[HD59],[HD23]
,[HD49],[HD52],[HD76],[HD64],[HD45],[CYRT],[HD02],[HD22],[HD50],[HD61],[HD62],[HD13],[HD18],[HD58],[HD69])
    ) AS PivotTable
) */


Select 
	AV.SiteID
	,AV.PlotNo
	,MAX(av.[HD41]) as HD41
	,MAX(av.[VALI]) as VALI
	,MAX(av.[HD21]) as HD21
	,MAX(av.[HD40]) as HD40
	,MAX(av.[TMAR]) as TMAR
	,MAX(av.[HD55]) as HD55
	,MAX(av.[HD33]) as HD33
	,MAX(av.[HD19]) as HD19
	,MAX(av.[ISEC]) as ISEC
	,MAX(av.[HD51]) as HD51
	,MAX(av.[HD05]) as HD05
	,MAX(av.[HD37]) as HD37
	,MAX(av.[HD30]) as HD30
	,MAX(av.[HD48]) as HD48
	,MAX(av.[HD36]) as HD36
	,MAX(av.[XSP] ) as XSP
	,MAX(av.[HD42]) as HD42
	,MAX(av.[HD60]) as HD60
	,MAX(av.[HD35]) as HD35
	,MAX(av.[HD53]) as HD53
	,MAX(av.[HD11]) as HD11
	,MAX(av.[HD32]) as HD32
	,MAX(av.[HD29]) as HD29
	,MAX(av.[HD17]) as HD17
	,MAX(av.[HD44]) as HD44
	,MAX(av.[HD27]) as HD27
	,MAX(av.[HD47]) as HD47
	,MAX(av.[HD24]) as HD24
	,MAX(av.[HD38]) as HD38
	,MAX(av.[HD12]) as HD12
	,MAX(av.[HD09]) as HD09
	,MAX(av.[HD20]) as HD20
	,MAX(av.[HD43]) as HD43
	,MAX(av.[HD26]) as HD26
	,MAX(av.[HD01]) as HD01
	,MAX(av.[HD57]) as HD57
	,MAX(av.[HD46]) as HD46
	,MAX(av.[HD06]) as HD06
	,MAX(av.[HD66]) as HD66
	,MAX(av.[HD54]) as HD54
	,MAX(av.[ZZZZ]) as ZZZZ
	,MAX(av.[HD07]) as HD07
	,MAX(av.[IT62]) as IT62
	,MAX(av.[HD75]) as HD75
	,MAX(av.[HD15]) as HD15
	,MAX(av.[HD56]) as HD56
	,MAX(av.[HD72]) as HD72
	,MAX(av.[HD39]) as HD39
	,MAX(av.[HD14]) as HD14
	,MAX(av.[HD16]) as HD16
	,MAX(av.[HD28]) as HD28
	,MAX(av.[HD65]) as HD65
	,MAX(av.[HD25]) as HD25
	,MAX(av.[HD03]) as HD03
	,MAX(av.[HD63]) as HD63
	,MAX(av.[HD10]) as HD10
	,MAX(av.[HD34]) as HD34
	,MAX(av.[HD08]) as HD08
	,MAX(av.[HD04]) as HD04
	,MAX(av.[HD31]) as HD31
	,MAX(av.[HD59]) as HD59
	,MAX(av.[HD23]) as HD23
	,MAX(av.[HD49]) as HD49
	,MAX(av.[HD52]) as HD52
	,MAX(av.[HD76]) as HD76
	,MAX(av.[HD64]) as HD64
	,MAX(av.[HD45]) as HD45
	,MAX(av.[CYRT]) as CYRT
	,MAX(av.[HD02]) as HD02
	,MAX(av.[HD22]) as HD22
	,MAX(av.[HD50]) as HD50
	,MAX(av.[HD61]) as HD61
	,MAX(av.[HD62]) as HD62
	,MAX(av.[HD13]) as HD13
	,MAX(av.[HD18]) as HD18
	,MAX(av.[HD58]) as HD58
	,MAX(av.[HD69]) as HD69
	from AVValueID as AV
	Group by av.siteID, av.PlotNo

/*
Select Distinct AT.[AttributeTypeID], AT.Name from CONFIRM.Asset a
JOIN CONFIRM_CONSUMPTION.FactJob fj
on a.SiteID = fj.SiteID
and a.PlotNo = fj.PlotNo
and a.CentralAssetID = fj.CentralAssetID
and a.AssetTypeID = 'DRGU'
and a.IsDeletedFlag= 0
and a.IsCurrentFlag = 1
JOIN CONFIRM.AssetAttributeType AAT
on AAT.SiteID = a.SiteID
and AAT.PlotNo = a.PlotNo
and AAT.IsDeletedFlag = 0
and AAT.IsCurrentFlag = 1
JOIN CONFIRM.[AttributeType] AT
on AT.[AttributeTypeID] = AAT.[AttributeTypeID]
and AT.ISDeletedFlag = 0 
and AT.IsCurrentFlag = 1
*/