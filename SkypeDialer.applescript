(*
 SkypeDialer.applescript

 This AppleScript is meant to be saved as a stay-open faceless application
 (/Applications seems like a good place) and then its services can be used by
 other AppleScripts and workflows.  
 *)

property script_name : "SkypeDialer"
property delay_after_launching_skype : 5 (* seconds to wait for Skype to launch and log user in *)
property connect_wait : 15 (* seconds to wait before sending additional tones *)
property dtmf_wait : 0.5 (* seconds to wait between sending DTMF tones *)
property growl_enabled : true

on do_the_call(conference_phone_number, conference_code)
	set script_name to name of me
	
	if growl_enabled then
		register_growl_notifications()
	end if
	
	launch_skype()
	
	set skype_call_id to call(conference_phone_number)
	
	wait_for_call_to_connect()
	
	dial_tones(skype_call_id, conference_code)
	
	msg(script_name & " is done.")
end do_the_call

on register_growl_notifications()
	tell application "GrowlHelperApp"
		set the allNotificationsList to {script_name}
		set the enabledNotificationsList to {script_name}
		
		register as application script_name Â
			all notifications allNotificationsList Â
			default notifications enabledNotificationsList Â
			icon of application "Skype"
	end tell
end register_growl_notifications

on dismiss_skype_api_security()
	tell application "System Events"
		tell application process "Skype"
			if exists (radio button "Allow this application to use Skype" of radio group 1 of window "Skype API Security") then
				click
				delay 0.5
				click button "OK" of window "Skype API Security"
			end if
		end tell
	end tell
	
	tell application "Finder"
		set visible of process "Skype" to false
	end tell
end dismiss_skype_api_security

on launch_skype()
	msg("Launching Skype...")
	
	tell application "Skype"
		delay 1
		
		set status to "COMMAND_PENDING"
		
		repeat until status is not equal to "COMMAND_PENDING"
			set status to send command "GET USERSTATUS" script name script_name
			
			if status is equal to "COMMAND_PENDING" then
				my dismiss_skype_api_security()
			end if
			
			delay 0.5
		end repeat
	end tell
end launch_skype

on msg(msg)
	log (msg)
	
	if growl_enabled then
		tell application "GrowlHelperApp"
			notify with name script_name Â
				title script_name Â
				description msg Â
				application name script_name
		end tell
	end if
end msg

on call(phone_number)
	msg("Dialing " & phone_number)
	
	tell application "Skype"
		set active_call to send command "CALL " & phone_number script name script_name
	end tell
	
	set skype_call_id to word 2 of active_call
	
	return skype_call_id
end call

on wait_for_call_to_connect()
	-- msg("Waiting for " & connect_wait & " seconds")
	delay connect_wait
end wait_for_call_to_connect

on dial_tone(skype_call_id, tone)
	tell application "Skype"
		send command "ALTER CALL " & skype_call_id & " DTMF " & tone script name script_name
	end tell
end dial_tone

on dial_tones(skype_call_id, tones)
	msg("Dialing  " & tones & " ...")
	
	repeat with tone in the characters of tones
		dial_tone(skype_call_id, tone)
		delay dtmf_wait
	end repeat
end dial_tones
