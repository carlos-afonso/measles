(* ::Package:: *)

(* ::Title:: *)
(*NYC Measles Cases by Vaccination Status*)


(* ::Subtitle:: *)
(*Creates a bar chart of the NYC Measles Cases by Vaccination Status and saves it as a PNG image*)


(* ::Subsubtitle:: *)
(*Author: Carlos Afonso*)
(*GitHub project: https://github.com/carlos-afonso/measles*)
(*MIT License: https://github.com/carlos-afonso/measles/blob/master/LICENSE*)


(* ::Section:: *)
(*Setup the directories*)


projectDirectory = ParentDirectory[If[SameQ[#, ""], NotebookDirectory[], #]]& @ $InputFileName;
dataDirectory = FileNameJoin[{projectDirectory, "data"}];
imagesDirectory = FileNameJoin[{projectDirectory, "images"}];

Print["Project directory: ", projectDirectory];
Print["Data directory:    ", dataDirectory];
Print["Images directory:  ", imagesDirectory];


(* ::Section:: *)
(*Import the raw data*)


dataFile = FileNameJoin[{dataDirectory, "nyc_health_measles_cases_by_vaccination_status.csv"}];
rawData = Import[dataFile];

Print["Data file: ", dataFile];
Print["Data imported from data file:"];
Print[TableForm[rawData]];


(* ::Section:: *)
(*Get the start day and end day from the raw data*)


dayFormat = {"MonthNameShort", " ", "DayShort", ", ", "Year"};
startDayString = DateString[rawData[[-1, 1]], dayFormat];
endDayString = DateString[rawData[[-1, 2]], dayFormat];

Print["Start day string: ", startDayString];
Print["End day string:   ", endDayString];


(* ::Section:: *)
(*Get the data to plot from the raw data*)


dataToPlot = AssociationThread[rawData[[1, 3;;-2]] -> rawData[[-1, 3;;-2]]];

Print["Data to plot: ", dataToPlot];


(* ::Section:: *)
(*Get and check the total number of measles cases*)


totalCases = rawData[[-1, -1]];

Print["Total cases from data:     ", totalCases];
Print["Total cases sum check:     ", Total[dataToPlot]];
Print["Total cases boolean check: ", SameQ[totalCases, Total[dataToPlot]]];


(* ::Section:: *)
(*Create the bar chart*)


barChart = With[{data = Reverse[dataToPlot]},
	BarChart[
		data,
		BarOrigin -> Left,
		BarSpacing -> Medium,
		ChartLabels -> (StringDelete[#, "With "]& /@ Keys[data]), 
		ChartStyle -> LightGray, 
		Frame -> True,
		FrameLabel -> {"Vaccination Status", "Number of Measles Cases"},
		LabelingFunction -> (Placed[
			Row[{#, " (", Round[100 * # / totalCases], "%)"}], 
			After
		]&),
		PerformanceGoal -> "Quality", 
		PlotLabel -> Column[
			{
				Style["NYC Measles Cases by Vaccination Status", "Text", 15], 
				Style[StringJoin[ToString[totalCases], " total cases from ", startDayString, ", to ", endDayString], "Text", 12], 
				""
			}, 
			Center, 
			Spacings -> {0, {0, 0.5, 0}}
		], 
		PlotRange->{{0, 460}, Automatic}
	]
];

barChart = Labeled[
	barChart,
	Style["Data: NYC Health;  Image: https://carlos-afonso.github.io/measles", 9], 
	Spacings -> {Automatic, 1}
]


(* ::Section:: *)
(*Export the bar chart as a PNG image*)


Export[
	FileNameJoin[{imagesDirectory, "nyc_measles_cases_by_vaccination_status_barchart_wl.png"}], 
	barChart, 
	ImageResolution -> 300
]
