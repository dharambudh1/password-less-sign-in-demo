# Password-less Sign-in Demo

## Information:
- This Flutter application uses Twilio Verify API for Phone Verification & SendGrid (a subsidiary of Twilio) Verify API for Email Verification.
- You don't need any backend servers to use this application. So, you don't need to worry about the backend part.
- You can read Twilio's free trial limitations from here: https://support.twilio.com/hc/en-us/articles/360036052753-Twilio-Free-Trial-Limitations

## Features:
- Methods for performing Password-less Sign-in using your phone number:
  - Verify the phone number via an SMS
  - Verify the phone number via a WhatsApp message
  - Verify the phone number via a Bot call

- Methods for performing Password-less Sign-in using your email address:
  - Verify the email address via an email (can send from the organization's email)

## Important:
- To perform Password-less Sign-in, replace my account's SID & auth token with your account's SID & auth token. You can find the highlighted code at: https://github.com/dharambudh1/passwordless-sign-in-demo/blob/main/lib/service/network_service.dart#L13-L14
 
## Useful links:
- Twilio: https://www.twilio.com/
- Sendgrid: https://sendgrid.com/
 
## Preview
![alt text](https://i.postimg.cc/3wXJp1Gw/imgonline-com-ua-twotoone-m-Fnl-ARHt-ZIZg.png "img")
