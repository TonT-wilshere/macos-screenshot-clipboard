use framework "AppKit"
use scripting additions

on run argv
	local watchedPath, sourceImagePath, destinationPath, pasteboard, savedItems, oldItem, savedItem, dataType, dataValue, imageFound, pastedImage
	set watchedPath to item 1 of argv
	set sourceImagePath to item 2 of argv
	set destinationPath to watchedPath & "/snapkeep-verification.png"
	set pasteboard to current application's NSPasteboard's generalPasteboard()
	set savedItems to {}
	repeat with oldItem in (pasteboard's pasteboardItems())
		set savedItem to current application's NSPasteboardItem's alloc()'s init()
		repeat with dataType in (oldItem's types())
			set dataValue to oldItem's dataForType:dataType
			if dataValue is not missing value then savedItem's setData:dataValue forType:dataType
		end repeat
		set end of savedItems to savedItem
	end repeat
	try
		pasteboard's clearContents()
		pasteboard's writeObjects:{"SnapKeep functional test"}
		«event sysoexec» ("/bin/cp " & quoted form of sourceImagePath & " " & quoted form of destinationPath)
		set imageFound to false
		repeat 60 times
			delay 0.25
			set pastedImage to current application's NSImage's alloc()'s initWithPasteboard:pasteboard
			if pastedImage is not missing value then
				set imageFound to true
				exit repeat
			end if
		end repeat
		if not imageFound then error "New PNG was not copied by the folder action"
		my restoreClipboard(pasteboard, savedItems)
		return "PASS: new file automatically became clipboard image data; previous clipboard restored."
	on error messageText number errorNumber
		my restoreClipboard(pasteboard, savedItems)
		error messageText number errorNumber
	end try
end run

on restoreClipboard(pasteboard, savedItems)
	pasteboard's clearContents()
	if (count of savedItems) > 0 then pasteboard's writeObjects:savedItems
end restoreClipboard
