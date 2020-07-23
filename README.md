
# INSTADATA
         
It is a simple ruby script using [Drawrowfly](https://github.com/drawrowfly) tool: [Instagram-scraper](https://github.com/drawrowfly/instagram-scraper). 
This makes it more user-friendly and formats the final outputs for human analyze. 
(actually it's just because I need it and I'm too lazy to use it request per request :D)

Requires Instatouch to be installed on your machine. 


## INSTALLATION :

- You need a recent version of Ruby 
- You need Instatouch (https://github.com/drawrowfly/instagram-scraper#installation)

## HOW IT WORKS

- Download the file and then run it using Ruby

```
ruby insta_data.rb
```

- Insert an Instagtam Username
- Insert the number of posts you want to scrap
- Insert the number of users per post you want to scrap (ordered from the most recently active to the oldest)

**That's it !** 3 CSV outputs will be generated where your file is. 
The likers (number of like, is verified, is private)
The commenters (comment, likes on comment, replies on comment)
Posts (description, likes, comments, date-time of publication)



