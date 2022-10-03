let
    Source = Table.FromColumns({Lines.FromBinary(File.Contents("C:\Users\oluwa\Desktop\WhatsApp Chat - RESA Data Community\_chat.txt"), null, null, 65001)}),
    #"Split Column by Delimiter" = Table.SplitColumn(Source, "Column1", Splitter.SplitTextByEachDelimiter({": "}, QuoteStyle.Csv, false), {"Column1.1", "Column1.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Column1.1", type text}, {"Column1.2", type text}}),
    #"-removeUserJoinEvent" = Table.SelectRows(#"Changed Type", each not Text.Contains([Column1.1], "joined using this group's invite link")),
    #"Added Custom" = Table.AddColumn(#"-removeUserJoinEvent", "Custom", each if [Column1.2] = null then [Column1.1] else [Column1.2]),
    #"Removed Top Rows" = Table.Skip(#"Added Custom",3),
    #"--removeUserLeaveEvent" = Table.SelectRows(#"Removed Top Rows", each not Text.EndsWith([Column1.1], "left")),
    #"--extractUserTagProxy" = Table.AddColumn(#"--removeUserLeaveEvent", "userTag", each if Text.Contains([Column1.1],"[") and Text.Contains([Column1.1], "]") and Text.StartsWith([Column1.1],"[")
then [Column1.1] else null),
    #"Filled Down" = Table.FillDown(#"--extractUserTagProxy",{"userTag"}),
    #"Renamed Columns" = Table.RenameColumns(#"Filled Down",{{"Custom", "message"}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Renamed Columns",{"userTag", "message"}),
    #"Inserted Text After Delimiter" = Table.AddColumn(#"Removed Other Columns", "Text After Delimiter", each Text.AfterDelimiter([userTag], "] "), type text),
    #"Renamed Columns1" = Table.RenameColumns(#"Inserted Text After Delimiter",{{"Text After Delimiter", "userName"}}),
    #"Inserted Text Between Delimiters" = Table.AddColumn(#"Renamed Columns1", "Text Between Delimiters", each Text.BetweenDelimiters([userTag], "[", "]"), type text),
    #"Changed Type1" = Table.TransformColumnTypes(#"Inserted Text Between Delimiters",{{"Text Between Delimiters", type datetime}}),
    #"--filterOut[id]," = Table.SelectRows(#"Changed Type1", each [userTag] <> "[id],"),
    #"--listOfFilters" = Table.SelectRows(#"--filterOut[id],", each not Text.Contains([userName], "changed their phone") and not Text.Contains([userName], "changed this group's icon") and not Text.Contains([userName], "You added") and not Text.Contains([userName], "You changed the group") and not Text.Contains([userName], ">= 4), [date])")),
    #"Inserted Year" = Table.AddColumn(#"--listOfFilters", "Year", each Date.Year([Text Between Delimiters]), Int64.Type),
    #"Renamed Columns2" = Table.RenameColumns(#"Inserted Year",{{"Text Between Delimiters", "timeStamp"}}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns2",{{"message", type text}, {"userTag", type text}}),
    #"--removeEmptyMessage" = Table.SelectRows(#"Changed Type2", each ([message] <> ""))
in
    #"--removeEmptyMessage"