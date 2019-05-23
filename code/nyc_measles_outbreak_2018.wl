(* ::Package:: *)

(* ::Title:: *)
(*NYC Measles Outbreak (2018-2019)*)


(* ::Subtitle:: *)
(*Creates and saves visualizations of the NYC Measles cases by Neighborhood, Age and Date.*)


(* ::Subsubtitle:: *)
(*Author: Carlos Afonso*)
(*GitHub project: https://github.com/carlos-afonso/measles*)
(*License: MIT License [https://github.com/carlos-afonso/measles/blob/master/LICENSE]*)


(* ::Section::Closed:: *)
(*Notes*)


(* ::Text:: *)
(*1. Notes about the Data:*)
(*- 1.1. The source of the data is the NYC Health Measles webpage [https://www1.nyc.gov/site/doh/health/health-topics/measles.page].*)
(*- 1.2. NYC Health displays the data in tables in that webpage, and updates the data regularly (usually at least once a week).*)
(*- 1.3. The data is small. So, at the moment, the data is defined inside this file itself, for convenience. *)
(*This means that when NYC Health updates the data in their webpage, the data in this file needs to be updated accordingly.*)
(**)
(*2. Notes about the Visualizations:*)
(*- 2.1. This file creates and saves visualizations of the NYC Measles cases by Neighborhood, Age and Date.*)
(*- 2.2. The visualizations are saved to the directory defined by $saveDirectory.*)
(*- 2.3. The code that creates the visualization of the NYC Measles cases by Age is fully automated.*)
(*- 2.4. When there is a data update, the code that creates the visualization of the NYC Measles cases by Date may require *)
(*some minor manual updates too.*)
(*- 2.5. When there is a data update, the code that creates the visualizations of the NYC Measles cases by Neighborhood requires *)
(*significant manual updates too.*)
(**)
(*3. Notes about this File:*)
(*- 3.1. This file has extension ".wl" which, technically, is the Wolfram Language package source format. However, *)
(*this is not a Wolfram Package, this is just a Wolfram source file which is actually designed to be used as a notebook.*)
(*- 3.2. Normally one would use the Wolfram Notebook format (.nb). *)
(*However the ".nb" format is not a plain ASCII text format, and is not very portable (in practice, *)
(*it can only be open on a Wolfram system, like Mathematica, it can't be opened in a normal text editor).*)
(*- 3.3. The ".wl" is a plain ASCII text format, and is very portable (it can be opened with any text editor, *)
(*such as  Atom which even has Wolfram Language syntax highlighting). So you can use any text editor to look at the code in this file.*)
(*- 3.4. However, this file can only be executed on a Wolfram system, like Mathematica, Wolfram Desktop, Wolfram Cloud, or Wolfram Script. *)
(*If you don't have a Wolfram system, you can use the Wolfram Open Cloud [https://www.open.wolframcloud.com/] for free (although with limited functionality), *)
(*and/or a free trial of a Wolfram system: [http://wolfram.com/wolfram-one/] or [https://www.wolfram.com/mathematica/trial/].*)
(*- 3.5. If you execute this file on a Wolfram system, Output cells will be create with the results. But then, *)
(*when you close this file all those Output cells will be automatically deleted. So, every time this file is open it will not have any Output cells.*)


(* ::Section:: *)
(*Define the Data*)


(* ::Text:: *)
(*Data source: https://www1.nyc.gov/site/doh/health/health-topics/measles.page*)


(* ::Subsection::Closed:: *)
(*Dates*)


(* ::Subsubsection:: *)
(*Define*)


(* IMPORTANT: When udpdating the data, make sure to update these dates accordingly *)
$dataUpdateDay    = DateObject[{2019, 5, 20}, "Day"];
$newCasesStartDay = DateObject[{2019, 5, 13}, "Day"];
$allCasesStartDay = DateObject[{2018, 9,  1}, "Day"];

(* These DateString(s) are auxiliary variables, to be displayed in the visualizations *)
{$dataUpdateDayString, $newCasesStartDayString, $allCasesStartDayString} = Map[
	DateString[#, {"DayShort", " ", "MonthNameShort", " ", "Year"}]&,
	{$dataUpdateDay, $newCasesStartDay, $allCasesStartDay}
];

(* These DateString(s) are auxiliary variables, to be used in the file names of the saved visualizations *)
{$dataUpdateDayStringISO, $newCasesStartDayStringISO, $allCasesStartDayStringISO} = Map[
	DateString[#, "ISODate"]&,
	{$dataUpdateDay, $newCasesStartDay, $allCasesStartDay}
];


(* ::Subsubsection:: *)
(*Check*)


{
	{"Data Update Day",     $dataUpdateDay,    $dataUpdateDayString,    $dataUpdateDayStringISO},
	{"New Cases Start Day", $newCasesStartDay, $newCasesStartDayString, $newCasesStartDayStringISO},
	{"All Cases Start Day", $allCasesStartDay, $allCasesStartDayString, $allCasesStartDayStringISO}
} // TableForm


(* ::Subsection::Closed:: *)
(*Cases by Neighborhood*)


(* ::Subsubsection::Closed:: *)
(*Define*)


$allCasesTotal = 523;
$newCasesTotal =  25;

$allCasesTotalString = ToString[$allCasesTotal];
$newCasesTotalString = ToString[$newCasesTotal];

$casesByNeighborhood = With[
	{
		type = "Neighborhood",
		suffix = "::NewYork::NewYork::UnitedStates"
	},
	Association[
		Entity[type, "Bensonhurst"        <> suffix] -> <|"All" ->   2, "New" ->  1|>,
		Entity[type, "BoroughPark"        <> suffix] -> <|"All" ->  80, "New" ->  6|>,
		(* NOTE: "Brighton Beach" and "Coney Island" cases are merged (i.e., a union) *)
		Entity[type, "BrightonBeach"      <> suffix] -> <|"All" ->   4, "New" ->  0|>,
		Entity[type, "ConeyIsland"        <> suffix] -> <|"All" ->   4, "New" ->  0|>,
		Entity[type, "CrownHeights"       <> suffix] -> <|"All" ->   2, "New" ->  0|>,
		(* NOTE: "Midwood" and "Marine Park" cases are merged (i.e., a union) *)
		Entity[type, "Midwood"            <> suffix] -> <|"All" ->   4, "New" ->  0|>,
		Entity[type, "MarinePark"         <> suffix] -> <|"All" ->   4, "New" ->  0|>,
		Entity[type, "SunsetPark"         <> suffix] -> <|"All" ->   8, "New" ->  1|>,
		Entity[type, "Williamsburg"       <> suffix] -> <|"All" -> 415, "New" -> 16|>,
		Entity[type, "Flushing"           <> suffix] -> <|"All" ->   3, "New" ->  0|>,
		Entity[type, "FarRockaway"        <> suffix] -> <|"All" ->   1, "New" ->  0|>,
		(* NOTE: "Hunts Point", "Longwood" and "Melrose" cases are merged (i.e., a union) *)
		Entity[type, "HuntsPointLongwood" <> suffix] -> <|"All" ->   1, "New" ->  0|>,
		Entity[type, "Melrose"            <> suffix] -> <|"All" ->   1, "New" ->  0|>, 
		Entity[type, "FlatbushDitmasPark" <> suffix] -> <|"All" ->   1, "New" ->  0|>, 
		Entity[type, "Jamaica"            <> suffix] -> <|"All" ->   2, "New" ->  1|>
	]
];


(* ::Subsubsection::Closed:: *)
(*Check*)


$casesByNeighborhood // Dataset


{$allCasesTotal, $newCasesTotal}


{$allCasesTotalString, $newCasesTotalString}


{allCasesSum, newCasesSum} = With[
	{
		type = "Neighborhood",
		suffix = "::NewYork::NewYork::UnitedStates"
	},
	Map[
		With[
			{
				casesConeyIsland = $casesByNeighborhood[Entity[type, "ConeyIsland" <> suffix], #],
				casesMidwood     = $casesByNeighborhood[Entity[type, "Midwood" <> suffix], #],
				casesMelrose     = $casesByNeighborhood[Entity[type, "Melrose" <> suffix], #]
			},
			Total[$casesByNeighborhood[[All, #]]] - (casesConeyIsland + casesMidwood + casesMelrose)
		]&,
		{"All", "New"}
	]
]


SameQ[$allCasesTotal, allCasesSum]


SameQ[$newCasesTotal, newCasesSum]


FullForm /@ Keys[$casesByNeighborhood] // Column


EntityProperties /@ Keys[$casesByNeighborhood] // Tally


Map[
	EntityValue[#, EntityProperty["Neighborhood", "HasPolygon"]]&,
	Keys[$casesByNeighborhood]
] // Tally


(*
Map[
	{#, EntityValue[#, EntityProperty["Neighborhood", "HasPolygon"]]}&,
	Keys[$casesByNeighborhood]
] // TableForm
*)


(* ::Subsection::Closed:: *)
(*Cases by Age*)


(* ::Subsubsection:: *)
(*Define*)


$casesByAge = Association[
	"Under 1 year"      ->  79, 
	"1 to 4 years"      -> 220, 
	"5 to 17 years"     -> 109, 
	"18 years and over" ->  90
];


(* ::Subsubsection:: *)
(*Check*)


$casesByAge // Dataset


{#, SameQ @@ #}& @ {$allCasesTotal, Total[Values @ $casesByAge]}


(* ::Subsection::Closed:: *)
(*Cases by Date (Month)*)


(* ::Subsubsection:: *)
(*Define*)


$casesByMonth = Association[
	DateObject[{2018,  9}, "Month"] ->   1,
	DateObject[{2018, 10}, "Month"] ->  13,
	DateObject[{2018, 11}, "Month"] ->  28,
	DateObject[{2018, 12}, "Month"] ->  14,
	DateObject[{2019,  1}, "Month"] ->  34,
	DateObject[{2019,  2}, "Month"] ->  69,
	DateObject[{2019,  3}, "Month"] -> 147,
	DateObject[{2019,  4}, "Month"] -> 164, 
	DateObject[{2019,  5}, "Month"] ->  28
];


(* ::Subsubsection:: *)
(*Check*)


$casesByMonth // Reverse // Dataset


{#, SameQ @@ #}& @ {$allCasesTotal, Total[Values @ $casesByMonth]}


(* ::Section:: *)
(*Create and Export the Visualizations*)


(* ::Subsection::Closed:: *)
(*Auxiliary variables*)


$sourcesString = "Data: NYC Health, Image: carlos-afonso.github.io/measles";


(*$saveDirectory = If[SameQ[#, ""], NotebookDirectory[], #]& @ $InputFileName*)
$saveDirectory = FileNameJoin[{ParentDirectory[NotebookDirectory[]], "images"}]


(* ::Subsection:: *)
(*Cases by Neighborhood*)


(* ::Subsubsection::Closed:: *)
(*Auxiliary definitions*)


$opacity = Opacity[0.5];

(* TODO: Safeguard the casesCountToColor function *)

$lowCasesColor     = RGBColor[0, 0.3, 0.3] (* Dark Cyan *);
$midLowCasesColor  = Blue;
$midHighCasesColor = Purple;
$highCasesColor    = Red;

casesCountToColor[n_Integer] := Which[
	n < 3,    Directive[$lowCasesColor,     $opacity],
	n < 10,   Directive[$midLowCasesColor,  $opacity],
	n < 100,  Directive[$midHighCasesColor, $opacity],
	n >= 100, Directive[$highCasesColor,    $opacity]
];


(* ::Subsubsection::Closed:: *)
(*All Cases by Neighborhood*)


(* ::Subsubsubsection:: *)
(*Create*)


allCasesByNeighborhoodGeoPlot = With[
	{
		allCasesColorByNeighborhood = casesCountToColor /@ $casesByNeighborhood[[All, "All"]],
		fontSize = 13
	},
	GeoRegionValuePlot[
		allCasesColorByNeighborhood,
		GeoBackground -> GeoStyling["StreetMap"],
		GeoRange -> {{40.545, 40.853}, {-74.04, -73.73}},
		GeoZoomLevel -> 11,
		ImageSize -> Large,
		PlotLabel -> Column[
			{
				Style["All NYC measles cases by neighborhood", "Text", 24, Black],
				Style["523 total cases from Sep 1, 2018, to May 20, 2019", "Text", 18, Black, Bold],
				SwatchLegend[
					Directive[#, $opacity]& /@ {$lowCasesColor, $midLowCasesColor, $midHighCasesColor, $highCasesColor}, 
					Style[First[#], Last[#], Bold, fontSize]& /@ {
						{"1 or 2 ",           $lowCasesColor}, 
						{"3 to 9 ",           $midLowCasesColor}, 
						{"10 to 99 ",         $midHighCasesColor}, 
						{"100 or more cases", $highCasesColor}
					}, 
					LegendMarkerSize -> fontSize,
					LegendLayout -> "Row"
				]
			},
			Center
		],
		Epilog -> {
			Inset[Style["Bensonhurst\n 2 cases ",                     $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.09, 0.152}]],
			Inset[Style["Borough\nPark\n 80 cases ",                  Purple, Bold, fontSize, Background -> LightPurple], Scaled[{0.18, 0.39}]],
			Inset[Style["Coney Island / Brighton Beach\n 4 cases ",   Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.22, 0.045}]],
			Inset[Style["Crown Heights\n 2 cases ",                   $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.34, 0.445}]],
			Inset[Style["Midwood / Marine Park\n 4 cases ",           Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.46, 0.25}]],
			Inset[Style["Sunset\nPark\n 8 cases ",                    Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.06, 0.42}]],
			Inset[Style["Williamsburg\n 415 cases ",                  Red,    Bold, fontSize, Background -> LightRed],    Scaled[{0.35, 0.59}]],
			Inset[Style["Flushing\n 3 cases ",                        Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.67, 0.80}]],
			Inset[Style["Far Rockaway\n 1 case ",                     $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.89, 0.11}]],
			Inset[Style["Melrose / Longwood / Hunts Point\n 1 case ", $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.46, 0.94}]], 
			Inset[Style["Flatbush\n 1 case ",                         $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.36, 0.33}]], 
			Inset[Style["Jamaica\n 2 cases ",                          $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.77, 0.575}]]
		}
	]
];

allCasesByNeighborhoodGeoPlot = Framed @ Labeled[
	allCasesByNeighborhoodGeoPlot,
	Style[$sourcesString, "Text", 12, FontFamily -> "Lucida Console"]
]


$casesByNeighborhood[[All, "All"]]


(* ::Subsubsubsection:: *)
(*Export*)


Export[
	FileNameJoin[{$saveDirectory, "nyc_measles_cases_by_neighborhood_geoplot_all.svg"}],
	allCasesByNeighborhoodGeoPlot
]


(* ::Subsubsection::Closed:: *)
(*New Cases by Neighborhood*)


(* ::Subsubsubsection:: *)
(*Create*)


newCasesByNeighborhoodGeoPlot = With[
	{
		newCasesColorByNeighborhood = casesCountToColor /@ Select[$casesByNeighborhood[[All, "New"]], (# > 0)&],
		fontSize = 13
	},
	GeoRegionValuePlot[
		newCasesColorByNeighborhood,
		GeoBackground -> GeoStyling["StreetMap"],
		GeoRange -> {{40.545, 40.853}, {-74.04, -73.73}},
		(*GeoRange -> {{40.57, 40.853}, {-74.03, -73.73}}, *)
		GeoZoomLevel -> 11,
		ImageSize -> Large,
		PlotLabel -> Column[
			{
				Style["Newest NYC measles cases by neighborhood", "Text", 24, Black], 
				(*Row[{Style["NYC", "Text", 24, Black], Style[" newest ", "Text", 24, Black, Bold], Style["measles cases by neighborhood", "Text", 24, Black]}],*)
				Style["25 total cases from May 13 to May 20, 2019", "Text", 18, Black, Bold],
				SwatchLegend[
					Directive[#, $opacity]& /@ {$lowCasesColor, $midLowCasesColor, $midHighCasesColor, $highCasesColor}, 
					Style[First[#], Last[#], Bold, fontSize]& /@ {
						{"1 or 2 ",           $lowCasesColor}, 
						{"3 to 9 ",           $midLowCasesColor}, 
						{"10 to 99 ",         $midHighCasesColor}, 
						{"100 or more cases", $highCasesColor}
					}, 
					LegendMarkerSize -> fontSize,
					LegendLayout -> "Row"
				]
			},
			Center
		],
		Epilog -> {
			Inset[Style["Bensonhurst\n 1 case ",                      $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.09, 0.152}]],
			Inset[Style["Borough\nPark\n 6 cases ",                   Blue, Bold, fontSize, Background -> LightBlue], Scaled[{0.18, 0.39}]],
			(*Inset[Style["Coney Island / Brighton Beach\n 4 cases ",   Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.22, 0.045}]],*)
			(*Inset[Style["Crown Heights\n 2 cases ",                   $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.34, 0.445}]],*)
			(*Inset[Style["Midwood / Marine Park\n 4 cases ",           Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.46, 0.25}]],*)
			Inset[Style["Sunset\nPark\n 1 case ",                     $lowCasesColor,   Bold, fontSize, Background -> LightCyan],   Scaled[{0.06, 0.42}]],
			Inset[Style["Williamsburg\n 16 cases ",                   Purple,    Bold, fontSize, Background -> LightPurple],    Scaled[{0.35, 0.59}]],
			(*Inset[Style["Flushing\n 3 cases ",                        Blue,   Bold, fontSize, Background -> LightBlue],   Scaled[{0.67, 0.80}]],*)
			(*Inset[Style["Far Rockaway\n 1 case ",                     $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.89, 0.11}]],*)
			(*Inset[Style["Melrose / Longwood / Hunts Point\n 1 case ", $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.46, 0.94}]],*) 
			(*Inset[Style["Flatbush\n 1 case ",                         $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.36, 0.33}]],*) 
			Inset[Style["Jamaica\n 1 case ",                          $lowCasesColor, Bold, fontSize, Background -> LightCyan],   Scaled[{0.77, 0.575}]]
		}
	]
];

newCasesByNeighborhoodGeoPlot = Framed @ Labeled[
	newCasesByNeighborhoodGeoPlot,
	Style[$sourcesString, "Text", 12, FontFamily -> "Lucida Console"]
]


$casesByNeighborhood[[All, "New"]]


(* ::Subsubsubsection:: *)
(*Export*)


Export[
	FileNameJoin[{$saveDirectory, "nyc_measles_cases_by_neighborhood_geoplot_new.svg"}],
	newCasesByNeighborhoodGeoPlot
]


(* ::Subsubsection::Closed:: *)
(*All & New Cases by Neighborhood (GIF)*)


Export[
	FileNameJoin[{$saveDirectory, "nyc_measles_cases_by_neighborhood_geoplot_all-new.gif"}],
	{allCasesByNeighborhoodGeoPlot, newCasesByNeighborhoodGeoPlot},
	"AnimationRepetitions" -> Infinity,
	"DisplayDurations" -> 7,
	ImageResolution -> 150
]


(* ::Subsection::Closed:: *)
(*Cases by Age*)


(* ::Subsubsection:: *)
(*Create*)


casesByAgeBarPlot = With[{data = Reverse[$casesByAge]},
	BarChart[
		data,
		BarOrigin -> Left,
		ChartLabels -> (Style[#, "Text", 12]& /@ Keys[data]),
		ChartStyle -> LightBlue,
		Frame -> True,
		FrameLabel -> {
			Style["Age group", "Text", 14],
			Style["Number of measles cases", "Text", 14]
		},
		LabelingFunction -> Function[Placed[Style[#, Darker[Gray]], After]],
		PerformanceGoal -> "Quality",
		PlotLabel -> Column[
			{
				Style["NYC measles cases by age", "Text", 18],
				Style[StringJoin[$allCasesTotalString, " total cases, from ", $allCasesStartDayString, " to ", $dataUpdateDayString], "Text", 12],
				""
			},
			Center,
			Spacings -> {0, {0, 0.4, -0.4}}
		],
		PlotRange -> {{0, 240}, Automatic}
	]
];

casesByAgeBarPlot = Labeled[
	casesByAgeBarPlot,
	Style[$sourcesString, "Text", 10]
]


$casesByAge


(* ::Subsubsection:: *)
(*Export*)


Export[
	FileNameJoin[{$saveDirectory, "nyc_measles_cases_by_age_barplot.png"}],
	casesByAgeBarPlot,
	ImageResolution -> 300
]


(* ::Subsection::Closed:: *)
(*Cases by Date (Month)*)


(* ::Subsubsection:: *)
(*Create*)


monthLabels[months:{DateObject[_, "Month", ___]..}] := Module[{first, last, middle},
	{first, last} = Map[
		StringReplace[DateString[#], " " -> "\n"]&,
		{First[months], Last[months]}
	];
	middle = Map[
		Switch[First[StringSplit[DateString[#]]],
			"Jan" | "Dec", StringReplace[DateString[#], " " -> "\n"],
			_, First[StringSplit[DateString[#]]]
		]&,
		months[[2 ;; -2]]
	];
	Flatten[{first, middle, last}]
];


{#, monthLabels[#]}& @ Keys[$casesByMonth] // Transpose // TableForm


casesByMonthBarPlot = BarChart[
	$casesByMonth,
	ChartLabels -> monthLabels[Keys[$casesByMonth]],
	ChartStyle -> Flatten[{ConstantArray[LightGray, Length[$casesByMonth] - 1], LightOrange}],
	Frame -> True,
	(*FrameLabel \[Rule] {Style["Month", "Text", 14], Style["Number of new measles cases", "Text", 14]}, *)
	FrameLabel -> {
		Style["Month", "Text", 14],
		Row[{Style["Number of", "Text", 14], Style[" new ", "Text", 14, Bold], Style["measles cases", "Text", 14]}]
	},
	ImageSize -> Medium,
	LabelingFunction -> Function[Placed[Style[#, Darker @ Gray], Above]],
	PerformanceGoal -> "Quality",
	PlotLabel -> Column[
		{
			(*Style["NYC new measles cases by month", "Text", 18], *)
			Row[{Style["NYC", "Text", 18], Style[" new ", "Text", 18, Bold], Style["measles cases by month", "Text", 18]}],
			Style[StringJoin[$allCasesTotalString, " total cases, from ", $allCasesStartDayString, " to ", $dataUpdateDayString], "Text", 14],
			SwatchLegend[
				{LightGray, LightOrange},
				{Style["Whole month", "Text", 12], Style["Partial month (May 2019 is incomplete)", "Text", 12]},
				LegendMarkerSize -> 12,
				LegendLayout -> "Row"
			]
		},
		Center
	],
	PlotRange -> {Automatic, {0, 190}}
];

casesByMonthBarPlot = Labeled[
	casesByMonthBarPlot,
	Style[$sourcesString, "Text", 10]
]


(* ::Subsubsection:: *)
(*Export*)


Export[
	FileNameJoin[{$saveDirectory, "nyc_new_measles_cases_by_month_barplot.png"}],
	casesByMonthBarPlot,
	ImageResolution -> 300
]
