on run argv
	set operationName to item 1 of argv
	set watchedPath to item 2 of argv
	try
		set watchedAlias to (POSIX file watchedPath) as alias
	on error
		if operationName is "status" then return "not-installed"
		error "Screenshot folder is missing: " & watchedPath
	end try
	set scriptName to "SnapKeep - Screenshot to Clipboard.scpt"
	set legacyScriptName to "自动复制截屏到剪切板.scpt"
	tell application "System Events"
		launch
		delay 0.3
		set targetAction to missing value
		repeat with candidateAction in folder actions
			set candidatePath to (path of candidateAction) as text
			try
				if candidatePath starts with "/" then
					set candidateAlias to (POSIX file candidatePath) as alias
				else
					set candidateAlias to candidatePath as alias
				end if
				if candidateAlias is watchedAlias then
					set targetAction to contents of candidateAction
					exit repeat
				end if
			end try
		end repeat
		if operationName is "install" then
			if targetAction is missing value then
				set targetAction to make new folder action at end of folder actions with properties {path:(watchedAlias as text)}
			end if
			tell targetAction
				-- Migrate the earlier script and remove Apple's unwanted sample alert.
				if exists script legacyScriptName then delete script legacyScriptName
				if exists script "add - new item alert.scpt" then delete script "add - new item alert.scpt"
				if not (exists script scriptName) then make new script at end of scripts with properties {name:scriptName}
				set enabled of script scriptName to true
				set enabled to true
			end tell
			set folder actions enabled to false
			delay 0.4
			set folder actions enabled to true
		else if operationName is "uninstall" then
			if targetAction is not missing value then
				tell targetAction
					if exists script scriptName then delete script scriptName
					set hasOtherScripts to (count of scripts) > 0
				end tell
				if not hasOtherScripts then delete targetAction
			end if
		else if operationName is "status" then
			if targetAction is missing value then return "not-installed"
			tell targetAction
				if not (exists script scriptName) then return "not-installed"
				if enabled is false then return "disabled"
				if enabled of script scriptName is false then return "disabled"
			end tell
			if folder actions enabled is false then return "disabled"
			return "installed"
		end if
	end tell
end run
