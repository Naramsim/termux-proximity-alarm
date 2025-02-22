#!/data/data/com.termux/files/usr/bin/bash

declare -r attachment="$1"
source config.env

if [ ! -f "$attachment" ]; then
  echo "Attachment not found!"
  exit 1
fi

if [ "$(head -n1 data/charging.sensor)" = 'true' ]; then
  exit 0
fi

curl -sS \
--url smtps://smtp.gmail.com:465 \
--ssl-reqd \
--mail-from "$gmail_auth" \
--mail-rcpt ${mail_rcpt//, / --mail-rcpt } \
--user "$gmail_auth" \
-F '=(;type=multipart/mixed' -F "=$mail2_object;type=text/html" \
-F "file=@$attachment;type=audio/mpeg;encoder=base64" -F '=)' \
-H "Subject: $mail2_subject" \
-H "From: Home <${gmail_auth%:*}>" \
-H "To: $mail_rcpt"