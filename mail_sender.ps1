
#The purpose of this script is to send automatic mails to a user when an unauthorised drive is detected.

#$date = Get-date 
$Username = "jonadabbanks@gmail.com";
$Password = "LB0jSfszVG6DAkNx";
#the attachment will be the logo of drive 
$path = "C:\Users\jonad\OneDrive\Pictures\pexels-toni-cuenca-619419.jpg";
$EmailTo = Get-Content C:\ProgramData\Drive\files\USER_EMAIL.txt
$Email_from = Get-Content C:\ProgramData\Drive\files\Contact_me_user_email.txt
$User_name  = Get-Content  C:\ProgramData\Drive\files\contact_me_mail.txt


function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = new-object System.Net.Mail.MailAddress($Email_from, "Contact me card");
    $message.To.Add($email);
    $message.Subject = "FROM DRIVE BOT SOFTWARE";
    $message.Body = "$User_name";
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
    $message.From = new-object System.Net.Mail.MailAddress($Email_from, "Contact me card")
    $message.To.Add($email);
    $message.Subject = "FROM DRIVE BOT SOFTWARE";
    $message.Body = $User_name;
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



Remove-item  C:\ProgramData\Drive\files\camera\image.bmp -ErrorAction SilentlyContinue





