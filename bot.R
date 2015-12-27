doc <- htmlParse('accommodation-list-winter')
name=c()
email=c()
for ( i in seq(1,10) ){
  name_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
  name_xpath = paste(name_xpath,']/section[2]/a',sep='')
  name=c(name,xpathSApply(doc,name_xpath,xmlValue))
  
  email_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
  email_xpath = paste(email_xpath,']/section[3]/p/a[2]',sep='')
  email=c(email,xpathSApply(doc,email_xpath,xmlValue))
}

df<-data.frame(name=name,email=email)