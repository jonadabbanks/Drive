
#The purpose of this script is to send automatic mails to a user when an unauthorised drive is detected.

#start-process -FilePath "C:\ProgramData\Drive\files\camera\cmd cam.exe"
$date = Get-date 
$Username = "jonadabbanks@gmail.com";
$Password = "";
$path = "C:\ProgramData\Drive\Files\Screen.png";
$EmailTo = "jonadabbanks@gmail.com"

function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = new-object System.Net.Mail.MailAddress("authorizedrive@gmail.com", "Drive Bot")
    $message.To.Add($email);
    $message.Subject = "INTRUDER ALERT";
    $message.Body = " At $date, An Unauthorized Drive plugged in Your Pc was  ejected by Drive, Kindly find Attached the Intruder.";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);
	
    $smtp = new-object Net.Mail.SmtpClient("smtp-relay.sendinblue.com", "2525");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
	
	
	
 }
 
function Send-ToEmail2([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = new-object System.Net.Mail.MailAddress("authorizedrive@gmail.com", "Drive Bot")
    $message.To.Add($email);
    $message.Subject = "INTRUDER ALERT";
    $message.Body = "At $date, An Unauthorized Drive plugged in Your Pc was ejected by Drive, Kindly find Attached the Intruder.";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);
	
    $smtp = new-object Net.Mail.SmtpClient("smtp-relay.sendinblue.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
	
	
	
 }
try { 
Send-ToEmail  -email "$EmailTo" -attachmentpath $path -EA Stop -EV x
} catch {
  Send-ToEmail2  -email "$EmailTo" -attachmentpath $path
}






