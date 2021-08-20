#Spambot for Messages 1.4 by George Argyros

global list_answer

display dialog "Welcome to Spambot for Message! This app works for iMessage and SMS." buttons {"Continue"} with title "Welcome to Spambot for Message 1.4"
select_contact()
display dialog "What would you like to say?" default answer "" with title "Message Text"
set target_message to text returned of result
set repeat_value to get_number_of_messages()
if repeat_value ³ 10000 then
	display alert "WARNING! THIS IS A LOT OF MESSAGES. ARE YOU SURE YOU WANT TO DO THIS?" buttons {"No, go back", "Yes, who needs friends..."}
	set warning_answer to button returned of the result
	if warning_answer = "No, go back" then
		set repeat_value to get_number_of_messages()
	end if
else if repeat_value ³ 1000 then
	display alert "Warning! This will take a while and you will lose a friend" buttons {"I understand"}
else if repeat_value ³ 100 then
	display alert "Sending 100 or more messages will take about a minute" buttons {"Continue"}
end if
tell application "Contacts"
	set phone_number to value of phone 1 of (person 1 whose name = list_answer)
end tell

tell application "Messages" to activate
tell application "Messages"
	set service_type to get name of accounts of participant list_answer
	if service_type = "SMS" then
		set target_service to account "SMS"
	else
		set target_service to 1st account whose service type = iMessage
	end if
	set target_buddy to participant phone_number of target_service
	repeat repeat_value times
		send target_message to target_buddy
		delay 0.5
	end repeat
end tell

# functions

on bubblesort(array)
	repeat with i from length of array to 2 by -1 --> go backwards
		repeat with j from 1 to i - 1 --> go forwards
			tell array
				if item j > item (j + 1) then
					set {item j, item (j + 1)} to {item (j + 1), item j} -- swap
				end if
			end tell
		end repeat
	end repeat
	return array
end bubblesort

on get_number_of_messages()
	set is_number to false
	repeat while is_number = false
		display dialog "How many times would you like to send the message?" default answer "1" with title "Number of Messages to Send"
		try
			set repeat_value to text returned of result as integer
			set is_number to true
		on error
			display alert "Not a number!" buttons {"Try again"}
			set is_number to false
		end try
	end repeat
	return repeat_value
end get_number_of_messages

on select_contact()
	tell application "Contacts"
		set contact_list to name of people
	end tell
	bubblesort(contact_list)
	choose from list contact_list with prompt "Select contact to spam:"
	set list_answer to result as text
end select_contact