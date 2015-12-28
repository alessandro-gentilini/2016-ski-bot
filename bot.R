library(XML)
name=c()
email=c()

for ( j in seq(0,1534,10) ) {
  cl_options <- paste('--post-data "search=1&feratelSort=1&feratelOffset=',j,sep='')
  cl_options <- paste(cl_options,'"',sep='')
  download.file('http://www.oetztal.com/accommodation-list-winter#searchfilter','f0.html','wget',extra=cl_options)
  doc <- htmlParse('f0.html')
  for ( i in seq(1,10) ){
    name_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    name_xpath = paste(name_xpath,']/section[2]/a',sep='')
    name=c(name,xpathSApply(doc,name_xpath,xmlValue))
    
    email_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    email_xpath = paste(email_xpath,']/section[3]/p/a[2]',sep='')
    email=c(email,xpathSApply(doc,email_xpath,xmlValue))
  }
}

df<-data.frame(name=name,email=email)
print(df)
write.table(df,file="list.txt", row.names = FALSE, sep=",", quote=FALSE)