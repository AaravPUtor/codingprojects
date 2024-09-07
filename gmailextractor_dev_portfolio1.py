import imaplib, ssl, email, os
from getpass import getpass

#set any directory on user's system to store the file in, could also make a temporary directory
PATH_USE = r'/Users/aaravpradhan/Desktop/mail_store' #use directory file on system

#input values for username and password - password value masked
mail_user = input("Enter email: ")
mail_password = getpass() #obtain app password from gmail - regular user generated password will not work.

#create the mail instance by setting up a server that enables you to login to the email
mail = imaplib.IMAP4_SSL('imap.gmail.com')

mail.login(mail_user, mail_password)

mail.select('Inbox')
type, data = mail.search(None, 'ALL')
mylst = []
if data:
    ids = data[0]
    mail_lst = ids.split()
    for id_num in data[0].split():
        type, data = mail.fetch(id_num, '(RFC822)')
        raw_mail = data[0][1]
        raw_email_str = raw_mail.decode('utf-8')
        mail_msg = email.message_from_string(raw_email_str)
        for part in mail_msg.walk():
            if part.get_content_maintype() == 'multipart':
                continue
            if part.get('Content-Disposition') is None:
                continue
            fileName = part.get_filename()
            if id_num in mylst:
                pass
            else:
                mylst.append(id_num)

            if bool(fileName):
                final_path = os.path.join(PATH_USE, fileName)
                if not os.path.isfile(final_path):
                    fp = open(final_path, 'wb')
                    fp.write(part.get_payload(decode=True))
                    fp.close()
