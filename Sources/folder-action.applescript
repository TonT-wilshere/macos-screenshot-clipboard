use framework "AppKit"
use scripting additions

property allowedExtensions : {"png", "jpg", "jpeg", "heic", "heif", "tif", "tiff"}

-- Folder Actions invokes this event after new files enter the screenshot folder.
on «event facofget» watchedFolder given «class flst»:addedItems
	set copiedCount to 0
	try
		repeat with addedItem in addedItems
			set imagePath to POSIX path of addedItem
			set extensionName to ((current application's NSString's stringWithString:imagePath)'s pathExtension()'s lowercaseString()) as text
			if allowedExtensions contains extensionName then
				if my copyWhenReady(imagePath) then set copiedCount to copiedCount + 1
			end if
		end repeat
		if copiedCount > 0 then
			my notify(my localized("已复制到剪贴板", "Copied to clipboard"))
		end if
	on error
		my notify(my localized("复制失败，请重试", "Could not copy. Please try again."))
	end try
end «event facofget»

on copyWhenReady(imagePath)
	repeat 12 times
		delay 0.25
		set imageURL to current application's NSURL's fileURLWithPath:imagePath
		-- Fully decode before clearing the user's clipboard. A partial image is retried.
		set imageData to current application's NSData's dataWithContentsOfURL:imageURL
		if imageData is not missing value then
			set decodedImage to current application's NSBitmapImageRep's imageRepWithData:imageData
			if decodedImage is not missing value then
				set imageObject to current application's NSImage's alloc()'s initWithContentsOfURL:imageURL
				if imageObject is not missing value then
					set pasteboard to current application's NSPasteboard's generalPasteboard()
					pasteboard's clearContents()
					set didWrite to pasteboard's writeObjects:{imageObject}
					return didWrite as boolean
				end if
			end if
		end if
	end repeat
	return false
end copyWhenReady

on localized(chineseText, englishText)
	set snapDefaults to current application's NSUserDefaults's alloc()'s initWithSuiteName:"io.github.tont-wilshere.snapkeep"
	set selectedLanguage to snapDefaults's stringForKey:"language"
	if selectedLanguage is missing value then
		set selectedLanguage to (current application's NSLocale's preferredLanguages()'s firstObject())
	end if
	if (selectedLanguage as text) starts with "zh" then return chineseText
	return englishText
end localized

on notify(messageText)
	-- A banner, never a modal dialog or an image-viewer prompt.
	«event sysonotf» messageText given «class appr»:"SnapKeep"
end notify
