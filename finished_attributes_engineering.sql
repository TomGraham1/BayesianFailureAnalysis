IF OBJECT_ID(N'tempdb..#Temp_AAM') IS NOT NULL
BEGIN
	DROP TABLE #Temp_AAM
END
 
 SELECT distinct 
			   AAT.SiteID,
               AAT.PlotNo,
               AAT.AttributeTypeID,
			   AAT.AttributeValueID AS AttributeValueID,
			   AV.[Name] AS AttributeValueName,
			   AT.Name as AttributeTypeName,
			   AT.Description as AttributeDescription
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
			INNER JOIN CONFIRM.AttributeType as AT
				on AT.AttributeTypeID = AAT.AttributeTypeID
				and AT.IsDeletedFlag = 0 
				and AT.IsCurrentFlag = 1
            LEFT JOIN CONFIRM.AssetMeasurementType AS AMT
                ON AMT.SiteID = AAT.SiteID
                   AND AMT.PlotNo = AAT.PlotNo
				   AND AMT.IsCurrentFlag = 1 AND AMT.[IsDeletedFlag] = 0 
		WHERE AAT.AttributeTypeID IN ('HD52','HD41','HD39','HD57','HD51','HD76','HD14','HD06','HD13','HD16','HD17','HD07','HD19','XSP','HD05','HD04')
			AND AAT.[IsDeletedFlag] = 0 and AAT.[IsCurrentFlag] = 1

;with AttributeValueID AS (
SELECT *
FROM
(
select * FROM #Temp_AAM) AS SourceTable
PIVOT
    (
        MAX(AttributeValueID)
        FOR AttributeTypeID IN (
			[HD52],[HD41],[HD39],[HD57],[HD51],[HD76],[HD14],[HD06],[HD13],[HD16],[HD17],[HD07],[HD19],[XSP],[HD05],[HD04])
    ) AS PivotTable
)


,AttributeValueName AS (
SELECT 
*
FROM
(
select * FROM #Temp_AAM) AS SourceTable
PIVOT
    (
        MAX(AttributeValueName)
        FOR AttributeTypeID IN (
			[HD52],[HD41],[HD39],[HD57],[HD51],[HD76],[HD14],[HD06],[HD13],[HD16],[HD17],[HD07],[HD19],[XSP],[HD05],[HD04])
    ) AS PivotTable
) 

SELECT 
av.SiteID, 
av.PlotNo,
MAX(av.[HD52]) AS AttrHD52,
MAX(an.[HD52]) AS AttrNameHD52,
MAX(av.[HD41]) AS AttrHD41,
MAX(an.[HD41]) AS AttrNameHD41,
MAX(av.[HD39]) AS AttrHD39,
MAX(an.[HD39]) AS AttrNameHD39,
MAX(av.[HD57]) AS AttrHD57,
MAX(an.[HD57]) AS AttrNameHD57,
MAX(av.[HD51]) AS AttrHD51,
MAX(an.[HD51]) AS AttrNameHD51,
MAX(av.[HD76]) AS AttrHD76,
MAX(an.[HD76]) AS AttrNameHD76,
MAX(av.[HD14]) AS AttrHD14,
MAX(an.[HD14]) AS AttrNameHD14,
MAX(av.[HD06]) AS AttrHD06,
MAX(an.[HD06]) AS AttrNameHD06,
MAX(av.[HD13]) AS AttrHD13,
MAX(an.[HD13]) AS AttrNameHD13,
MAX(av.[HD16]) AS AttrHD16,
MAX(an.[HD16]) AS AttrNameHD16,
MAX(av.[HD17]) AS AttrHD17,
MAX(an.[HD17]) AS AttrNameHD17,
MAX(av.[HD07]) AS AttrHD07,
MAX(an.[HD07]) AS AttrNameHD07,
MAX(av.[HD19]) AS AttrHD19,
MAX(an.[HD19]) AS AttrNameHD19,
MAX(av.[XSP]) AS AttrXSP,
MAX(an.[XSP]) AS AttrNameXSP,
MAX(av.[HD05]) AS AttrHD05,
MAX(an.[HD05]) AS AttrNameHD05,
MAX(av.[HD04]) AS AttrHD04,
MAX(an.[HD04]) AS AttrNameHD04
FROM AttributeValueID av
inner join AttributeValueName an
on an.PlotNo = av.PlotNo and an.SiteID = av.SiteID
GROUP BY av.SiteID, av.PlotNo
